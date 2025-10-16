%% General experimenter launcher
%  =============================
% By :      Uriel LASCOMBES
% Projet :  nCSFexp
% With :    Martin SZINTE

% Version description
% ===================
% Experiment in which we use filtered pink noise at bifferent spatial 
% frequency ranges and different contrast levels to determine the neural 
% Contrast Sensitivity Function (nCSF). The experiment is adapted for the 
% 7T CRMBM scanner. A cross is displayed across the entire screen to help 
% the patient maintain correct fixation.

% Procedure to start
% ------------------
% - Turn on the computer and log in
% - Turn on the Datapixx 3, then the projector
% - Open LabMaestro => double-click on Propix => set LED intensity to 50%
% - Launch the code, give instructions, it will wait for the first TR

% First settings
% --------------
Screen('CloseAll'); clear all; clear mex; clear functions; close all; home; 
AssertOpenGL; 

% General settings
% ----------------
const.task = 'nCSF';                        % Name of the task
const.runTotal = 11;                        % Number of runs to play
const.expStart = 1;                         % Start of a recording exp                          0 = NO  , 1 = YES
const.checkTrial = 0;                       % Print trial conditions (for debugging)            0 = NO  , 1 = YES
const.genStimuli = 0;                       % Generate the stimuli                              0 = NO  , 1 = YES
const.drawStimuli = 0;                      % Draw stimuli generated                            0 = NO  , 1 = YES
const.mkVideo = 0;                          % Make a video of a run                             0 = NO  , 1 = YES

% External controls
% -----------------
const.scanner = 0;                          % Run in MRI scanner                                0 = NO  , 1 = YES
const.scannerTest = 0;                      % Run with T returned at TR time                    0 = NO  , 1 = YES
const.room = 1;                             % Run in MRI or eye-tracking room                   1 = MRI , 2 = eye-tracking
const.psy = 1;                              % Run psychophysics or MRI task                     0 = MRI , 1 = Psy
const.training = 0;                         % Training session                                  0 = NO  , 1 = YES


% Warning before deleting stim
% -----------------------------
if const.genStimuli == 1
    disp('You are about to delete the previous stimulus and regenerate a new one.');
    reply = input('Do you want to continue? (Y/N): ', 's');
    
    % Normalize user input (remove spaces and lowercase)
    reply = strtrim(lower(reply));
    
    if ismember(reply, {'y', 'yes', 'Y', 'Yes','YES'})
        disp('Proceeding with stimulus regeneration...');
        % Continue the script normally
        
    elseif ismember(reply, {'n', 'no','N','No','NO'})
        disp('Operation cancelled. Script terminated.');
        return;  % Stop the entire script
        
    else
        disp('Invalid input. Script terminated.');
        return;  % Stop the entire script
    end
end

% Desired screen setting
% ----------------------
if const.training; const.desiredFD = 120;    % Desired refresh rate for training on laptop
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