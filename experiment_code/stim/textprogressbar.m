function textprogressbar(c)
% ----------------------------------------------------------------------
% textprogressbar(c)
% ----------------------------------------------------------------------
% Goal of the function :
% Creates a text-based progress bar in the command window.
% It should be called with a string argument to initialize and terminate.
% Otherwise, a numeric value representing the progress percentage should be 
% supplied.
% ----------------------------------------------------------------------
% Input(s) :
% c : Either a text string to initialize or terminate the progress bar, 
%     or a numeric value representing the percentage progress.
% ----------------------------------------------------------------------
% Output(s) :
% none
% ----------------------------------------------------------------------
% Function created by Paul Proteus (e-mail: proteus.paul (at) yahoo (dot) com)
% Inspired by: http://blogs.mathworks.com/loren/2007/08/01/monitoring-progress-of-a-calculation/
% ----------------------------------------------------------------------

%% Initialization
persistent strCR;           % Carriage return persistent variable

% Visualization parameters
strPercentageLength = 10;   % Length of percentage string (must be >5)
strDotsMaximum = 10;        % The total number of dots in a progress bar

%% Main

if isempty(strCR) && ~ischar(c),
    % Progress bar must be initialized with a string
    error('The text progress must be initialized with a string');
elseif isempty(strCR) && ischar(c),
    % Progress bar - initialization
    fprintf('%s', c);
    strCR = -1;
elseif ~isempty(strCR) && ischar(c),
    % Progress bar - termination
    strCR = [];
    fprintf([c '\n']);
elseif isnumeric(c)
    % Progress bar - normal progress
    c = floor(c);
    percentageOut = [num2str(c) '%%'];
    percentageOut = [percentageOut repmat(' ', 1, strPercentageLength - length(percentageOut) - 1)];
    nDots = floor(c / 100 * strDotsMaximum);
    dotOut = ['[' repmat('.', 1, nDots) repmat(' ', 1, strDotsMaximum - nDots) ']'];
    strOut = [percentageOut dotOut];
    
    % Print it on the screen
    if strCR == -1,
        % Don't do carriage return during first run
        fprintf(strOut);
    else
        % Do it during all the other runs
        fprintf([strCR strOut]);
    end
    
    % Update carriage return
    strCR = repmat('\b', 1, length(strOut) - 1);
    
else
    % Any other unexpected input
    error('Unsupported argument type');
end