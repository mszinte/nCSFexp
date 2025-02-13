function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------

% Fix randomization
rng(const.seed);

%% Experimental random variables

% Var 1 : Spatial Frequency (7 modalities)
% ======
expDes.oneV             =   [1;2;3;4;5;6];
expDes.txt_var1         =   {'0.5 cyle/dva','1.05 cyle/dva','2.19 cyle/dva','4.57 cyle/dva','9.56 cyle/dva','20.00 cyle/dva', 'none'};
% value defined as const.sp_cutCenters in constConfig.m
% 01 = 0.5 cyle/dva
% 02 = 1.05 cyle/dva
% 03 = 2.19 cyle/dva
% 04 = 4.57 cyle/dva
% 05 = 9.56 cyle/dva
% 06 = 20.00 cyle/dva
% 07 = none

% Var 2 : Michelson contrast (7 modalities)
% ======
expDes.twoV             =   [1;2;3;4;5;6];
expDes.txt_var2         =   {'0.25 %','0.79 %','2.51 %','7.96 %','25.24 %','80.00 %', 'none'};
% value defined as const.mc_values * 100 in constConfig.m
% 01 = 0.25 %
% 02 = 0.79 %
% 03 = 2.51 %
% 04 = 7.96 %
% 05 = 25.24 %
% 06 = 80.00 %
% 07 = none

% Var 3 : ascending or descending contrast gradient (3 modalities)
% ======
expDes.threeV           =   [1;2];
expDes.txt_var3         =   {'ascending','descending', 'none'};
% 01 = ascending
% 02 = descending
% 03 = none

% Rand 1: stim orientation (2 modalities)
% =======
expDes.oneR             =   [1;2];
expDes.txt_rand1        =   {'cw','ccw','none'};
% 01 = tilt cw
% 02 = tilt ccw
% 03 = none

% Staircase
% ---------
% To be done 

% seq order
% ---------
if const.runNum == 1
    % create spatial frequency sequence order
    expDes.sp_sequence_order = randDraw(expDes.oneV, const.repetition_sp_sequence);

    % ascending or descending first contrast gradient
    expDes.gradient_sequence_order = expDes.threeV(randperm(length(expDes.threeV)));
 
    % Export sequence_order_file
    sp_sequence_order       =   expDes.sp_sequence_order;
    gradient_sequence_order =   expDes.gradient_sequence_order;

    save(const.sequence_order_file, 'sp_sequence_order', 'gradient_sequence_order');
else
    load(const.sequence_order_file);
    expDes.sp_sequence_order       =   sp_sequence_order;
    expDes.gradient_sequence_order =   gradient_sequence_order;
end

%% Experimental configuration :
expDes.nb_cond          =   0;
expDes.nb_var           =   3;
expDes.nb_rand          =   1;
expDes.nb_list          =   0;

%% Experimental loop
runT                    =   const.runNum;

% introduce brakes between spatial frequency
expDes.sp_brake_val = max(expDes.oneV) + 1; 
expDes.sp_sequence_order_with_brakes = [expDes.sp_brake_val;...
    reshape([expDes.sp_sequence_order, expDes.sp_brake_val * ones(length(expDes.sp_sequence_order)...
    , 1)]', [], 1)];

% Define the first contrast gradient
if expDes.gradient_sequence_order(1) == 1
    gradient             = expDes.twoV;
else
    gradient             = flipud(expDes.twoV);
end

t_trial = 0;
loop_gradient_sequence_order = expDes.gradient_sequence_order;
% Loop through the spatial sequence 
for ii = 1:length(expDes.sp_sequence_order_with_brakes)
    t_sp = expDes.sp_sequence_order_with_brakes(ii);
    % If spatial frequency is 7, apply a break 
    if t_sp == 7
        for j = 1:const.length_break
            t_cont          = 7;
            t_ori           = 3;
            t_cont_gradien  = 3;
            t_trial        = t_trial + 1;
    
            % Update expMat
            expDes.expMat(t_trial, :) = [runT, t_trial, ...
                t_sp, t_cont_gradien, t_cont, t_ori, ...
                NaN, NaN, NaN, NaN, NaN, NaN];
        end

    % Otherwise, generate contrast gradient
    else
        % loop over the contrast
        for iii = 1:length(expDes.twoV)
            t_cont_gradien  = loop_gradient_sequence_order(1);
            t_cont        = gradient(iii);
            t_ori     = expDes.oneR(randperm(length(expDes.oneR), 1));
            t_trial = t_trial + 1;

            % Update expMat
            expDes.expMat(t_trial, :) = [runT, t_trial, ...
                t_sp, t_cont_gradien, t_cont, t_ori, ...
                NaN, NaN, NaN, NaN, NaN, NaN];

            % col 01:   Run number
            % col 02:   Trial number
            % col 04:   Spatial frequency
            % col 05:   Ascending or descending contrast
            % col 06:   contrast
            % col 07:   Stimulus noise orientation
            % col 08:   Trial onset time
            % col 09:   Trial offset time
            % col 10:   Stimulus noise staircase value
            % col 11:   Stimulus noise staircase value
            % col 12:   Probe time
            % col 13:   Response time

        end
        % Flip the gradient after each spatial frequency iteration
        gradient = flipud(gradient);
        loop_gradient_sequence_order = flipud(loop_gradient_sequence_order);
    end
end
expDes.nb_trials = size(expDes.expMat,1);
end 

