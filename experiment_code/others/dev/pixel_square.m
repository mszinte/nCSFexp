% Psychtoolbox initialization
Screen('Preference', 'SkipSyncTests', 1); % Set to 0 for real experiments
Screen('Preference', 'VisualDebugLevel', 0);

% Open the main screen
screenID = max(Screen('Screens'));  % external screen if present
[win, winRect] = PsychImaging('OpenWindow', screenID, 0); % black background

% Size of the square
squareSize = 500; % pixels

% Color of the square (white)
white = WhiteIndex(win);

% Center of the screen
[xCenter, yCenter] = RectCenter(winRect);

% Rectangle of the square
squareRect = [0 0 squareSize squareSize];
squareRect = CenterRectOnPointd(squareRect, xCenter, yCenter);

% Draw the square
Screen('FillRect', win, white, squareRect);

% Flip to display
Screen('Flip', win);

% Wait for a key press to close
KbStrokeWait;

% Close the window
sca;