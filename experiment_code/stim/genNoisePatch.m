function [filtered_contrastedNoiseLum] = genNoisePatch(const, gauss_mu, ...
    gauss_sigma, kappa, preferred_orientation_deg, mc_contrast, seed)
% ----------------------------------------------------------------------
% [filtered_contrastedNoiseLum] = genNoisePatch(const, gauss_mu, 
%                                 gauss_sigma, kappa, mc_contrast, seed)
% ----------------------------------------------------------------------
% Goal of the function :
% Create noise patches with SP, orientation filtering, contrast and 
% luminance definition
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% gauss_mu : center of the gaussian filter
% gauss_sigma : sigma of the gaussian filter
% kappa : dispersion parameter of the von misses filter
% mc_contrast : value of Michelson Contrast
% seed : seed for random process 
% ----------------------------------------------------------------------
% Output(s):
% filtered_contrastedNoise: patch of noise
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

% Main parameters
rng(seed)
noise_size = const.native_noise_dim;
pixelSize = const.noise_dpp; % degree per pixel

% Spatial frequency filter paramaters
center = gauss_mu;
sigma = gauss_sigma;

% Generate pink noise patterns
% Create a grid of spatial frequencies
[x, y] = meshgrid(-noise_size(1)/2:noise_size(1)/2-1, -noise_size(2)/2:noise_size(2)/2-1);
x = x / (noise_size(1) * pixelSize); % Convert to cycles per degree
y = y / (noise_size(2) * pixelSize); % Convert to cycles per degree
r = sqrt(x.^2 + y.^2); % Radial frequency

% Generate pink noise in frequency domain
whiteNoise = randn(noise_size(1)); % White noise
pinkNoise = whiteNoise - mean(whiteNoise(:)); % Zero-mean
pinkNoise = pinkNoise / std(pinkNoise(:)); % Unit variance
pinkNoise_fft = fftshift(fft2(pinkNoise)); % Fourier transform
pinkNoise_fft = pinkNoise_fft ./ (r + 1e-5); % Apply 1/f filter (pink noise)

% Filter the pink noise with Gaussian and von Mises filters
filteredNoise = zeros(noise_size(1), noise_size(2));
preferred_orientation = deg2rad(preferred_orientation_deg); % Convert to radians
angles = atan2(y, x) - preferred_orientation; % Angular differences
vonMisesFilter = exp(kappa * cos(angles)); % Von Mises filter

% Create Gaussian filter in frequency domain
gaussianFilter = exp(-((log10(r) - log10(center)).^2) / (2 * sigma^2));
gaussianFilter = gaussianFilter / max(gaussianFilter(:)); % Normalize

% Apply Gaussian and von Mises filters to pink noise
filteredNoise_fft = pinkNoise_fft .* gaussianFilter .* vonMisesFilter;
filteredNoise(:,:) = real(ifft2(ifftshift(filteredNoise_fft)));

% Normalize to [0, 1]
filteredNoise = (filteredNoise - min(filteredNoise(:))) / (max(filteredNoise(:)) - min(filteredNoise(:)));

% Apply Michelson contrast to each filtered noise pattern

% Compute mean value
mean_value = mean(filteredNoise(:));

% Compute Lmax and Lmin
Lmax = mean_value + (mc_contrast / 2);
Lmin = mean_value - (mc_contrast / 2);

% Apply Michelson contrast
filtered_contrastedNoise = (filteredNoise - mean_value) * (Lmax - Lmin) + mean_value;

% Apply mean luminance
targetLuminance = const.mean_luminance;
currentLuminance = mean(filtered_contrastedNoise(:));
filtered_contrastedNoiseLum = filtered_contrastedNoise * (targetLuminance / currentLuminance);

end