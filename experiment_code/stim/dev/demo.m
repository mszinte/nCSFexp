close all; 
clear all;

want_psytoolbox = false;

% Main parameters
const.native_noise_dim = [1080, 1080]; 
const.noise_dpp = 0.1;
const.native_noise_orientation = 45;

% Spatial frequency filter parameters
gauss_mu = 2;
gauss_sigma = 0.1;
kappa = 100;
mc_contrast = 0.1;
seed = 42;

% Generate filtered noise
filtered_contrastedNoise = genNoisePatch(const, gauss_mu, gauss_sigma, kappa, mc_contrast, seed);

% Plot with Psychtoolbox
if want_psytoolbox
    % Initialize Psychtoolbox
    Screen('Preference', 'SkipSyncTests', 1); % Ignore sync tests
    Screen('Preference', 'SuppressAllWarnings', 1); % Suppress all warnings

    % Get available screen indices
    screens = Screen('Screens');

    % Select the second screen (highest index)
    screenNumber = max(screens);

    % Open a window on the second screen
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);

    % Screen dimensions
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);

    % Create Psychtoolbox texture
    noiseTexture = Screen('MakeTexture', window, noiseMatFiltNorm * 255);

    % Draw noise on the screen
    Screen('DrawTexture', window, noiseTexture, [], []);

    % Display the screen
    Screen('Flip', window);

    % Wait for a key press to close
    KbStrokeWait;

    % Close the window and clean up
    Screen('CloseAll');

% Regular plot
else 
    % Display the stimulus
    figure;
    imshow(filtered_contrastedNoise, []);
    colormap(gray);
    caxis([0, 1]);
    title('Filtered Noise Image');
    
    % ---- FOURIER SPECTRUM ----
    
    % Compute Fourier spectrum of the filtered noise
    filteredNoise_fft = fftshift(fft2(filtered_contrastedNoise));
    
    % Display the Fourier spectrum
    figure;
    imshow(log(1 + abs(filteredNoise_fft)), []);
    xlabel('Horizontal Frequency (cycles per degree)');
    ylabel('Vertical Frequency (cycles per degree)');
    title('Fourier Spectrum after Filtering');
    
    % ---- HISTOGRAM OF SPATIAL FREQUENCY DISTRIBUTION ----
    
    % Define bins for the histogram
    nb_bins = 100;  
    [x, y] = meshgrid(-const.native_noise_dim(2)/2:const.native_noise_dim(2)/2-1, -const.native_noise_dim(1)/2:const.native_noise_dim(1)/2-1);
    x = x / (const.native_noise_dim(2) * const.noise_dpp);
    y = y / (const.native_noise_dim(1) * const.noise_dpp);
    r = sqrt(x.^2 + y.^2);
    
    max_cpd = max(r(:));  
    edges_cpd = linspace(0, max_cpd, nb_bins+1);  
    bin_centers_cpd = (edges_cpd(1:end-1) + edges_cpd(2:end)) / 2;  
    
    % Compute the distribution of amplitudes as a function of spatial frequencies
    amplitude_distribution_cpd = accumarray(discretize(r(:), edges_cpd), abs(filteredNoise_fft(:)), [nb_bins, 1]);  
    
    % Normalize in percentage
    proportion_distribution_cpd = (amplitude_distribution_cpd / sum(amplitude_distribution_cpd)) * 100;  
    
    % Display the histogram of spatial frequencies
    figure;
    bar(bin_centers_cpd, proportion_distribution_cpd, 'hist');
    set(gca, 'XScale', 'log');
    xlabel('Spatial Frequency (cycles per degree)');
    ylabel('Frequency Proportion (%)');
    title('Histogram of Spatial Frequencies after Filtering');
    xlim([0 10]);
    
    % Update ticks for better readability
    xt = get(gca, 'XTick');  
    set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.2f', x), xt, 'UniformOutput', false));
end
