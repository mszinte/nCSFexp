function [cm] = vaDeg2cm (vaDeg, scr)
% ----------------------------------------------------------------------
% [cm] = vaDeg2cm (vaDeg, dist)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert visual angle (degree) in cm
% ----------------------------------------------------------------------
% Input(s) :
% vaDeg = size in visual angle (degree)             ex : deg = 2.0
% scr  = screen configuration : scr.dist(cm)        ex : scr.dist = 60
% ----------------------------------------------------------------------
% Output(s):
% cm    = size in cm                                ex : cm = 12
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

cm = (2 * scr.dist * tan(0.5 * pi / 180)) * vaDeg;
end