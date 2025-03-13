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

vid_num = 0;
for n_trial = 1:const.trialsNum
    
    % Compute and simplify var and rand
    % ---------------------------------

    % Var 1 : Spatial Frequency
    var1 = expDes.expMat(n_trial, 3);

    % Var 2 : Michelson contrast
    var2 = expDes.expMat(n_trial, 4);

    % Rand 1 : Stimulus orientation
    rand1 = expDes.expMat(n_trial, 5);
    
    if const.checkTrial && const.expStart == 0
        fprintf(1, '\n\n\t========================  Trial %3.0f ========================\n', n_trial);
        fprintf(1, '\n\tSpatial frequency            =\t');
        fprintf(1, '%s', expDes.txt_var1{var1(1)});
        fprintf(1, '\n\tMichelson contrast           =\t');
        fprintf(1, '%s', expDes.txt_var2{var2});
        fprintf(1, '\n\tStimulus orientation         =\t');
        fprintf(1, '%s', expDes.txt_rand1{rand1});
    end
    
    % wait for first TR trigger
    if n_trial == 1
        screen_filename = sprintf('%s/first_tr.mat', const.stim_folder);
        load(screen_filename, 'screen_stim');
        expDes.tex = Screen('MakeTexture', scr.main, screen_stim);
        Screen('DrawTexture', scr.main, expDes.tex, [], const.stim_rect)
        vbl = Screen('Flip', scr.main);
        
        first_trigger = 0;
        while ~first_trigger
            if const.scanner == 0 || const.scannerTest
                WaitSecs(const.TR_dur_sec - vbl);
                first_trigger = 1;
            else
                keyPressed = 0;
                keyCode = zeros(1, my_key.keyCodeNum);
                for keyb = 1:size(my_key.keyboard_idx, 2)
                    [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
                    keyPressed = keyPressed + keyP;
                    keyCode = keyCode + keyC;
                end
                if keyPressed
                    if keyCode(my_key.escape) && const.expStart == 0
                        overDone(const, my_key)
                    elseif keyCode(my_key.mri_tr)
                        first_trigger = 1;
                        fprintf(1, '\n\n\tFIRST TR RECORDED\n');
                    end
                end
            end
        end
    end
   
    
    drawf = 1;
    while drawf <= const.TR_dur_nnf

        % Define stimulus
        % ---------------
        % Define name of next frame
        if var1 == 7
            screen_filename = sprintf('%s/blank.mat', const.stim_folder);
        else
            
            if const.time2probe(drawf)
                screen_filename = sprintf('%s/sfStim%i_contStim%i_noiseRand%i_kappaNum%i_ori%i.mat', ...
                    const.stim_folder, var1, var2, const.rand_num_tex(drawf), ...
                    const.kappa_probe_num, rand1);
            else
                screen_filename = sprintf('%s/sfStim%i_contStim%i_noiseRand%i_kappaNum%i.mat', ...
                        const.stim_folder, var1, var2, const.rand_num_tex(drawf), ...
                        const.kappa_noise_num);
            end
        end
        
        % Load the tex matrix
        load(screen_filename, 'screen_stim');

        % Make texture
        tex = Screen('MakeTexture', scr.main, screen_stim, [], ...
            [], []);

        % Draw texture
        Screen('DrawTexture', scr.main, tex, [], const.stim_rect)
                
        % Flip screen
        if n_trial == 1 && drawf == 1; when2flip = 0;
        else
            when2flip = vbl + const.noise_dur_sec - scr.frame_duration / 2;
        end
        vbl = Screen('Flip', scr.main, when2flip);
        
        % Create movie
        if const.mkVideo
            vid_num = vid_num + 1;
            image_vid =   Screen('GetImage', scr.main);
            imwrite(image_vid,sprintf('%s_frame_%i.png', ...
                const.movie_image_file, vid_num))
            open(const.vid_obj);
            writeVideo(const.vid_obj, image_vid);
        end
        
        % Check response
        % --------------
        % Define when to reset resp
        if const.resp_reset(drawf); resp = 0; end
        
        % Key keyboard
        keyPressed = 0;
        keyCode = zeros(1, my_key.keyCodeNum);
        for keyb = 1:size(my_key.keyboard_idx, 2)
            [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
            keyPressed = keyPressed + keyP;
            keyCode = keyCode + keyC;
        end

        if keyPressed
            if keyCode(my_key.mri_tr)
                log_txt = sprintf('trial %i event_mri_trigger at %f\n', ...
                    n_trial, vbl);
                fprintf(const.log_file_fid, log_txt);
            end
            if keyCode(my_key.escape)
                if const.expStart == 0
                    overDone(const, my_key)
                end
            elseif keyCode(my_key.left1) % ccw button
                if var1 ~= 7 && const.time2resp(drawf) && resp == 0
                    log_txt = sprintf('trial %i event_%s at %f\n', ...
                        n_trial, my_key.left1Val, vbl);
                    fprintf(const.log_file_fid, log_txt);
                    switch rand1
                        case 1; correctness = 0;
                        case 2; correctness = 1;
                    end
                    expDes.expMat(n_trial, end-4) = correctness;
                    expDes.expMat(n_trial, end) = GetSecs;
                    resp = 1;
                end
            elseif keyCode(my_key.right1)  % cw button
                if var1 ~= 7 && const.time2resp(drawf) && resp == 0
                    log_txt = sprintf('trial %i event_%s at %f\n', ...
                        n_trial, my_key.right1Val, vbl);
                    fprintf(const.log_file_fid, log_txt);
                    switch rand1
                        case 1; correctness = 1;
                        case 2; correctness = 0;
                    end
                    expDes.expMat(n_trial, end-4) = correctness;
                    expDes.expMat(n_trial, end) = GetSecs;
                    resp = 1;
                end
            end
        end
        
        % Get time info
        % -------------
        % trial onset
        if drawf == 1
            log_txt = sprintf('trial %i trial_onset at %f\n', n_trial, vbl);
            fprintf(const.log_file_fid, log_txt);
            expDes.expMat(n_trial, end-3) = vbl;
        end
        
        % trial offset
        if drawf == const.TR_dur_nnf
            log_txt = sprintf('trial %i trial_offset at %f\n', n_trial, vbl);
            fprintf(const.log_file_fid, log_txt);
            expDes.expMat(n_trial, end-2) = vbl + const.noise_dur_sec;
        end
        
        % probe onset
        if const.probe_onset(drawf)
            log_txt = sprintf('trial %i probe_onset at %f\n', n_trial, vbl);
            fprintf(const.log_file_fid, log_txt);
            expDes.expMat(n_trial, end-1) = vbl;
        end

        % Frame number count
        drawf = drawf + 1;
    end
end
end