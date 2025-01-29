% ----------------------------------------------------------------------
% noiseDemo (modifié pour afficher sur un deuxième écran)
% ----------------------------------------------------------------------
screenWidthMeters = 0.596; 
screenHeightMeters = 0.335;
viewingDistanceMeters = 0.57;


screenWidthPixels = 1920; 
screenHeightPixels = 1080; 


pixelSizeMeters = screenWidthMeters / screenWidthPixels;


degreesPerPixel = 2 * atan((pixelSizeMeters / 2) / viewingDistanceMeters) * (180 / pi);

% Constantes
const.native_noise_dim = [1080, 1080];
const.preferred_orientation_deg = 45;
const.noise_pixelVal = 1; % degrees per pixel
mc_contrast = 1; % Michelson contrast
kappa = 0.01; % Dispersion parameter for von Mises filter

% Définir les limites de la bande passante (cutoff frequencies en cycles/DVA)
low_cutoff = 0.4; % Exemple de valeur basse
high_cutoff = 1.3; % Exemple de valeur haute
cutoff = [low_cutoff, high_cutoff];

% Générer le bruit
noiseMatFiltNorm = genNoisePatch(const, cutoff, kappa, mc_contrast);

% Créer une figure et ajuster les paramètres d'affichage
figure('Position', [100, 100, 540, 540]);
imagesc(noiseMatFiltNorm); % Affichage de l'image
colormap(gray); % Palette de couleurs en niveaux de gris
axis off; % Désactiver les axes
caxis([0, 1]); % Ajuster l'échelle des couleurs
title(['Kappa = ', num2str(kappa), ...
       ', Orientation = ', num2str(const.preferred_orientation_deg), ...
       '°, Bandpass = [', num2str(low_cutoff), ' - ', num2str(high_cutoff), ...
       '] cycles/degree, Michelson Contrast = ', num2str(mc_contrast)]);



% % Initialisation de Psychtoolbox
% Screen('Preference', 'SkipSyncTests', 1);
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
% 
% 
% 
% 
% 
