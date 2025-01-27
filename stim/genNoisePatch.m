function [noiseMatFiltNorm] = genNoisePatch(const, cutoff, kappa, mc_contrast)
% ----------------------------------------------------------------------
% [noiseMatFiltNorm] = genNoisePatch(const, cutoff, kappa, mc_contrast)
% ----------------------------------------------------------------------
% Goal of the function :
% Create noise patches with orientation and spatial frequency filtering
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% kappa : dispersion parameter of the von Mises filter
% mc_contrast : Michelson contrast
% cutoff : low and high cutoffs for bandpass filter (in cycles/DVA)
% ----------------------------------------------------------------------
% Output(s):
% noiseMatFiltNorm : filtered noise patch
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 22 / 01 / 2024
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------

% Constants
noiseDim = const.native_noise_dim;
preferred_orientation_deg = const.preferred_orientation_deg;
degree_per_pixels = const.noise_pixelVal; % DVA per pixel
low_cutoff = cutoff(1); % Low cutoff frequency in cycles/DVA
high_cutoff = cutoff(2); % High cutoff frequency in cycles/DVA

% Generate white noise
whiteNoise = randn(noiseDim(1), noiseDim(2));

% Precompute filters
[Y, X] = meshgrid(1:noiseDim(2), 1:noiseDim(1));
radius = sqrt((X - noiseDim(2) / 2).^2 + (Y - noiseDim(1) / 2).^2);
% Prevent division by zero at the center
radius(radius == 0) = eps;

% Pink noise filter
pink_filter = 1 ./ radius;

% Bandpass filter
low_cutoff_pix = low_cutoff / degree_per_pixels; % Convert cycles/DVA to pixels
high_cutoff_pix = high_cutoff / degree_per_pixels; % Convert cycles/DVA to pixels

bandpass_filter = (radius >= low_cutoff_pix) & (radius < high_cutoff_pix);

% Von Mises filter parameters
preferred_orientation = deg2rad(preferred_orientation_deg);
angles = atan2(Y - noiseDim(1) / 2, X - noiseDim(2) / 2) - preferred_orientation;
vonMisesFilter = exp(kappa * cos(angles));

% Combine filters
combined_filter = pink_filter .* bandpass_filter .* vonMisesFilter;
% Normalize combined filter to avoid excessive amplification/attenuation
combined_filter = combined_filter / max(combined_filter(:));

% Apply the combined filter in the frequency domain
whiteNoiseFFT = fftshift(fft2(whiteNoise));
filteredNoiseFFT = whiteNoiseFFT .* combined_filter;
filteredNoise = real(ifft2(ifftshift(filteredNoiseFFT)));

% Normalize to [0, 1]
filteredNoise = (filteredNoise - min(filteredNoise(:))) / (max(filteredNoise(:)) - min(filteredNoise(:)));

% Define Michelson contrast
mean_value = mean(filteredNoise(:));
Lmax = mean_value + (mc_contrast / 2);
Lmin = mean_value - (mc_contrast / 2);
contrast_patch = (filteredNoise - mean_value) * (Lmax - Lmin) + mean_value;

% Output the normalized filtered noise matrix
noiseMatFiltNorm = contrast_patch;
end

