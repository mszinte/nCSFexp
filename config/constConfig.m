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
[const.seed, const.whichGen] = ClockRandSeed;
rng(const.seed);

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

%% Time parameters
const.TR_dur            =   1.6;                                                                % repetition time
const.TR_num            =   (floor(const.TR_dur/scr.frame_duration));                           % repetition time in screen frames

const.noise_freq        =   10;                                                                 % compute noise frequency in hertz
const.patch_dur         =   1/const.noise_freq;                                                 % compute single patch duration in seconds
const.TR_num_noise      =   (floor(const.TR_dur/const.patch_dur));                              % repetition time in noise frames

%% Stim parameters
% const.noise_num         =   10;                                                                 % number of generated patches 
% Noise patches size 
const.noise_pixel       =   1;                                                                  % stimulus noise pixel size in pixels
const.stim_size         =   [scr.scr_sizeY,scr.scr_sizeY];                                      % full screen stimuli size in pixels
const.noise_size        =   const.stim_size(1);                                                 % size of the patch
const.native_noise_dim  =   round([const.noise_size/const.noise_pixel,...                       % starting size of the patch
                                   const.noise_size/const.noise_pixel]);                        

const.noise_dpp         =   scr.screen_dpp(1) * const.noise_pixel;                              % stimulus noise pixel size in degrees                                                                

% Noise patches position
const.stim_rect = [scr.x_mid - const.noise_size/2;...                                           % rect of the actual stimulus
    scr.y_mid - const.noise_size/2;...
    scr.x_mid + const.noise_size/2;...
    scr.y_mid + const.noise_size/2];

const.disp_margin_top = cm2pix(scr.disp_margin_top, scr);                                       % Display top margin not seen in scanner in pix
const.disp_margin_bottom = cm2pix(scr.disp_margin_bottom, scr);                                 % Display bottom margin not seen in scanner in pix
const.disp_max = (scr.scr_sizeY - const.disp_margin_top - const.disp_margin_bottom);            % Display size seen in scanner in pix 

const.rect_center =  [scr.x_mid, ... 
                      const.disp_margin_top + const.disp_max/2];                                % center of the rect in projector screen
                            
const.rect_noise        =  [const.rect_center(1) - const.noise_size/2;...                       % noise native rect
                            const.rect_center(2) - const.noise_size/2;...
                            const.rect_center(1) + const.noise_size/2;...
                            const.rect_center(2) + const.noise_size/2];

% Kappa and staircase
const.native_noise_orientation = 90;                                                            % von misses original orientation
const.num_steps_kappa   =   15;                                                                 % number of kappa steps
const.noise_kappa       =   [0,10.^(linspace(-1,1.5,const.num_steps_kappa-1))];                 % von misses filter kappa parameter (1st = noise, last = less noisy)

% Spatial Frequency filter 
const.sp_minFreq        =   0.5;                                                                % minimal spatial frequency cutoff in cycle/DVA
const.sp_maxFreq        =   20;                                                                 % maximal spatial frequency cutoff in cycle/DVA
const.sp_stepCut        =   6;                                                                  % number of spatial frequency cutoff 
const.sp_overlapCut     =   0.6;                                                                % proportion of overlaping for the gaussian spatial frequency cutoff
const.repetition_sp_sequence = 2;                                                               % number of repetition of de spatial frequency sequence (for ascending and descending contrast gradient)

const.sp_cutCenters     = round(logspace(log10(const.sp_minFreq), ...                           % centers (mu) of the gaussians spatial frequency cutoffs
    log10(const.sp_maxFreq), const.sp_stepCut),2); 


const.sp_logDiff        =   log10(const.sp_cutCenters(2)) - log10(const.sp_cutCenters(1));
const.sp_cutSigma       =   sqrt(-const.sp_logDiff^2 / (4 * log(const.sp_overlapCut)));         % sigma (std) of the gaussians spatial frequency cutoffs

