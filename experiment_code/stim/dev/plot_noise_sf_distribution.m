% ----------------------------------------------------------------------
% plot_noise_sf_distribution
% ----------------------------------------------------------------------
% Goal of the function :
% Generate pink noise with different gaussian filter in SF domain and check
% the final distributionof SF
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% non
% ----------------------------------------------------------------------
% Function created by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% ----------------------------------------------------------------------

close all; 
clear all;

addpath(fullfile(fileparts(mfilename('fullpath')), '..'))

% Define the figure save directory relative to "experiment_code"
base_dir = fullfile(fileparts(mfilename('fullpath')), '..', '..');
save_dir = fullfile(base_dir, 'others', 'sf_distribution');

% Create the folder if it does not exist
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% Main parameters
const.native_noise_dim = [1080, 1080]; 
const.noise_dpp = 0.01;
seed = 42;


% Spatial frequency filter paramaters
minFreq = 0.5;
maxFreq = 20;
stepFreq = 6;
overlapValue = 0.60;
centers = logspace(log10(minFreq), log10(maxFreq), stepFreq); 
logDiff = log10(centers(2)) - log10(centers(1));
sigma = sqrt(-logDiff^2 / (4 * log(overlapValue)));


% Kappa
const.num_steps_kappa = 15;                                                 % Number of kappa steps in pRF task
const.noise_kappa = [0, 10.^(linspace(-1, 1.5, ...
                                      const.num_steps_kappa-1))];           % Von misses filter kappa parameter (1st = noise, last = less noisy) in pRF

const.num_steps_kappa_used = 2;                                             % kappa level used in nCSF task
const.kappa_noise_num = 1;                                                  % kappa for noise texture
const.kappa_probe_num = 10;
const.kappas = [const.noise_kappa(const.kappa_noise_num), ...
                const.noise_kappa(const.kappa_probe_num)];

% orientation
const.noise_orientations = [45, -45];

% contrast
const.minCont = 0.0025;                                                     % Minimal Michelson contrast value
const.maxCont = 0.8;                                                        % Maximal Michelson contrast value
const.contNum = 6;                                                          % Number of Michelson contrast value
const.contValues = logspace(log10(const.minCont), ...                       % Michelson contrast values
    log10(const.maxCont), const.contNum);

% Plot theoretical Gaussian functions
x = logspace(log10(0.1), log10(70), 1000); % X values for plotting
figure('Position', [2000, 1500, 600, 450]);
hold on; colors = lines(stepFreq); % Initialize figure and colors
for i = 1:length(centers)
    plot(x, exp(-((log10(x) - log10(centers(i))).^2) / (2 * sigma^2)),...
        'Color', colors(i,:), 'LineWidth', 2);
end

% Customize plot
set(gca, 'XScale', 'log', 'XTick', centers, 'XTickLabel', arrayfun(@(x)...
    sprintf('%.2f', x), centers, 'UniformOutput', false));
xlabel('Cycles per Degree'); ylabel('Amplitude'); ...
    title('Gaussian Filters in Logarithmic Scale');
xlim([0.1, 70]); grid on; hold off;
for cont = 1:const.contNum 
    contrast = const.contValues(cont);
    for kappaNum = 1:const.num_steps_kappa_used
        kappa = const.kappas(kappaNum);
        for ori = 1:length(const.noise_orientations)
            orientation = const.noise_orientations(ori);

            % Plot noise distribution
            figure; hold on;
            colors = lines(length(centers));
            
            for i = 1:length(centers)
                gauss_mu = centers(i);
            
                % generate noise
                filtered_contrastedNoise = genNoisePatch(const, gauss_mu, ...
                                                         sigma, kappa, orientation, contrast, seed);

                % Fourier transform
                filteredNoise_fft = fftshift(fft2(filtered_contrastedNoise));
            
                % spatial frequency histogram
                nb_bins = 500;  
                [x, y] = meshgrid(-const.native_noise_dim(2)/2:const.native_noise_dim(2)/2-1, ...
                                  -const.native_noise_dim(1)/2:const.native_noise_dim(1)/2-1);
                x = x / (const.native_noise_dim(2) * const.noise_dpp);
                y = y / (const.native_noise_dim(1) * const.noise_dpp);
                r = sqrt(x.^2 + y.^2);
            
                r(r == 0) = NaN;  
                max_cpd = max(r(:), [], 'omitnan');
                edges_cpd = linspace(0, max_cpd, nb_bins+1);  
                bin_centers_cpd = (edges_cpd(1:end-1) + edges_cpd(2:end)) / 2;  
            
                valid_indices = ~isnan(r(:));
                amplitude_distribution_cpd = accumarray(discretize(r(valid_indices), ...
                    edges_cpd), abs(filteredNoise_fft(valid_indices)), [nb_bins, 1]);  
            
                % Normalisation
                proportion_distribution_cpd = amplitude_distribution_cpd / ...
                    max(amplitude_distribution_cpd, [], 'omitnan');  
            
                % plot
                plot(bin_centers_cpd, proportion_distribution_cpd, ...
                    'Color', colors(i, :), 'LineWidth', 2, 'DisplayName',...
                    sprintf('\\mu = %.2f', gauss_mu));
            end
            
            % Customize plot
            set(gca, 'XScale', 'log', 'XTick', centers, 'XTickLabel',...
                arrayfun(@(x) sprintf('%.2f', x), centers, 'UniformOutput', false));
            title(sprintf(['Spatial frequency distribution after filtering...' ...
                ' with %.2f contrast - %.2f kappa - %d orientation'], contrast, kappa, orientation));
            xlim([0, 70]); grid on; hold off;

            % Save the figure
            file_name = sprintf('%.2f-contrast_%.2f-kappa_%d-orientation.png', ...
                contrast, kappa, orientation);
            file_path = fullfile(save_dir, file_name);
            saveas(gcf, file_path);
        end
    end
end