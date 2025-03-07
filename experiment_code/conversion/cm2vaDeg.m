function [vaDeg] = cm2vaDeg (cm, scr)
% ----------------------------------------------------------------------
% [vaDeg] = cm2vaDeg(cm,scr)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert cm in visual angle (degree)
% ----------------------------------------------------------------------
% Input(s) :
% cm = size in cm                                   ex : cm = 2.0
% scr  = screen configuration : scr.dist(cm)        ex : scr.dist = 60
% ----------------------------------------------------------------------
% Output(s):
% vaDeg = size in visual angle (degree)             ex : vaDeg = 2.5
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

vaDeg = cm ./ (2 * scr.dist * tan(0.5 * pi / 180));

end
