function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------

%% Experimental random variables

% Rand 1: stim orientation (2 modalities)
% =======
expDes.oneR             =   [1;2];
expDes.txt_rand1        =   {'cw','ccw','none'};
% 01 = tilt cw
% 02 = tilt ccw
% 03 = none

end