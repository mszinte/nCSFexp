function [expDes] = runTrials(scr,const,expDes,my_key)
% ----------------------------------------------------------------------
% [expDes]=runTrials(scr,const,expDes,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% resMat : experimental results (see below)
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project: nCSFexp
% ----------------------------------------------------------------------

for n_trial = 1:const.trialsNum
    % Write in log
    log_txt = sprintf('Trial %i started\n',n_trial);
    fprintf(const.log_file_fid,log_txt); 

    % Compute and simplify var and rand
    % ---------------------------------

    % Var 1 : Spatial Frequency
    var1 = expDes.expMat(n_trial, 3);

    % Var 2 : Michelson contrast
    var2 = expDes.expMat(n_trial, 4);

    % Rand 1 : Stimulus orientation
    rand1 = expDes.expMat(n_trial, 5);
    
    if const.checkTrial && const.expStart == 0
        fprintf(1,'\n\n\t========================  Trial %3.0f ========================\n', n_trial);
        fprintf(1,'\n\tSpatial frequency            =\t');
        fprintf(1,'%s', expDes.txt_var1{var1(1)});
        fprintf(1,'\n\tMichelson contrast           =\t');
        fprintf(1,'%s',expDes.txt_var2{var2});
        fprintf(1,'\n\tStimulus orientation         =\t');
        fprintf(1,'%s',expDes.txt_rand1{rand1});
    end
    
    % Prepare stimuli
    % ---------------
    % Stimulus
    time2probe_cond = const.time2prob;
    time2resp_cond = const.time2resp;
    resp_reset_cond = const.resp_reset;
    trial_start_cond = const.trial_start;
    probe_onset_cond = const.probe_onset;

    % wait for bar_pass press in trial beginning
    if n_trial == 1
        Screen('FillRect',scr.main, const.background_color);
        drawEmptyTarget(scr, const, const.rect_center(1), const.rect_center(2));
        Screen('DrawLines',scr.main, const.line_fix_up_left, const.line_width, const.line_color, [], 1);
        Screen('DrawLines',scr.main, const.line_fix_up_right, const.line_width, const.line_color, [], 1);
        Screen('DrawLines',scr.main, const.line_fix_down_left, const.line_width, const.line_color, [], 1);
        Screen('DrawLines',scr.main, const.line_fix_down_right, const.line_width, const.line_color, [], 1);
        Screen('Flip',scr.main);
        first_trigger           =   0;

        while ~first_trigger
            if const.scanner == 0 || const.scannerTest
                first_trigger           =   1;
                
            else
                keyPressed = 0;
                keyCode = zeros(1,my_key.keyCodeNum);
                for keyb = 1:size(my_key.keyboard_idx,2)
                    [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
                    keyPressed = keyPressed+keyP;
                    keyCode = keyCode+keyC;
                end

                if keyPressed
                    if keyCode(my_key.escape) && const.expStart == 0
                        overDone(const,my_key)
                    elseif keyCode(my_key.mri_tr)
                        first_trigger = 1;
                        fprintf(1,'\n\n\tFIRST TR RECORDED\n');
                    end
                end
            end
        end
            
        t_start = GetSecs;
        vbl = GetSecs;
        % log_txt = sprintf('bar pass  trial onset %i', bar_pass, bar_trials_num(bar_step));
        fprintf(const.log_file_fid,log_txt);
        expDes.expMat(n_trial,8) = vbl;
    end


    % loop over noise frame frequence
    % define name of next frame
    if var1 == 7
        screen_filename = sprintf('%s/blank.mat',const.stim_folder);
    else
        if time2probe_cond(n_trial)
            screen_filename = sprintf('%s/%sprobe_spStim%i_contStim%i_kappaStim%i_noiseRand%i.mat',...
                const.stim_folder, var1, var2, expDes.stim_stair_val, rand1);
        else
            screen_filename = sprintf('%s/%snoprobe_spStim%i_contStim%i_noiseRand%i.mat',...
                    const.stim_folder, var1, var2, rand1);
        end
    end

    % load the matrix
    load(screen_filename,'screen_stim');
    
    % make texture
    expDes.tex = Screen('MakeTexture',scr.main,screen_stim,[],[],[],0);
    
    % draw texture
    Screen('DrawTexture',scr.main,expDes.tex,[],const.stim_rect)        

    % flip screen
    when2flip = vbl + const.patch_dur - scr.frame_duration/2;
    vbl = Screen('Flip',scr.main, when2flip);




end
end