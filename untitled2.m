close all; % Close all existing figures

% Define parameters
numGaussians = 6; % Number of Gaussian distributions
stdDev = 1; % Standard deviation
means = linspace(1, 20, numGaussians); % Linearly increasing means from 1 to 20

% Generate Gaussian distributions
x = -10:0.1:30; % Define the range for the x-axis
gaussians = zeros(numGaussians, length(x)); % Initialize matrix to store Gaussian values

% Loop through each mean and create the Gaussian distribution
for i = 1:numGaussians
    gaussians(i, :) = exp(-(x - means(i)).^2 / (2 * stdDev^2)) / (stdDev * sqrt(2 * pi));
end

% Plot the Gaussian distributions
figure;

% First subplot: Linear scale
subplot(2, 1, 1);
hold on;
for i = 1:numGaussians
    plot(x, gaussians(i, :), 'DisplayName', ['Mean = ', num2str(means(i))]);
end
hold off;
legend;
title('Gaussian Distributions with Linearly Increasing Means (Linear Scale)');
xlabel('Cycles per Degree');
ylabel('Amplitude');

% Second subplot: Log10 scale
subplot(2, 1, 2);
hold on;
for i = 1:numGaussians
    plot(log10(x(x > 0)), gaussians(i, x > 0), 'DisplayName', ['Mean = ', num2str(means(i))]); % Only plot x > 0 for log scale
end
hold off;
legend;
title('Gaussian Distributions with Linearly Increasing Means (Log10 Scale)');
xlabel('Log10(Cycles per Degree)');
ylabel('Amplitude');