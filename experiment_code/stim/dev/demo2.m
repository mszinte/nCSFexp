close all; 
clear all;

addpath(fullfile(fileparts(mfilename('fullpath')), '..'))

% Main parameters
const.native_noise_dim = [1080, 1080]; 
const.noise_dpp = 0.1;
const.native_noise_orientation = 45;

% Spatial frequency filter parameters
gauss_mu = 1;
gauss_sigma = 0.2242;
kappa = 100;
mc_contrast = 1;
seed = 42;


% Spatial frequency filter paramaters
minFreq = 0.5;
maxFreq = 20;
stepFreq = 6;
overlapValue = 0.60;

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



% Generate filtered noise
filtered_contrastedNoise = genNoisePatch(const, gauss_mu, gauss_sigma, kappa, mc_contrast, seed);

% ---- FOURIER SPECTRUM ----

% Compute Fourier spectrum of the filtered noise
filteredNoise_fft = fftshift(fft2(filtered_contrastedNoise));

% ---- HISTOGRAM OF SPATIAL FREQUENCY DISTRIBUTION ----

% Define bins for the histogram
nb_bins = 200;  
[x, y] = meshgrid(-const.native_noise_dim(2)/2:const.native_noise_dim(2)/2-1, -const.native_noise_dim(1)/2:const.native_noise_dim(1)/2-1);
x = x / (const.native_noise_dim(2) * const.noise_dpp);
y = y / (const.native_noise_dim(1) * const.noise_dpp);
r = sqrt(x.^2 + y.^2);

% Exclude the zero frequency
r(r == 0) = NaN;  % Remplacez les valeurs de fréquence zéro par NaN

max_cpd = max(r(:), [], 'omitnan');  % Ignorez NaN lors de la recherche du maximum
edges_cpd = linspace(0, max_cpd, nb_bins+1);  
bin_centers_cpd = (edges_cpd(1:end-1) + edges_cpd(2:end)) / 2;  

% Compute the distribution of amplitudes as a function of spatial frequencies
% Exclude NaN values
valid_indices = ~isnan(r(:));  % Indices valides
amplitude_distribution_cpd = accumarray(discretize(r(valid_indices), edges_cpd), abs(filteredNoise_fft(valid_indices)), [nb_bins, 1]);  

% Normalize to [0, 1]
proportion_distribution_cpd = amplitude_distribution_cpd / sum(amplitude_distribution_cpd, 'omitnan');  

% Display the distribution curve
figure;
plot(bin_centers_cpd, proportion_distribution_cpd, 'LineWidth', 2);
set(gca, 'XScale', 'log');
xlabel('Spatial Frequency (cycles per degree)');
ylabel('Frequency Proportion (0 to 1)');
title('Distribution Curve of Spatial Frequencies after Filtering (Excluding Zero Frequency)');
xlim([0 20]);

% Update ticks for better readability
xt = get(gca, 'XTick');  
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.2f', x), xt, 'UniformOutput', false));
