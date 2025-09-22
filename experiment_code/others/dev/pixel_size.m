% Psychtoolbox initialization
Screen('Preference', 'SkipSyncTests', 1); % Set to 0 for real experiments
Screen('Preference', 'VisualDebugLevel', 0);

% Open the main screen
screenID = max(Screen('Screens'));  % external screen if present
[win, winRect] = PsychImaging('OpenWindow', screenID, 0); % black background

% Load the .mat files
data1 = load('/Users/uriel/Desktop/nCSFpsy_r1_8-20/sfStim4_contStim12_noiseRand3_kappaNum10_ori2.mat');
data2 = load('/Users/uriel/Desktop/nCSFpsy_scanner_8-20/sfStim4_contStim12_noiseRand3_kappaNum10_ori2.mat');

% Extract stimuli (change variable names if necessary)
stim1 = data1.screen_stim;
stim2 = data2.screen_stim;

% Convert to PTB textures
texture1 = Screen('MakeTexture', win, stim1);
texture2 = Screen('MakeTexture', win, stim2);

% Put textures in a cell for easy navigation
textures = {texture1, texture2};
current = 1; % start with the first image

% Initial draw
Screen('DrawTexture', win, textures{current}, [], []);
Screen('Flip', win);

% Main loop
while true
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(KbName('RightArrow'))
            current = current + 1;
            if current > length(textures)
                current = length(textures);
            end
            Screen('DrawTexture', win, textures{current}, [], []);
            Screen('Flip', win);
            KbReleaseWait; % wait for key release
        elseif keyCode(KbName('LeftArrow'))
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