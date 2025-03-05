function [const] = runExp(scr, const, expDes, my_key)
% ----------------------------------------------------------------------
% [const] = runExp(scr, const, expDes, my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch experiement instructions and run trials
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project: nCSFexp
% ----------------------------------------------------------------------

% Configuration of videos
% -----------------------
if const.mkVideo
    expDes.vid_num = 0;
    const.vid_obj = VideoWriter(const.movie_file, 'MPEG-4');
    const.vid_obj.FrameRate = const.noise_freq;
    const.vid_obj.Quality = 100;
    open(const.vid_obj);
end

% Special instruction for scanner
% -------------------------------
if const.scanner && ~const.scannerTest
    scanTxt = '_Scanner';
else
    scanTxt = '';
end

% Save all config at start of the block
% -------------------------------------
config.scr = scr;
config.const = const;
config.expDes = expDes;
config.my_key = my_key;
save(const.mat_file, 'config');
if const.genStimuli
    save(const.stim_mat_file, 'config');
end

% First mouse config
% ------------------
if const.expStart
    HideCursor;
    for keyb = 1:size(my_key.keyboard_idx, 2)
        KbQueueFlush(my_key.keyboard_idx(keyb));
    end
end

% Initial calibrations
% --------------------
% Task instructions
fprintf(1, '\n\tTask instructions -press space or right button-');
instructionsIm(scr, const, my_key, sprintf('%s', const.task, scanTxt), 0);
for keyb = 1:size(my_key.keyboard_idx, 2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end
fprintf(1, '\n\n\tBUTTON PRESSED BY SUBJECT\n');

% Main trial loop
% ---------------
[expDes] = runTrials(scr, const, expDes, my_key);

% Compute/Write mean/std behavioral data
% --------------------------------------
behav_txt_head{1} = 'onset';
behav_txt_head{2} = 'duration';
behav_txt_head{3} = 'run_number';
behav_txt_head{4} = 'trial_number';
behav_txt_head{5} = 'spatial_frequency';
behav_txt_head{6} = 'michelson_contrast';
behav_txt_head{7} = 'probe_orientation';
behav_txt_head{8} = 'response_correctness';
behav_txt_head{9} = 'probe_time';
behav_txt_head{10} = 'reaction_time';

behav_mat_res{1} = expDes.expMat(:, 7);
behav_mat_res{2} = expDes.expMat(:, 8) - expDes.expMat(:, 7);
behav_mat_res{3} = expDes.expMat(:, 1);
behav_mat_res{4} = expDes.expMat(:, 2);
behav_mat_res{5} = expDes.expMat(:, 3);
behav_mat_res{6} = expDes.expMat(:, 4);
behav_mat_res{7} = expDes.expMat(:, 5);
behav_mat_res{8} = expDes.expMat(:, 6);
behav_mat_res{9} = expDes.expMat(:, 9);
behav_mat_res{10} = expDes.expMat(:, 10) - expDes.expMat(:, 9);

head_line = [];
for trial = 1:const.trialsNum
    % header line
    if trial == 1
        for tab = 1:size(behav_txt_head, 2)
            if tab == size(behav_txt_head, 2)
                head_line = [head_line, sprintf('%s', behav_txt_head{tab})];
            else
                head_line = [head_line, sprintf('%s\t', behav_txt_head{tab})];
            end
        end
        fprintf(const.behav_file_fid, '%s\n', head_line);
    end
    
    % trials line
    trial_line = [];
    for tab = 1:size(behav_mat_res, 2)
        if tab == size(behav_mat_res, 2)
            if isnan(behav_mat_res{tab}(trial))
                trial_line = [trial_line, sprintf('n/a')];
            else
                trial_line = [trial_line, sprintf('%1.10g', behav_mat_res{tab}(trial))];
            end
        else
            if isnan(behav_mat_res{tab}(trial))
                trial_line = [trial_line, sprintf('n/a\t')];
            else
                trial_line = [trial_line, sprintf('%1.10g\t', behav_mat_res{tab}(trial))];
            end
        end
    end
    fprintf(const.behav_file_fid, '%s\n', trial_line);
end

% End messages
% ------------
if const.runNum == const.runTotal
    instructionsIm(scr, const, my_key, 'End', 1);
else
    instructionsIm(scr, const, my_key, 'End_block', 1);
end

% Save all config at the end of the block
% ---------------------------------------
config.scr = scr; config.const = const; config.expDes = expDes; config.my_key = my_key;
save(const.mat_file, 'config');

end