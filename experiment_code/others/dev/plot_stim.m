% Psychtoolbox initialization
Screen('Preference', 'SkipSyncTests', 1); % Set to 0 for real experiments
Screen('Preference', 'VisualDebugLevel', 0);
KbName('UnifyKeyNames');

% Open the main screen
screenID = max(Screen('Screens'));  % external screen if present
[win, winRect] = PsychImaging('OpenWindow', screenID, [128, 128, 128]); % black background


% Load the .mat files
data1 = load('C:\Users\pstellmann\Documents\Experiments\nCSFexp\experiment_code\stim\screenshots\nCSFpsy/sfStim1_contStim12_noiseRand2_kappaNum14_ori1.mat');
data2 = load('C:\Users\pstellmann\Documents\Experiments\nCSFexp\experiment_code\stim\screenshots\nCSFpsy/sfStim3_contStim12_noiseRand2_kappaNum14_ori1.mat');

% Extract stimuli (change variable names if necessary)
stim1 = data1.screen_stim;
stim2 = data2.screen_stim;

% Convert to PTB textures
texture1 = Screen('MakeTexture', win, stim1);
texture2 = Screen('MakeTexture', win, stim2);

% Put textures in a cell for easy navigation
%textures = {texture1, texture2};
textures = {texture2, texture2};
current = 1; % start with the first image

% Initial draw
Screen('DrawTexture', win, textures{current}, [], []);
Screen('Flip', win);



Datapixx('Open') 
% Main loop
while true
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(KbName('r'))
            
            Datapixx('SetPropixxLedIntensity', 1)  
            Datapixx('RegWr')
            current = current + 1;
            if current > length(textures)
                current = length(textures);
            end
            Screen('DrawTexture', win, textures{current}, [], []);
            Screen('Flip', win);
            KbReleaseWait; % wait for key release
        elseif keyCode(KbName('b'))
            
            Datapixx('SetPropixxLedIntensity', 2)  
            Datapixx('RegWr')
            current = current - 1;
            if current < 1
                current = 1;
            end
            Screen('DrawTexture', win, textures{current}, [], []);
            Screen('Flip', win);
            KbReleaseWait;
        elseif keyCode(KbName('ESCAPE'))
            break; % exit loop
        end
    end
end

% Close the window
sca;