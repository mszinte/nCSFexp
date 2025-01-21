function expDes = designConfig(const)
% ----------------------------------------------------------------------
% expDes = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function:
% Define experimental design
% ----------------------------------------------------------------------
% Input(s):
% const: struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes: struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Experimental random variables
% Var 1 : bar direction (9 modalities)
expDes.oneV = [1;3;5;7];
expDes.txt_var1 = {'180 deg', '225 deg', '270 deg', '315 deg', '0 deg',...
                    '45 deg','90 deg','135 deg','none'};
% 01 = 180 deg
% 02 = 225 deg
% 03 = 270 deg
% 04 = 315 deg
% 05 = 0 deg
% 06 = 45 deg
% 07 = 90 deg
% 08 = 135 deg
% 09 = none

% Rand 1: stim orientation (2 modalities)
expDes.oneR = [1;2];
expDes.txt_rand1 = {'cw', 'ccw', 'none'};
% 01 = tilt cw
% 02 = tilt ccw
% 03 = none

% Staircase
if const.runNum == 1
    % create staircase starting value
    expDes.stim_stair_val = const.stim_stair_val;
    expDes.cor_count_stim = 0;
    expDes.incor_count_stim = 0;
else
    % load staircase of previous blocks
    load(const.staircase_file);
    expDes.stim_stair_val = staircase.stim_stair_val;
    expDes.cor_count_stim = staircase.cor_count_stim;
    expDes.incor_count_stim = staircase.incor_count_stim;
end

%% Experimental configuration :
expDes.nb_var = 1;
expDes.nb_rand = 1;

t_trial = 0;
for t_bar_pass = 1:size(const.bar_dir_run, 2)
    rand_var1 = const.bar_dir_run(t_bar_pass);
    
    if rand_var1 == 9
        bar_pos_per_pass  = const.blk_step;
    else
        if rand_var1 == 1 || rand_var1 == 5
            bar_pos_per_pass = const.bar_step_hor;
        elseif rand_var1 == 3 || rand_var1 == 7
            bar_pos_per_pass = const.bar_step_ver;
        end
    end
    
    for bar_step = 1:bar_pos_per_pass
        rand_rand1 = expDes.oneR(randperm(numel(expDes.oneR), 1));

        % no bar
        if rand_var1 == 9
            rand_rand1 = 3;
        end
    
        t_trial = t_trial + 1;
        expDes.expMat(t_trial, :) = [NaN, NaN, const.runNum, t_trial, ...
            rand_var1, t_bar_pass, bar_step, rand_rand1, NaN, NaN, NaN, ...
            NaN, NaN];
        
        % 01: trial onset
        % 02: trial duration
        % 03: run number
        % 04: trial number
        % 05: bar direction
        % 06: bar pass period
        % 07: bar step
        % 08: stimulus orientation
        % 09: trial offset time
        % 10: stimulus noise staircase value
        % 11: reponse value (correct/incorrect)
        % 12: Probe time
        % 13: Reaction time
    end
end

expDes.nb_trials = size(expDes.expMat,1);
end