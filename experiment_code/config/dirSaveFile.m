function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files name and fid.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

% Create data directory 
if ~isfolder(sprintf('data/%s/%s/%s/', const.sjct, const.session, ...
        const.modality))
    mkdir(sprintf('data/%s/%s/%s/', const.sjct, const.session, ...
        const.modality))
end

% Define directory
const.dat_output_file = sprintf('data/%s/%s/%s/%s_%s_task-%s_%s',...
    const.sjct, const.session, const.modality, const.sjct, ...
    const.session, const.task, const.run);

% Define behavioral data filename
const.behav_file = sprintf('%s_events.tsv', const.dat_output_file);
if const.expStart
    if exist(const.behav_file,'file')
        aswErase = upper(strtrim(input(sprintf(...
            '\n\tSame data file exists, erase it ? (Y or N): '), 's')));
        if upper(aswErase) == 'N'
            error('Relaunch with correct input.')
        elseif upper(aswErase) == 'Y'
        else
            error('Incorrect input, relaunch with correct input.')
        end
    end
end
const.behav_file_fid = fopen(const.behav_file, 'w');

% Define .mat saving file
const.mat_file = sprintf('%s_matlab.mat', const.dat_output_file);



% Spatial frequency sequence file
const.expMat_file = sprintf('%s_expMat.mat', const.dat_output_file);

% Staircase file
const.staircase_file = sprintf('%s_staircases.mat', const.dat_output_file);

% Define .mat stimuli file and saving file
const.stim_folder = sprintf('stim/screenshots');
const.stim_mat_file = 'stim/screenshots/stim_matlab.mat';

% Log file
const.log_file = sprintf('%s_logData.txt', const.dat_output_file);
const.log_file_fid = fopen(const.log_file, 'w');

end