function [noiseMatFiltNorm] = genNoisePatch(const, cutoff, kappa, mc_contrast)
% Constants
noiseDim = const.native_noise_dim;
preferred_orientation_deg = const.preferred_orientation_deg;
degree_per_pixels = const.noise_pixelVal; % DVA per pixel
low_cutoff = cutoff(1); % Low cutoff frequency in cycles/DVA
high_cutoff = cutoff(2); % High cutoff frequency in cycles/DVA

% Main parameters
imageSize = const.native_noise_dim;
pixelSize = const.noise_pixelVal; % degree per pixel

% Spatial frequency filter paramaters
minFreq = cutoff(1);
maxFreq = cutoff(2);

% Orientation filter parameters
kappa = kappa;
preferred_orientation_deg = const.preferred_orientation_deg;

% Contrast filter
C = mc_contrast; % Michelson contrast

% Define parameters
centers = logspace(log10(minFreq), log10(maxFreq), stepFreq); % Center frequencies

% Calculate sigma based on the desired overlap
logDiff = log10(centers(2)) - log10(centers(1));
sigma = sqrt(-logDiff^2 / (4 * log(overlapValue)));


end