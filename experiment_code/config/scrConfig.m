function [scr] = scrConfig(const)
% ----------------------------------------------------------------------
% [scr] = scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define configuration relative to the screen.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

% Number of the experimental screen:
scr.all = Screen('Screens');
if const.room == 1
    scr.scr_num = 2;
elseif  const.room == 2
    scr.scr_num = 0;
end

% Screen resolution (pixel):
[scr.scr_sizeX, scr.scr_sizeY] = Screen('WindowSize', scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i, %i]', const.desiredRes(1), const.desiredRes(2));
end

% Size of the display:
if const.room == 1
    % Settings for 7T MRI room
    % --------------------------
    scr.disp_sizeX = 807;                       % projection screen in mm
    scr.disp_sizeY = 454;                       % projection screen in mm
    scr.dist = 100;                             % screen distance in cm
    scr.x_mid = (scr.scr_sizeX / 2.0);          
    scr.y_mid = (scr.scr_sizeY / 2.0);
    scr.mid = [scr.x_mid, scr.y_mid];
    scr.disp_margin_top = 175;                  % not visible top part in pixel (using others/ruler_ver.png)
    scr.disp_margin_bottom = 300;               % not visible bottom part in pixel (using others/ruler_ver.png)
    
    % Set margin to 0 for demo
    if const.mkVideo == 1
        scr.disp_margin_top = 0;
        scr.disp_margin_bottom = 0;
    end
   
elseif const.room == 2
    % Settings for INT room
    % ---------------------
    scr.disp_sizeX = 696;                       % Display ++ INT
    scr.disp_sizeY = 391;                       % Display ++ INT
    scr.dist = 100;                             % screen distance in cm
    scr.x_mid = (scr.scr_sizeX / 2.0);
    scr.y_mid = (scr.scr_sizeY / 2.0);
    scr.mid = [scr.x_mid, scr.y_mid];
    scr.disp_margin_top = 0;
    scr.disp_margin_bottom = 0;
end

% Pixel size:
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame duration: (in seconds, fps)
scr.frame_duration = 1 / (Screen('FrameRate', scr.scr_num));
if scr.frame_duration == inf
    scr.frame_duration = 1 / const.desiredFD;
elseif scr.frame_duration == 0
    scr.frame_duration = 1 / const.desiredFD;
end

% Frame rate: (in hertz)
scr.hz = 1 / (scr.frame_duration);
if (scr.hz >= 1.1 * const.desiredFD || scr.hz <= 0.9 * const.desiredFD) && const.expStart && ~strcmp(const.sjct, 'DEMO')
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz', const.desiredFD);
end

% Screen preferences:
if ~const.expStart
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SyncTestSettings', 0.01, 50, 0.25);
else
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SyncTestSettings', 0.01, 50, 0.25);
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'Verbosity', 0);
end

% Get degrees per pixels
scr.screen_dpp = pix2vaDeg(1, scr);

end