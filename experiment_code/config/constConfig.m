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
const.white = [255,255,255];                                                % white color
const.black = [0,0,0];                                                      % black color
const.background_color = const.black;                                       % background color
const.stim_color = const.white;                                             % stimulus color
const.ann_color = const.white;                                              % define anulus around fixation color
const.ann_probe_color = const.white;                                        % define anulus around fixation color when probe
const.dot_color =   const.white;                                            % define fixation dot color
const.dot_probe_color = const.black;                                        % define fixation dot color when probe

%% Time parameters
const.TR_dur = 1.6;                                                         % repetition time
const.TR_num = (floor(const.TR_dur/scr.frame_duration));                    % repetition time in screen frames

const.noise_freq = 10;                                                      % compute noise frequency in hertz
const.patch_dur = 1/const.noise_freq;                                       % compute single patch duration in seconds
const.TR_num_noise = (floor(const.TR_dur/const.patch_dur));                 % repetition time in noise frames

%% Stim parameters

% Noise parameters
const.noise_num = 10;                                                       % number of generated patches
const.noise_pixel = 1;                                                      % stimulus noise pixel size in pixels
const.stim_size = [scr.scr_sizeY,scr.scr_sizeY];                            % full screen stimuli size in pixels
const.noise_size = const.stim_size(1);                                      % size of the patch
const.native_noise_dim = round([const.noise_size/const.noise_pixel,...      % starting size of the patch
    const.noise_size/const.noise_pixel]);
const.noise_dpp = scr.screen_dpp(1) * const.noise_pixel;                    % noise pixel in dva
const.stim_rect = [scr.x_mid - const.noise_size/2;...                       % rect of the actual stimulus
    scr.y_mid - const.noise_size/2;...
    scr.x_mid + const.noise_size/2;...
    scr.y_mid + const.noise_size/2];
const.disp_max = (scr.scr_sizeY - scr.disp_margin_top ...                   % Scanner display size visible in pixels
    - scr.disp_margin_bottom);
const.rect_center =  [scr.x_mid, ...
    scr.disp_margin_top + const.disp_max/2];                                % Center of the rect in projector screen

const.rect_noise        =  [const.rect_center(1) - const.noise_size/2;...   % Noise native rect
    const.rect_center(2) - const.noise_size/2;...
    const.rect_center(1) + const.noise_size/2;...
    const.rect_center(2) + const.noise_size/2];

% Kappa and staircase
const.native_noise_orientation = 90;                                       	% Von misses original orientation
const.num_steps_kappa = 15;                                                 % Number of kappa steps
const.noise_kappa = [0,10.^(linspace(-1,1.5,const.num_steps_kappa-1))];     % Von misses filter kappa parameter (1st = noise, last = less noisy)

% Spatial Frequency filter
const.sf_minFreq = 0.5;                                                     % Minimal central spatial frequency filter in cycle/dva
const.sf_maxFreq = 20;                                                      % Maximal central spatial frequency filter in cycle/dva
const.sf_filtNum = 6;                                                       % Number of spatial frequency filters
const.sf_filtOverlap = 0.6;                                                 % Proportion of overlaping for the gaussian spatial frequency filters 
const.sf_seqNum = 2;                                                        % Number of repetition of de spatial frequency sequence (for ascending and descending contrast gradient)
const.sf_filtCenters = round(logspace(log10(const.sf_minFreq), ...          % Centers (mu) of the gaussians spatial frequency filters
    log10(const.sf_maxFreq), const.sf_filtNum),2);
const.sf_logDiff = log10(const.sf_filtCenters(2)) - ...
    log10(const.sf_filtCenters(1));
const.sf_cutSigma  = sqrt(-const.sf_logDiff^2 / ...                         % Sigma (std) of the gaussians spatial frequency filters
    (4 * log(const.sf_filtOverlap)));         

% Michelson contrast
const.minCont = 0.0025;                                                     % Minimal Michelson contrast value
const.maxCont = 0.8;                                                        % Maximal Michelson contrast value
const.contNum = 6;                                                          % Number of Michelson contrast value
const.contValues = logspace(log10(const.minCont), ...                       % Michelson contrast values
    log10(const.maxCont), const.contNum);

% Breaks
const.breakNum = const.sf_filtNum + 1;                                      % number of breaks
const.break_trs = 10;                                                       % duration of breaks (in TR)

% Apertures
const.apt_rad_val = 6.5;                                                    % Aperture stimuli radius in dva
const.apt_rad = vaDeg2pix(const.apt_rad_val,scr);                           % Aperture stimuli radius in pixels
const.rCosine_grain = 80;                                                   % Grain of the radius cosine steps
const.aperture_blur = 0.01;                                                 % Ratio of the apperture that is blured following an raised cosine
const.raised_cos = cos(linspace(-pi,pi,const.rCosine_grain*2));
const.raised_cos = const.raised_cos(1:const.rCosine_grain)';                % Cut half to have raising cosinus function
const.raised_cos = (const.raised_cos - min(const.raised_cos))/...
    (max(const.raised_cos)-min(const.raised_cos));                          % Normalize raising cosinus function

% Stimulus circular aperture
const.stim_aperture = compStimAperture(const);                              % Define stimulus aperture alpha layer

