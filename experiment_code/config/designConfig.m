function [expDes] = designConfig(const)
% ----------------------------------------------------------------------
% [expDes] = designConfig(const)
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
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

%% Experimental random variables

% Var 1 : Spatial Frequency
% ======
expDes.oneV = linspace(1, const.sf_filtNum, const.sf_filtNum)';
expDes.txt_var1 = cellfun(@(x) sprintf('%.2f cycle/dva', x), ...
    num2cell(const.sf_filtCenters), 'UniformOutput', false);
expDes.txt_var1{end+1} = 'none';
% 1 - Lowest spatial frequency distribution
% ...
% max - Highest spatial frequency distribution
% 7 - No stim

% Var 2 : Contrast
% ======
expDes.twoV = linspace(1, const.contNum, const.contNum)';
expDes.txt_var2 = cellfun(@(x) sprintf('%.2f %%', x*100), ...
    num2cell(const.contValues), 'UniformOutput', false);
expDes.txt_var2{end+1} = 'none';
% 1 - Lowest contrast
% ...
% max - Highest constrast
% 7 - No stim

% Rand 1: stim orientation
% =======
expDes.oneR = [1;2];
expDes.txt_rand1 = {'cw', 'ccw', 'none'};
% 1 - Clockwise signal
% 2 - Counter-clockwise signal
% 3 - No stim
 
% Trial loop
% ----------
sf_seqs = [];
constrast_seqs = [];
ori_seqs = [];
num_seq_ascending = 0;
num_seq_descending = 0;
sf_ascending = randperm(const.sf_filtNum);
sf_descending = randperm(const.sf_filtNum);

if const.runNum == 1
    for seq = const.run_sequence
        if seq == 1 % ascending
            num_seq_ascending = num_seq_ascending + 1;
            sf_seq = repmat(sf_ascending(num_seq_ascending), const.contNum, 1);
            constrast_seq = linspace(1, const.contNum, const.contNum)';
            ori_seq = expDes.oneR(randi(length(expDes.oneR), const.contNum, 1));
        elseif seq == 2 % descending
            num_seq_descending = num_seq_descending + 1;
            sf_seq = repmat(sf_descending(num_seq_descending), const.contNum, 1);
            constrast_seq = linspace(const.contNum, 1, const.contNum)';
            ori_seq = expDes.oneR(randi(length(expDes.oneR), const.contNum, 1));
        elseif seq == 3 % break
            sf_seq = repmat(const.sf_filtNum + 1, const.break_trs, 1);
            constrast_seq = repmat(const.contNum + 1, const.break_trs, 1);
            ori_seq = repmat(length(expDes.oneR) + 1, const.break_trs, 1);
        end

        sf_seqs = [sf_seqs; sf_seq];
        constrast_seqs = [constrast_seqs; constrast_seq];
        ori_seqs = [ori_seqs; ori_seq];
    end

    runNum = const.runNum * ones(const.trialsNum, 1);
    trialNum = linspace(1, const.trialsNum, const.trialsNum)';
    nan_vector = nan(const.trialsNum, 1);
    
    expDes.expMat = [runNum, trialNum, sf_seqs, constrast_seqs, ...
        ori_seqs, nan_vector, nan_vector, nan_vector, nan_vector, ...
        nan_vector];

    % Export expMat for next run 
    expMat = expDes.expMat;
    save(const.expMat_file, 'expMat');
    
else
    % Load expMat sequence from first run
    fprintf(1, 'Load sequence from run-01');
    expDes.expMat = load(const.expMat_file).expMat;

    % change orientation sequence 
    for seq = const.run_sequence
        if seq == 3 % pause
            ori_seq = repmat(length(expDes.oneR) + 1, const.break_trs, 1);
        else % ascending and descending
            ori_seq = expDes.oneR(randi(length(expDes.oneR), const.contNum, 1)); 
        end
        ori_seqs = [ori_seqs; ori_seq];
    end
    expDes.expMat(:, 5) = ori_seqs;
end
% col 01: Run
% col 02: Trial
% col 03: Spatial frequency
% col 04: Michelson contrast
% col 05: Probe orientation
% col 06: Response (correct/incorrect)
% col 07: Trial onset time
% col 08: Trial offset time
% col 09: Probe onset
% col 10: Response onset
end