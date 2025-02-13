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
% Project :     nCSFexp
% Version :     1.0
% ----------------------------------------------------------------------

for n_trial = 1:expDes.nb_trials
    % Write in log
    log_txt     =   sprintf('Trial %i started\n',n_trial);
    fprintf(const.log_file_fid,log_txt); 

    % Compute and simplify var and rand
    % ---------------------------------

    % Var 1 : Spatial Frequency
    var1                    =   expDes.expMat(n_trial,4);

    % Var 2 : Michelson contrast
    var2                    =   expDes.expMat(n_trial,6);

    % Var 3 : ascending or descending contrast gradient
    var3                    =   expDes.expMat(n_trial,5);

    % Rand 1 : Stimulus orientation
    rand1                   =   expDes.expMat(n_trial,7);

    % Prepare stimuli
    % ---------------
    % Stimulus
    time2probe_cond         =   const.time2probe;
    time2resp_cond          =   const.time2resp;
    resp_reset_cond         =   const.resp_reset;
    trial_start_cond        =   const.trial_start;
    probe_onset_cond        =   const.probe_onset;

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
                keyPressed              =   0;
                keyCode                 =   zeros(1,my_key.keyCodeNum);
                for keyb = 1:size(my_key.keyboard_idx,2)
                    [keyP, keyC]            =   KbQueueCheck(my_key.keyboard_idx(keyb));
                    keyPressed              =   keyPressed+keyP;
                    keyCode                 =   keyCode+keyC;
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
        log_txt  =   sprintf('bar pass %i trial onset %i',bar_pass,bar_trials_num(bar_step));
        fprintf(const.log_file_fid,log_txt);
        expDes.expMat(n_trial,8) = vbl;
    end


    % loop over noise frame frequence
    drawf_max = const.nb_trials_noise_freq
    drawf = 1;
    while drawf <= drawf_max
        % define name of next frame
        if var1 == 7
            screen_filename         =   sprintf('%s/blank.mat',const.stim_folder);
        else
            if time2probe_cond(drawf)
                screen_filename         =   sprintf('%s/%sprobe_spStim%i_contStim%i_kappaStim%i_noiseRand%i.mat',...
                    const.stim_folder, var1, var2, ??, rand1);  % TAKE CARE OF STAICASE
            else
                screen_filename         =   sprintf('%s/%snoprobe_spStim%i_contStim%i_noiseRand%i.mat',...
                        const.stim_folder, var1, var2, rand1);
            end
        end








end
end