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
const.dat_output_dir = sprintf('data/%s/%s/%s',...
                               const.sjct, const.session, const.modality);
const.dat_output_dir_sess1 = sprintf('data/%s/ses-01/%s',...
                                     const.sjct, const.modality);
const.dat_output_file = sprintf('%s/%s_%s_task-%s_%s',...
                                const.dat_output_dir, const.sjct, ...
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
const.expMat_file_sess1 = sprintf('%s/%s_expMat.mat', const.dat_output_dir_sess1, const.sjct);
const.expMat_file = sprintf('%s/%s_expMat.mat', const.dat_output_dir, const.sjct);

% Define .mat stimuli file and saving file
const.stim_folder = sprintf('stim/screenshots/%s', strrep(const.task, 'Training', ''));
const.stim_mat_file = sprintf('%s/stim_matlab.mat', const.stim_folder);
const.stim_tsv_fil = sprintf('%s/stim_params.tsv', const.stim_folder);

% Log file
const.log_file = sprintf('%s_logData.txt', const.dat_output_file);
const.log_file_fid = fopen(const.log_file, 'w');

% Movie file
if const.mkVideo
    if ~isfolder(sprintf('others/%s_vid/', const.task))
        mkdir(sprintf('others/%s_vid/', const.task))
    end
    const.movie_image_file = sprintf('others/%s_vid/%s_vid',const.task, const.task);
    const.movie_file = sprintf('others/%s_vid.mp4', const.task);
end
end