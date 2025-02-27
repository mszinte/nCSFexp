 %% General experimenter launcher
%  =============================
% By :      Uriel LASCOMBES
% Projet :  nCSFexp
% With :    Martin SZINTE

% Version description
% ===================
% Experiment in which we use filtered pink noise at different spatial 
% frequency ranges and different contrast levels to determine the neural 
% Contrast Sensitivity Function (nCSF). The experiment is adapted for the 
% 7T CRMBM scanner. A cross is displayed across the entire screen to help 
% the patient maintain correct fixation.

% Procedure to start
% ------------------
% - turn on projector and propixx
% - turn on computer
% - turn on monitor
% - Start session
% - Launch code, pass instructions, it will wait for first TR

% First settings
% --------------
Screen('CloseAll'); clear all; clear mex; clear functions; close all; home; 
AssertOpenGL; 

% General settings
% ----------------
const.task = 'nCSF';                        % Name of the task
const.expStart = 0;                         % Start of a recording exp                          0 = NO  , 1 = YES
const.checkTrial = 0;                       % Print trial conditions (for debugging)            0 = NO  , 1 = YES
const.genStimuli = 0;                       % Generate the stimuli                              0 = NO  , 1 = YES
const.drawStimuli = 0 ;                      % Draw stimuli generated                            0 = NO  , 1 = YES
const.mkVideo = 0;                          % Make a video of a run                             0 = NO  , 1 = YES

% External controls
% -----------------
const.scanner = 0;                          % Run in MRI scanner                                0 = NO  , 1 = YES
const.scannerTest = 0;                      % Run with T returned at TR time                    0 = NO  , 1 = YES
const.room = 1;                             % Run in MRI or eye-tracking room                   1 = MRI , 2 = eye-tracking
const.training = 0;                         % Training session                                  0 = NO  , 1 = YES

% Desired screen setting
% ----------------------
if const.training; const.desiredFD = 60;    % Desired refresh rate for training on laptop
else; const.desiredFD = 120;                % Desired refresh rate on propixx screen
end
const.desiredRes = [1920,1080];             % Desired resolution

% Path
% ----
dir = (which('expLauncher'));
cd(dir(1:end-18));

% Add Matlab path
% ---------------
addpath('config', 'main', 'conversion', 'instructions', 'trials', 'stim');

% Subject configuration
% ---------------------
[const] = sbjConfig(const);
                        
% Main run
% --------
main(const);