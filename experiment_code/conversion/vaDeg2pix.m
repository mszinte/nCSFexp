function [pixX, pixY] = vaDeg2pix(vaDeg, scr)
% ----------------------------------------------------------------------
% [pixX, pixY] = vaDeg2pix(vaDeg, scr)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert visual angle (degree) in pixel ( x and y )
% ----------------------------------------------------------------------
% Input(s) :
% vaDeg = size in visual angle (deg)                   ex : = 1
% scr   = screen configurations : scr.scr_sizeX (pix)  ex : = 1024
%                                 scr.scr_sizeY (pix)  ex : = 768
%                                 scr.disp_sizeX (mm)  ex : = 400
%                                 scr.disp_sizeY (mm)  ex : = 300
%                                 scr.dist (cm)        ex : = 60
% ----------------------------------------------------------------------
% Output(s):
% pixX  = size in pixel(X)                             ex : = 35
% pixY  = size in pixel(Y)                             ex : = 25.35  
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

cm = vaDeg2cm(vaDeg, scr);
[pixX, pixY] = cm2pix(cm, scr);

end
