function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch all function of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

tic;

% File director
const = dirSaveFile(const);

% Screen configurations
scr = scrConfig(const);

% Triggers and button configurations
my_key = keyConfig;

% Experimental constant
const = constConfig(scr, const);

% Experimental design
expDes = designConfig(const);

% Open screen window
[scr.main, scr.rect] = Screen('OpenWindow', scr.scr_num, ...
    const.background_color, [], scr.clr_depth, 2);
Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Priority(MaxPriority(scr.main));

% Initialize eye tracker
if const.tracker
    eyetrack = initEyeLink(scr,const);
else
    eyetrack = [];
end

% Draw and save all textures
if const.genStimuli; makeTextures(scr, const, expDes); end

% Trial runner
const = runExp(scr, const, expDes, my_key, eyetrack);

% End
overDone(const, my_key);

end