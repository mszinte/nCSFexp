function [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define subject configurations (initials, gender, etc.)
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

if const.expStart
    
    % Define participant
    const.sjctNum = input(sprintf('\n\tParticipant number: '));
    if isempty(const.sjctNum)
        error('Incorrect participant number');
    end
    if const.sjctNum > 9
        const.sjct = sprintf('sub-%i', const.sjctNum);
    else
        const.sjct = sprintf('sub-0%i', const.sjctNum);
    end

    % Define session
    const.sesNum = input(sprintf('\n\tSession number: '));
    if const.sesNum > 9
        const.session = sprintf('ses-%i', const.sesNum);
    else
        const.session = sprintf('ses-0%i', const.sesNum);
    end

    % Define run
    const.runNum = input(sprintf('\n\tRun number: '));
    if isempty(const.runNum)
        error('Incorrect run number');
    end

    if const.runNum > 9
        const.run = sprintf('run-%i',const.runNum);
    else
        const.run = sprintf('run-0%i',const.runNum);
    end
    
    % Define main modality
    if const.scanner == 1
        const.modality = 'func';
    else
        const.modality = 'beh';
    end
else
    const.sjct = 'sub-0X';
    const.session = 'ses-0X';
    const.runNum = 1;
    const.run = 'run-0X';
    const.modality = 'beh';
end

% Psychophysics task
if const.psy
    const.task = sprintf('%spsy', const.task);
end

% Training
if const.training
    const.task = sprintf('%sTraining', const.task);
end
fprintf(1, '\n\tTask: %s\n', const.task);

end