% Fixation circular aperture
const.fix_out_rim_radVal = 0.3;                                             % Radius of outer circle of fixation bull's eye
const.fix_rim_radVal = 0.75*const.fix_out_rim_radVal;                       % Radius of intermediate circle of fixation bull's eye in degree
const.fix_radVal = 0.25*const.fix_out_rim_radVal;                           % Radius of inner circle of fixation bull's eye in degrees
const.fix_out_rim_rad = vaDeg2pix(const.fix_out_rim_radVal,scr);            % Radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad = vaDeg2pix(const.fix_rim_radVal,scr);                    % Radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad = vaDeg2pix(const.fix_radVal,scr);                            % Radius of inner circle of fixation bull's eye in pixels
const.fix_aperture = compFixAperture(const);                                % Define fixation aperture
const.fix_annulus = compFixAnnulus(const);
const.fix_dot = compFixDot(const);
const.fix_dot_probe = const.fix_dot;

% Fixation lines
const.line_width = const.fix_rad;                                           % fixation line width
const.line_color = const.white;                                             % fixation line color
const.line_fix_up_left = [const.rect_center(1) - const.apt_rad,...          % up left part of fix cross x start
    const.rect_center(1) - const.fix_out_rim_rad;....                       % up left part of fix cross x end
    const.rect_center(2) - const.apt_rad,...                                % up left part of fix cross y start
    const.rect_center(2) - const.fix_out_rim_rad];                          % up left part of fix cross y end

const.line_fix_up_right = [const.rect_center(1) + const.fix_out_rim_rad,... % up right part of fix cross x start
    const.rect_center(1) + const.apt_rad;....                               % up right part of fix cross x end
    const.rect_center(2) - const.fix_out_rim_rad,...                        % up right part of fix cross y start
    const.rect_center(2) - const.apt_rad];                                  % up right part of fix cross y end

const.line_fix_down_left = [const.rect_center(1) - const.apt_rad,...        % down left part of fix cross x start
    const.rect_center(1) - const.fix_out_rim_rad;....                       % down left part of fix cross x end
    const.rect_center(2) + const.apt_rad,...                                % down left part of fix cross y start
    const.rect_center(2) + const.fix_out_rim_rad];                          % down left part of fix cross y end

const.line_fix_down_right = [const.rect_center(1) + const.fix_out_rim_rad,...% down right part of fix cross x start
    const.rect_center(1) + const.apt_rad;....                               % down right part of fix cross x end
    const.rect_center(2) + const.fix_out_rim_rad,...                        % down right part of fix cross y start
    const.rect_center(2) + const.apt_rad;];                                 % down right part of fix cross y end

%% Define all drawing frames
const.nb_trials = const.sf_filtNum * const.contNum * 2 + ...                % total ammount of trials
    const.breakNum * const.break_trs;
const.nb_trials_noise_freq = const.nb_trials * const.TR_num_noise;          % total ammount of trials in noise frequence
const.num_stim_periods = const.sf_filtNum * const.sf_seqNum;                % number of stimulation period

% stimulation sequence
const.break_trial_TR_freq = zeros(const.break_trs, 1);                      % break block in TR
const.stim_block_TR_freq = ones(const.contNum, 1);                          % stim block in TR
const.break_stim_cycle_tr_freq = [const.break_trial_TR_freq; ...
    const.stim_block_TR_freq];                                              % break / stim cycle in TR
const.stim_sequence_tr_freq = repmat(const.break_stim_cycle_tr_freq,...     % stimulation sequence in TR
    const.num_stim_periods, 1);
const.stim_sequence_tr_freq = [const.stim_sequence_tr_freq; 
    const.break_trial_TR_freq];                                             % stimulation sequence in TR with final break
const.stim_sequence_noise_freq = repelem(const.stim_sequence_tr_freq, ...
    const.TR_num_noise);                                                    % stimulation sequence in noise frequence

% Trial vecteur
const.trial_start = zeros(const.nb_trials_noise_freq, 1);
const.trial_start(mod(1:const.nb_trials_noise_freq, ...
    const.TR_num_noise) == 0) = 1;                                          % Timing for trial start in noise freq

% Prob and resp timing in one trial
const.prob_length = const.TR_num_noise / 2;                                 % length of prob in noise freq
const.no_prob_length = (const.TR_num_noise - const.prob_length) / 2;        % length of no prob in noise freq
const.resp_length = const.prob_length + const.no_prob_length;               % length of reponse window in noise freq

const.prob_trial = [zeros(1, const.no_prob_length),...                      % one trial with prob in noise freq
    ones(1, const.prob_length), zeros(1, const.no_prob_length)];
const.prob_onset_trial = [zeros(1, const.no_prob_length),...                % onset of prob in one trial in noise freq
    ones(1, 1), zeros(1, const.prob_length - 1 + const.no_prob_length)];
const.resp_trial = [zeros(1, const.no_prob_length),...                      % repons window in one trial in noise freq
    ones(1, const.resp_length)];
const.break_trial_noise_freq = zeros(const.TR_num_noise, 1);                % one break trial in noise freq
const.resp_reset_trial = [zeros(const.TR_num_noise-1, 1); 1];               % timing for reset answer window in one trial in noise freq

% Make sequence

% contrast sequences
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