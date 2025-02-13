function [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% [const]=sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define subject configurations (initials, gender...)
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------


if const.expStart
    % Define participant
    const.sjctNum           =  input(sprintf('\n\tParticipant number: '));
    if isempty(const.sjctNum)
        error('Incorrect participant number');
    end
    if const.sjctNum > 9
        const.sjct              =  sprintf('sub-%i',const.sjctNum);
    else
        const.sjct              =  sprintf('sub-0%i',const.sjctNum);
    end

    % Define session
    const.sesNum = input(sprintf('\n\tSession number: '));
    if const.sesNum > 9
        const.session           =  sprintf('ses-%i',const.sesNum);
    else
        const.session           =  sprintf('ses-0%i',const.sesNum);
    end

    % Define run
    const.runNum            =   input(sprintf('\n\tRun number (1 to 2): '));
    if isempty(const.runNum)
        error('Incorrect run number');
    end
    if const.runNum > 2
        error('Only 2 runs');
    end

    if const.cond_run_num(const.runNum) > 9
        const.run_txt   =  sprintf('run-%i',const.cond_run_num(const.runNum));
    else
        const.run_txt   =  sprintf('run-0%i',const.cond_run_num(const.runNum));
    end

    % Experimental condition
    const.cond1 = const.cond_run_order(const.runNum,1);
    const.cond1_txt = 'nCSF';
    const.recEye = 1;

else
    const.sjct = 'sub-0X';
    const.session = 'ses-0X';
    const.runNum = 1;
    const.run_txt = 'run-0X';
    const.cond1 = 1;
    const.cond1_txt = 'nCSF';
    const.recEye =   1;
end

% Training
if const.training
    const.cond1_txt = sprintf('%sTraining',const.cond1_txt);
end
fprintf(1,'\n\tTask: %s\n',const.cond1_txt);

end