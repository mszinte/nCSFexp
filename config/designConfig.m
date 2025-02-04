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

rng('default');rng('shuffle');

%% Experimental random variables
% Cond 1 : task (1 modality)
% =======
expDes.oneC             =   [1];
expDes.txt_cond1        =   {'noise_patch'};

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

% Var 3 : ascending or descending contrast (3 modalities)
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

% seq order
% ---------
if const.runNum == 1
    % create spatial frequency sequence order
    while true
        expDes.sp_sequence_order = expDes.oneV(randperm(const.sp_stepCut));
        if all(abs(diff(expDes.sp_sequence_order)) > 1), break; end
    end

    % create ascending or descending starting
    expDes.first_contrast_gradient = expDes.threeV(randperm(length(expDes.threeV), 1));
 
    % Export sequence_order_file
    sp_sequence_order       =   expDes.sp_sequence_order;
    first_contrast_gradient =   expDes.first_contrast_gradient
    save(const.sequence_order_file, 'sp_sequence_order', 'first_contrast_gradient');
else
    load(const.sequence_order_file);
    expDes.sp_sequence_order       =   sp_sequence_order;
    expDes.first_contrast_gradient =   first_contrast_gradient;
end


%% Experimental configuration :
expDes.nb_cond          =   1;
expDes.nb_var           =   3;
expDes.nb_rand          =   1;
expDes.nb_list          =   0;

%% Experimental loop
runT                    =   const.runNum;

% Make sequence with brakes
expDes.sp_brake_val = max(expDes.sp_sequence_order) + 1; 
expDes.sp_sequence_order = [expDes.sp_brake_val; reshape([expDes.sp_sequence_order, expDes.sp_brake_val * ones(length(expDes.sp_sequence_order), 1)]', [], 1)];




% defind first contrast gradient
if expDes.first_contrast_gradient == 1
    gradient             =   expDes.twoV;
    gradient_order_list  =   expDes.threeV;
else
    gradient             =   flipud(expDes.twoV);
    gradient_order_list  =   flipud(expDes.threeV);
end

t_trial = 0;
for i = length(expDes.sp_sequence_order)
    t_sp = expDes.sp_sequence_order(i);
    spatial_frequency = expDes.sp_sequence_order(t_sp);

    % brakes 
    if spatial_frequency == 7;
        contrast            =   7;
        orientation         =   3;
        sp_gradient         =   3;
        gradient_order      =   3;
        t_trial           =    t_trial + 1;

    % stim
    else
        for ii = 1:length(expDes.twoV)
            t_cont = expDes.twoV(ii);
            gradient_order    =    gradient_order_list(1);
            contrast          =    gradient(t_cont);
            orientation       =    expDes.oneR(randperm(length(expDes.oneR), 1));

            t_trial           =    t_trial + 1;

        end

    end
    expDes.expMat(t_trial,:) =   [runT, t_trial, expDes.oneC(1), ...
    spatial_frequency, gradient_order, contrast, orientation, ...
    NaN, NaN, NaN, NaN, NaN, NaN];
    gradient = flipud(gradient);
end




% col 01:   Run number
% col 02:   Trial number
% col 03:   Task
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