% Michelson contrast
const.mc_minCont = 0.0025;                                                                      % minimal michelson contrast value     
    const.mc_maxCont = 0.8;                                                                         % maximal michelson contrast value
    const.mc_stepCont = 6;                                                                          % number of michelson contrast value
const.mc_values = logspace(log10(const.mc_minCont), ...                                         % michelson contrast values
    log10(const.mc_maxCont), const.mc_stepCont);

% Brakes 
const.num_break         =   const.sp_stepCut + 1;                                               % number of brakes 
const.length_break      =   2;                                                                  % duration of breaks (in TR)

% Apertures
const.apt_rad_val       =   6.5;                                                                % aperture stimuli radius in dva
const.apt_rad           =   vaDeg2pix(const.apt_rad_val,scr);                                   % aperture stimuli radius in pixels
const.rCosine_grain     =   80;                                                                 % grain of the radius cosine steps
const.aperture_blur     =   0.01;                                                               % ratio of the apperture that is blured following an raised cosine
const.raised_cos        =   cos(linspace(-pi,pi,const.rCosine_grain*2));
const.raised_cos        =   const.raised_cos(1:const.rCosine_grain)';                           % cut half to have raising cosinus function
const.raised_cos        =   (const.raised_cos - min(const.raised_cos))/...
                                    (max(const.raised_cos)-min(const.raised_cos));              % normalize raising cosinus function
                                
% Stimulus circular aperture
const.stim_aperture     =   compStimAperture(const);                                            % define stimulus aperture alpha layer

% Fixation circular aperture
const.fix_out_rim_radVal=   0.3;                                                                % radius of outer circle of fixation bull's eye
const.fix_rim_radVal    =   0.75*const.fix_out_rim_radVal;                                      % radius of intermediate circle of fixation bull's eye in degree
const.fix_radVal        =   0.25*const.fix_out_rim_radVal;                                      % radius of inner circle of fixation bull's eye in degrees
const.fix_out_rim_rad   =   vaDeg2pix(const.fix_out_rim_radVal,scr);                            % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad       =   vaDeg2pix(const.fix_rim_radVal,scr);                                % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad           =   vaDeg2pix(const.fix_radVal,scr);                                    % radius of inner circle of fixation bull's eye in pixels
const.fix_aperture      =   compFixAperture(const);                                             % define fixation aperture
const.fix_annulus       =   compFixAnnulus(const);
const.fix_dot           =   compFixDot(const);
const.fix_dot_probe     =   const.fix_dot;

% Fixation lines
const.line_width = const.fix_rad;                                                               % fixation line width
const.line_color = const.white;                                                                 % fixation line color
const.line_fix_up_left = [const.rect_center(1) - const.apt_rad,...                              % up left part of fix cross x start
                          const.rect_center(1) - const.fix_out_rim_rad;....                     % up left part of fix cross x end
                          const.rect_center(2) - const.apt_rad,...                              % up left part of fix cross y start
                          const.rect_center(2) - const.fix_out_rim_rad];                        % up left part of fix cross y end

const.line_fix_up_right = [const.rect_center(1) + const.fix_out_rim_rad,...                     % up right part of fix cross x start
                           const.rect_center(1) + const.apt_rad;....                            % up right part of fix cross x end
                           const.rect_center(2) - const.fix_out_rim_rad,...                     % up right part of fix cross y start
                           const.rect_center(2) - const.apt_rad];                               % up right part of fix cross y end
                       
const.line_fix_down_left = [const.rect_center(1) - const.apt_rad,...                            % down left part of fix cross x start
                            const.rect_center(1) - const.fix_out_rim_rad;....                   % down left part of fix cross x end
                            const.rect_center(2) + const.apt_rad,...                            % down left part of fix cross y start
                            const.rect_center(2) + const.fix_out_rim_rad];                      % down left part of fix cross y end

