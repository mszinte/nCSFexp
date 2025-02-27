% Test script for genNoisePatch function
close all

addpath(fullfile(fileparts(mfilename('fullpath')), '..'))
% Main parameters
const.native_noise_dim = [1080, 1080];
const.noise_dpp = 0.01; % degree per pixel

% Spatial frequency filter paramaters
gauss_mu = 2;
gauss_sigma = 4;

% Orientation filter parameters
kappa = 0.1;
const.native_noise_orientation = 45;

% Contrast filter
mc_contrast = 0.05; % Michelson contrast

% Call the genNoisePatch function
noiseMatFiltNorm = genNoisePatch(const, gauss_mu, gauss_sigma, kappa, mc_contrast);




% % Initialisation de Psychtoolbox
% Screen('Preference', 'SkipSyncTests', 1); % Ignore sync tests
% Screen('Preference', 'SuppressAllWarnings', 1); % Suppress all warnings
% 
% % Obtenir les indices des écrans disponibles
% screens = Screen('Screens');
% 
% % Sélectionner le deuxième écran (index le plus élevé)
% screenNumber = max(screens);
% 
% % Ouvrir une fenêtre sur le deuxième écran
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);
% 
% % Dimensions de l'écran
% [screenXpixels, screenYpixels] = Screen('WindowSize', window);
% 
% % Création de la texture Psychtoolbox
% noiseTexture = Screen('MakeTexture', window, noiseMatFiltNorm * 255);
% 
% % Dessin du bruit sur l'écran
% Screen('DrawTexture', window, noiseTexture, [], []);
% 
% % Affichage de l'écran
% Screen('Flip', window);
% 
% % Attendre une touche pour fermer
% KbStrokeWait;
% 
% % Fermer la fenêtre et nettoyer
% Screen('CloseAll');


% Display the results
figure('Position', [100, 100, 540, 540]);
imagesc(noiseMatFiltNorm); % Affichage de l'image
colormap(gray); % Palette de couleurs en niveaux de gris
axis off; % Désactiver les axes
caxis([0, 1]); % Ajuster l'échelle des couleurs

% Optionally, save the output to a file
% imwrite(noiseMatFiltNorm, 'filtered_noise_patch.png');
