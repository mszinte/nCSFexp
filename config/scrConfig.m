function [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define configuration relative to the screen
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------

% Number of the exp screen :
scr.all                 =   Screen('Screens');
scr.scr_num             =   1;%min(scr.all);

% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY]...
                        =   Screen('WindowSize', scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

% Size of the display :
if const.room == 1
    % Settings 7T MRI room
    % --------------------
    scr.disp_sizeX = 773;                       % setting for BOLDScreen32' 7T in mm
    scr.disp_sizeY = 435;                       % setting for BOLDScreen32' 7T in mm
    
    scr.disp_margin_top = 7.05;                 % top margin where projection screen is not visible in cm (175 px on ruler)
    scr.disp_margin_bottom = 12.08;             % bottom margin where projection screen is not visible in cm

elseif const.room == 2
    % Settings eyelink room
    % ---------------------
    scr.disp_sizeX = 696;                       % setting for Display ++ INT
    scr.disp_sizeY = 391;                       % setting for Display ++ INT
end

% Pixels size:
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate : (fps)
scr.frame_duration      =   1/(Screen('FrameRate',scr.scr_num));
if scr.frame_duration == inf
    scr.frame_duration  = 1/const.desiredFD;
elseif scr.frame_duration == 0
    scr.frame_duration  = 1/const.desiredFD;
end

% Frame rate : (hertz)
scr.hz                  =   1/(scr.frame_duration);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart && ~strcmp(const.sjct,'DEMO')
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end

if ~const.expStart
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
    %Screen('Preference', 'SkipSyncTests', 1);
else
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
    Screen('Preference','SuppressAllWarnings', 1);
    Screen('Preference','Verbosity', 0);
end

% Subject dist
if const.room == 1
    
    % Settings 7T MRI room
    % --------------------
    
    % Screen distance 
    scr.dist = 102;                                                        % general screen distance in cm

    % Center of the screen :
    scr.x_mid               =   (scr.scr_sizeX/2.0);
    scr.y_mid               =   (scr.scr_sizeY/2.0);
    scr.mid                 =   [scr.x_mid,scr.y_mid];

elseif const.room == 2
    
    % Settings eyelink room
    % ---------------------
    
    % Screen distance 
    scr.dist                =   108;                                       % general screen distance in cm (value to mimic screen scaner)

    % Center of the screen :
    scr.x_mid               =   (scr.scr_sizeX/2.0);
    scr.y_mid               =   (scr.scr_sizeY/2.0);
    scr.mid                 =   [scr.x_mid,scr.y_mid];

end
scr.screen_dpp              =   pix2vaDeg(1, scr);                         % Size of one screen pixel in DVA
end