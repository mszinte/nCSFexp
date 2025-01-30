function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Project : nCSFexp
% Version : 1.0
% ----------------------------------------------------------------------
 
% Fix randomization
rng(100);

%% Colors
const.white             =   [255,255,255];                                                      % white color
const.black             =   [0,0,0];                                                            % black color
const.gray              =   [128,128,128];                                                      % gray color
const.yellow            =   [200,200,0];                                                        % yellow color
const.background_color  =   const.black;                                                        % background color
const.stim_color        =   const.white;                                                        % stimulus color
const.ann_color         =   const.white;                                                        % define anulus around fixation color
const.ann_probe_color   =   const.white;                                                        % define anulus around fixation color when probe
const.dot_color         =   const.white;                                                        % define fixation dot color
const.dot_probe_color   =   const.black;                                                        % define fixation dot color when probe

%% Stim parameters
const.noise_num         =   10;                                                                 % number of generated patches 
% Noise patches size 
const.noise_pixel       =   1;                                                                  % stimulus noise pixel size in pixels
const.stim_size         =   [scr.scr_sizeY,scr.scr_sizeY];                                      % full screen stimuli size in pixels
const.noise_size        =   const.stim_size(1);                                                 % size of the patch
const.native_noise_dim  =   round([const.noise_size/const.noise_pixel,...                       % starting size of the patch
                                   const.noise_size/const.noise_pixel]);                        

const.noise_dpp         =   scr.screen_dpp(1) * const.noise_pixel;                              % stimulus noise pixel size in degrees                                                                

% Noise patches position
const.stim_rect         =   [   scr.x_mid-const.stim_size(1);...                                % rect of the actual stimulus
                                scr.y_mid-const.stim_size(2);...
                                scr.x_mid+const.stim_size(1);...
                                scr.y_mid+const.stim_size(2)];

% Kappa and staircase 
const.num_steps_kappa   =   15;                                                                 % number of kappa steps
const.noise_kappa       =   [0,10.^(linspace(-1,1.5,const.num_steps_kappa-1))];                 % von misses filter kappa parameter (1st = noise, last = less noisy)

% Spatial Frequency filter 
const.sp_minFreq        =   0.5;                                                                % minimal spatial frequency cutoff in cycle/DVA
const.sp_maxFreq        =   20;                                                                 % maximal spatial frequency cutoff in cycle/DVA
const.sp_stepCut        =   6;                                                                  % number of spatial frequency cutoff 
const.sp_overlapCut     =   0.6;                                                                % proportion of overlaping for the gaussian spatial frequency cutoff

const.sp_cutCenters     = logspace(log10(const.sp_minFreq), ...                                 % centers (mu) of the gaussians spatial frequency cutoffs
    log10(const.sp_maxFreq), const.sp_stepCut); 


const.sp_logDiff        =   log10(centers(2)) - log10(centers(1));
const.sp_cutSigma       =   sqrt(-logDiff^2 / (4 * log(overlapValue)));                         % sigma (std) of the gaussians spatial frequency cutoffs



end