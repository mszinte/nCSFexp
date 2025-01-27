 %% General experimenter launcher
%  =============================
% By: Martin SZINTE
% Projet: pRFexp for altered vision (pilot project in Amsterdam)
% With: Sina KLING, Tomas KNAPEN & Uriel LASCOMBES

% Version description
% ===================
% Experiment in which we use a circular full screen 4 directions 
% (left/right/up/down) bar pass stimuli with an attention task to the bar 
% in order to obtain pRF retinotopy of the occipital, parietal, frontal 
% and subcortical structures.

% This task is adapted to test condition suppose to mimic symptoms ofwy
% amblyopic patients, pRF task is then ran with prisms on the non-dominant
% eye (pRFStrab), with an incorrect eye correction on the non-dominant eye
% (pRFAniso), and short exposure to a occlusion path on the non-dominant
% eye (pRFOccl)or without (pRFCtrl). 

% First settings
Screen('CloseAll'); clear all; clear mex; clear functions; close all; ...
    home; AssertOpenGL;

% General settings 
const.expName = 'nCSFexp';       % experiment name
const.expStart = 0;             % Start of a recording exp (0 = NO, 1 = YES)
const.checkTrial = 0;           % Print trial conditions (0 = NO, 1 = YES)
const.genStimuli = 1 ;           % Generate the stimuli (0 = NO, 1 = YES)
const.drawStimuli = 1;          % Draw stimuli generated (0 = NO, 1 = YES)
const.mkVideo = 0 ;              % Make a video of a run

% External controls
const.tracker = 0;                % run with eye tracker (0 = NO, 1 = YES)
const.comp = 4;                 % run in which computer (1 = INT Diplay++; 2 = BOLDSCREEN; 3 = PROPIXX; 4 = Samsung U/S)
const.scanner = 0;              % run in MRI scanner (0 = NO, 1 = YES)
const.scannerTest = 0;          % fake scann    er trigger (0 = NO, 1 = YES)
const.training = 0;             % training session (0 = NO, 1 = YES)
const.run_total = 1;            % number of run in total

% Desired screen setting
const.desiredFD = 60;          % Desired refresh rate
const.desiredRes = [1920, 1080];% Desired resolution

% Path
dir = which('expLauncher');
cd(dir(1:end-18));

% Add Matlab path
addpath('config', 'main', 'conversion', 'eyeTracking', 'instructions',...
    'trials', 'stim');

% Subject configuration
const = sbjConfig(const);

% Main run
main(const);