% Close all figures and clear command window
close all; clc;

% Main parameters
imageSize = 1080;
pixelSize = 0.01; % degree per pixel

% Spatial frequency filter paramaters
minFreq = 0.5;
maxFreq = 20;
stepFreq = 6;
overlapValue = 0.60;

% Orientation filter parameters
kappa = 0;
preferred_orientation_deg = 45;

% Contrast filter
C = 0.50; % Michelson contrast

% Define parameters
centers = logspace(log10(minFreq), log10(maxFreq), stepFreq); % Center frequencies

% Calculate sigma based on the desired overlap
logDiff = log10(centers(2)) - log10(centers(1));
sigma = sqrt(-logDiff^2 / (4 * log(overlapValue)));

% Plot Gaussian functions
x = logspace(log10(0.1), log10(70), 1000); % X values for plotting
figure('Position', [2000, 1500, 600, 450]);
hold on; colors = lines(stepFreq); % Initialize figure and colors
for i = 1:length(centers)
    plot(x, exp(-((log10(x) - log10(centers(i))).^2) / (2 * sigma^2)), 'Color', colors(i,:), 'LineWidth', 2);
end

% Customize plot
set(gca, 'XScale', 'log', 'XTick', centers, 'XTickLabel', arrayfun(@(x) sprintf('%.2f', x), centers, 'UniformOutput', false));
xlabel('Cycles per Degree'); ylabel('Amplitude'); title('Gaussian Filters in Logarithmic Scale');
xlim([0.1, 70]); grid on; hold off;

% Generate pink noise patterns
% Create a grid of spatial frequencies
[x, y] = meshgrid(-imageSize/2:imageSize/2-1, -imageSize/2:imageSize/2-1);
x = x / (imageSize * pixelSize); % Convert to cycles per degree
y = y / (imageSize * pixelSize); % Convert to cycles per degree
r = sqrt(x.^2 + y.^2); % Radial frequency

% Generate pink noise in frequency domain
pinkNoise = randn(imageSize); % White noise
pinkNoise = pinkNoise - mean(pinkNoise(:)); % Zero-mean
pinkNoise = pinkNoise / std(pinkNoise(:)); % Unit variance
pinkNoise_fft = fftshift(fft2(pinkNoise)); % Fourier transform
pinkNoise_fft = pinkNoise_fft ./ (r + 1e-5); % Apply 1/f filter (pink noise)

% Filter the pink noise with Gaussian and von Mises filters
filteredNoise = zeros(imageSize, imageSize, stepFreq);
preferred_orientation = deg2rad(preferred_orientation_deg); % Convert to radians
angles = atan2(y, x) - preferred_orientation; % Angular differences
vonMisesFilter = exp(kappa * cos(angles)); % Von Mises filter

for i = 1:stepFreq
    % Create Gaussian filter in frequency domain
    gaussianFilter = exp(-((log10(r) - log10(centers(i))).^2) / (2 * sigma^2));
    gaussianFilter = gaussianFilter / max(gaussianFilter(:)); % Normalize

    % Apply Gaussian and von Mises filters to pink noise
    filteredNoise_fft = pinkNoise_fft .* gaussianFilter .* vonMisesFilter;
    filteredNoise(:,:,i) = real(ifft2(ifftshift(filteredNoise_fft)));
end

% Normalize to [0, 1]
filteredNoise = (filteredNoise - min(filteredNoise(:))) / (max(filteredNoise(:)) - min(filteredNoise(:)));

% Apply Michelson contrast to each filtered noise pattern
for i = 1:stepFreq
    % Extract the current filtered noise pattern
    currentNoise = filteredNoise(:,:,i);

    % Compute mean value
    mean_value = mean(currentNoise(:));

    % Compute Lmax and Lmin
    Lmax = mean_value + (C / 2);
    Lmin = mean_value - (C / 2);

    % Apply Michelson contrast
    contrast_patch = (currentNoise - mean_value) * (Lmax - Lmin) + mean_value;

    % Store the contrast-adjusted pattern
    filteredNoise(:,:,i) = contrast_patch;
end

% Plot the filtered noise patterns
figure('Position', [2000, 0, 600, 800]);
for i = 1:stepFreq
    subplot(3, 2, i);
    imagesc(filteredNoise(:,:,i));
    caxis([0, 1]);
    colormap gray; axis image off;
    title(sprintf('Filtered Noise (%.2f c/deg)', centers(i)));
end
