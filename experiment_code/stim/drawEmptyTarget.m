function drawEmptyTarget(scr,const,targetX,targetY)
% ----------------------------------------------------------------------
% drawEmptyTarget(scr,const,targetX,targetY)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw bull's eye target without the centrql dot
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% targetX: target coordinate X
% targetY: target coordinate Y
% typeTarget: (1) in dot (2) bull's eye
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

Screen('DrawDots', scr.main, [targetX, targetY], const.fix_out_rim_rad * 2, const.dot_color , [], 2);
Screen('DrawDots', scr.main, [targetX, targetY], const.fix_rim_rad * 2, const.background_color, [], 2);

end