const.line_fix_down_right = [const.rect_center(1) + const.fix_out_rim_rad,...                   % down right part of fix cross x start
                             const.rect_center(1) + const.apt_rad;....                          % down right part of fix cross x end
                             const.rect_center(2) + const.fix_out_rim_rad,...                   % down right part of fix cross y start
                             const.rect_center(2) + const.apt_rad;];                            % down right part of fix cross y end

%% Define all drawing frames
const.nb_trials_noise_freq = ((const.sp_stepCut * const.mc_stepCont + ...                       % total ammount of trials in noise frequence  
    const.length_break * const.num_break) * 2 - const.length_break) * const.TR_num_noise;
const.num_stim_periods = const.sp_stepCut * const.repetition_sp_sequence;                       % number of stimulation period

% stimulation sequence
const.break_trial_TR_freq = zeros(const.length_break, 1);                                       % break block in TR
const.stim_block_TR_freq = ones(const.mc_stepCont, 1);                                          % stim block in TR
const.break_stim_cycle_tr_freq = [const.break_trial_TR_freq; const.stim_block_TR_freq];         % break / stim cycle in TR
const.stim_sequence_tr_freq = repmat(const.break_stim_cycle_tr_freq,...                         % stimulation sequence in TR
    const.num_stim_periods, 1);
const.stim_sequence_tr_freq = [const.stim_sequence_tr_freq; const.break_trial_TR_freq];         % stimulation sequence in TR with final break
const.stim_sequence_noise_freq = repelem(const.stim_sequence_tr_freq, const.TR_num_noise);      % stimulation sequence in noise frequence
  
% Trial vecteur
const.trial_start = zeros(const.nb_trials_noise_freq, 1);
const.trial_start(mod(1:const.nb_trials_noise_freq, const.TR_num_noise) == 0) = 1;              % Timing for trial start in noise freq

% Prob and resp timing in one trial
const.prob_length = const.TR_num_noise / 2;                                                     % length of prob in noise freq
const.no_prob_length = (const.TR_num_noise - const.prob_length) / 2;                            % length of no prob in noise freq
const.resp_length = const.prob_length + const.no_prob_length;                                   % length of reponse window in noise freq

const.prob_trial = [zeros(1, const.no_prob_length),...                                          % one trial with prob in noise freq
    ones(1, const.prob_length), zeros(1, const.no_prob_length)];                                
const.prob_onset_trial = [zeros(1, const.no_prob_length),...                                    % onset of prob in one trial in noise freq
    ones(1, 1), zeros(1, const.prob_length - 1 + const.no_prob_length)];                        
const.resp_trial = [zeros(1, const.no_prob_length),...                                          % repons window in one trial in noise freq
    ones(1, const.resp_length)];
const.break_trial_noise_freq = zeros(const.TR_num_noise, 1);                                    % one break trial in noise freq
const.resp_reset_trial = [zeros(const.TR_num_noise-1, 1); 1];                                   % timing for reset answer window in one trial in noise freq

% Make sequence 
const.time2prob = []; 
const.probe_onset = [];
const.time2resp = [];
const.resp_reset = [];
for i = 1:length(const.stim_sequence_tr_freq)
    if const.stim_sequence_tr_freq(i) == 0
        const.time2prob = [const.time2prob(:); const.break_trial_noise_freq(:)]; 
        const.probe_onset = [const.probe_onset(:); const.break_trial_noise_freq(:)]; 
        const.time2resp = [const.time2resp(:); const.break_trial_noise_freq(:)];
        const.resp_reset = [const.resp_reset(:); const.break_trial_noise_freq(:)];
    elseif const.stim_sequence_tr_freq(i) == 1
        const.time2prob = [const.time2prob(:); const.prob_trial(:)]; 
        const.probe_onset = [const.probe_onset(:); const.prob_onset_trial(:)]; 
        const.time2resp = [const.time2resp(:); const.resp_trial(:)];
        const.resp_reset = [const.resp_reset(:); const.resp_reset_trial(:)];
    end
end
end