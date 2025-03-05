function [my_key]=keyConfig(const)
% ----------------------------------------------------------------------
% [my_key]=keyConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and define structure containing each key names
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');

if const.training
    my_key.mri_trVal = 's';                                                 % mri trigger letter
    my_key.left1Val = 'r';                                                  % left button 1
    my_key.left2Val = 'q';                                                  % left button 2
    my_key.right1Val = 'u';                                                 % right button 1
    my_key.right2Val = 'm';                                                 % right button 2
else
    my_key.mri_trVal = 't';                                                 % mri trigger letter
    my_key.left1Val = 'r';                                                  % left button index (inside)
    my_key.left2Val = 'g';                                                  % left button thumb (outside)
    my_key.right1Val = 'b';                                                 % right button index (inside)
    my_key.right2Val = 'y';                                                 % right button thumb (outsid
end

my_key.escapeVal = 'escape';                                                % escape button
my_key.spaceVal = 'space';                                                  % space button

my_key.mri_tr = KbName(my_key.mri_trVal);
my_key.left1 = KbName(my_key.left1Val);
my_key.right1 = KbName(my_key.right1Val);
my_key.escape = KbName(my_key.escapeVal);
my_key.space = KbName(my_key.spaceVal);

my_key.keyboard_idx = GetKeyboardIndices;
for keyb = 1:size(my_key.keyboard_idx, 2)
    KbQueueCreate(my_key.keyboard_idx(keyb));
    KbQueueFlush(my_key.keyboard_idx(keyb));
    KbQueueStart(my_key.keyboard_idx(keyb));
end

[~, keyCodeMat] = KbQueueCheck(my_key.keyboard_idx(1));
my_key.keyCodeNum = numel(keyCodeMat);

end