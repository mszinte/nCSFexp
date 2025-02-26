function [const] = constConfig(scr,const)
% ----------------------------------------------------------------------
% [const] = constConfig(scr,const)
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
% Const description :
% trial : one TR
% block : chain of break or stimulation trials 
% sequence : break, descending contrast gradient, ascending contrast gradient
% run : chain of sequence 
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------

% Fix randomization
[const.seed, const.whichGen] = ClockRandSeed;
rng(const.seed);

%% Colors
const.white = [255,255,255];                                                % White color
const.black = [0,0,0];                                                      % Black color
const.background_color = const.black;                                       % Background color
const.stim_color = const.white;                                             % Stimulus color
const.ann_color = const.white;                                              % Define anulus around fixation color
const.ann_probe_color = const.white;                                        % Define anulus around fixation color when probe
const.dot_color =   const.white;                                            % Define fixation dot color
const.dot_probe_color = const.black;                                        % Define fixation dot color when probe

%% Time parameters
const.TR_dur = 1.6;                                                         % Repetition time
const.TR_num = (floor(const.TR_dur/scr.frame_duration));                    % Repetition time in screen frames

const.noise_freq = 10;                                                      % Compute noise frequency in hertz
const.patch_dur = 1/const.noise_freq;                                       % Compute single patch duration in seconds
const.TR_num_noise = (floor(const.TR_dur/const.patch_dur));                 % Repetition time in noise frames

%% Stim parameters

% Noise parameters
% ----------------
const.noise_num = 20;                                                       % Number of generated patches
const.noise_seeds = randi([1, 10000], 1, const.noise_num);                  % Seeds for noise
const.noise_pixel = 1;                                                      % Stimulus noise pixel size in pixels
const.stim_size = [scr.scr_sizeY,scr.scr_sizeY];                            % Full screen stimuli size in pixels
const.noise_size = const.stim_size(1);                                      % Size of the patch
const.native_noise_dim = round([const.noise_size/const.noise_pixel,...      % Starting size of the patch
    const.noise_size/const.noise_pixel]);
const.noise_dpp = scr.screen_dpp(1) * const.noise_pixel;                    % Noise pixel in dva
const.stim_rect = [scr.x_mid - const.noise_size/2;...                       % Rect of the actual stimulus
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
% -------------------
const.native_noise_orientation = 90;                                       	% Von misses original orientation
const.num_steps_kappa = 15;                                                 % Number of kappa steps in pRF task
const.noise_kappa = [0, 10.^(linspace(-1, 1.5, ...
                                      const.num_steps_kappa-1))];           % Von misses filter kappa parameter (1st = noise, last = less noisy) in pRF

const.noise_kappa_threshold = 10;                                           % kappa at threshold (based on previous pRF experiment)


% Spatial Frequency filter
% ------------------------
const.sf_minFreq = 0.5;                                                     % Minimal central spatial frequency filter in cycle/dva
const.sf_maxFreq = 20;                                                      % Maximal central spatial frequency filter in cycle/dva
const.sf_filtNum = 6;                                                       % Number of spatial frequency filters
const.sf_filtOverlap = 0.6;                                                 % Proportion of overlaping for the gaussian spatial frequency filters 
const.sf_filtCenters = round(logspace(log10(const.sf_minFreq), ...          % Centers (mu) of the gaussians spatial frequency filters
    log10(const.sf_maxFreq), const.sf_filtNum),2);
const.sf_logDiff = log10(const.sf_filtCenters(2)) - ...
    log10(const.sf_filtCenters(1));
const.sf_cutSigma  = sqrt(-const.sf_logDiff^2 / ...                         % Sigma (std) of the gaussians spatial frequency filters
    (4 * log(const.sf_filtOverlap)));         

% Michelson contrast
% ------------------
const.minCont = 0.0025;                                                     % Minimal Michelson contrast value
const.maxCont = 0.8;                                                        % Maximal Michelson contrast value
const.contNum = 6;                                                          % Number of Michelson contrast value
const.contValues = logspace(log10(const.minCont), ...                       % Michelson contrast values
    log10(const.maxCont), const.contNum);


% Run sequence
% ------------
const.run_sequence = repmat([3, 2, 1], 1, const.sf_filtNum);                % 1: ascending contrast; 2: descending contrast; 3: Blank
const.run_sequence = [const.run_sequence, 3];                               % add last blank

% Breaks
% ------
const.breakNum = const.sf_filtNum + 1;                                      % Number of breaks
const.break_trs = 10;                                                       % Duration of breaks (in TR)

% Apertures
% ---------
const.apt_rad_val = 6.5;                                                    % Aperture stimuli radius in dva
const.apt_rad = vaDeg2pix(const.apt_rad_val,scr);                           % Aperture stimuli radius in pixels
const.rCosine_grain = 80;                                                   % Grain of the radius cosine steps
const.aperture_blur = 0.01;                                                 % Ratio of the apperture that is blured following an raised cosine
const.raised_cos = cos(linspace(-pi,pi,const.rCosine_grain*2));
const.raised_cos = const.raised_cos(1:const.rCosine_grain)';                % Cut half to have raising cosinus function
const.raised_cos = (const.raised_cos - min(const.raised_cos))/...
    (max(const.raised_cos)-min(const.raised_cos));                          % Normalize raising cosinus function

% Stimulus circular aperture
% --------------------------
const.stim_aperture = compStimAperture(const);                              % Define stimulus aperture alpha layer

% Fixation circular aperture
% --------------------------
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
% --------------
const.line_width = const.fix_rad;                                           % Fixation line width
const.line_color = const.white;                                             % Fixation line color
const.line_fix_up_left = [const.rect_center(1) - const.apt_rad,...          % Up left part of fix cross x start
    const.rect_center(1) - const.fix_out_rim_rad;....                       % Up left part of fix cross x end
    const.rect_center(2) - const.apt_rad,...                                % Up left part of fix cross y start
    const.rect_center(2) - const.fix_out_rim_rad];                          % Up left part of fix cross y end

const.line_fix_up_right = [const.rect_center(1) + const.fix_out_rim_rad,... % Up right part of fix cross x start
    const.rect_center(1) + const.apt_rad;....                               % Up right part of fix cross x end
    const.rect_center(2) - const.fix_out_rim_rad,...                        % Up right part of fix cross y start
    const.rect_center(2) - const.apt_rad];                                  % Up right part of fix cross y end

const.line_fix_down_left = [const.rect_center(1) - const.apt_rad,...        % Down left part of fix cross x start
    const.rect_center(1) - const.fix_out_rim_rad;....                       % Down left part of fix cross x end
    const.rect_center(2) + const.apt_rad,...                                % Down left part of fix cross y start
    const.rect_center(2) + const.fix_out_rim_rad];                          % Down left part of fix cross y end

const.line_fix_down_right = [const.rect_center(1) + ...
    const.fix_out_rim_rad,...                                               % Down right part of fix cross x start
    const.rect_center(1) + const.apt_rad;....                               % Down right part of fix cross x end
    const.rect_center(2) + const.fix_out_rim_rad,...                        % Down right part of fix cross y start
    const.rect_center(2) + const.apt_rad;];                                 % Down right part of fix cross y end

%% Define all drawing frames
const.trialsNum = const.sf_filtNum * const.contNum * 2 + ...                % Total ammount of trials
    const.breakNum * const.break_trs;
const.trialsNum_noiseFreq = const.trialsNum * const.TR_num_noise;           % Total ammount of trials in noise frequence
const.seqNum = const.sf_filtNum;                                            % Number of sequences

% Create a run 
% ------------
% Break and stim block 
const.breakBlock_trFreq = zeros(const.break_trs, 1);                        % Break block in TR
const.stimBlock_trFreq = ones(const.contNum, 1);                            % Stim block in TR

% Sequence (break, descending, ascending)
const.seq_trFreq = [const.breakBlock_trFreq; const.stimBlock_trFreq;...
    const.stimBlock_trFreq];                                                % Sequence of break descending ascending

% Run 
const.run_trFreq = repmat(const.seq_trFreq, const.seqNum, 1);               % One run in TR
const.run_trFreq = [const.run_trFreq; const.breakBlock_trFreq];             % Run with final break

% Create timings trials
% ----------------------
const.prob_length = const.TR_num_noise / 2;                                 % Length of prob in noise freq
const.no_prob_length = (const.TR_num_noise - const.prob_length) / 2;        % Length of no prob in noise freq
const.resp_length = const.prob_length + const.no_prob_length;               % Length of reponse window in noise freq

% break 
const.breakTrial_noiseFreq = zeros(const.TR_num_noise, 1);                  % Break trial in noise freq

% Trials start
const.trial_start = zeros(const.trialsNum_noiseFreq, 1);
const.trial_start(mod(1:const.trialsNum_noiseFreq, ...
    const.TR_num_noise) == 0) = 1;                                          % Timing for trial start in noise freq

% Prob
const.prob_trial = [zeros(const.no_prob_length, 1);...                      
    ones(const.prob_length, 1); zeros(const.no_prob_length, 1)];            % One trial with prob in noise freq

const.prob_onset_trial = [zeros(const.no_prob_length, 1);...                
    1; zeros(const.prob_length - 1 + const.no_prob_length, 1)];             % Onset of prob in one trial in noise freq

% Resp
const.resp_trial = [zeros(const.no_prob_length, 1);...                      
    ones(const.resp_length, 1)];                                            % Response window in one trial in noise freq

const.resp_reset_trial = [zeros(const.TR_num_noise-1, 1); 1];               % Timing for reset answer window in one trial in noise freq

% Create timings run
% ------------------
const.time2prob = [];
const.probe_onset = [];
const.time2resp = [];
const.resp_reset = [];

for i = 1:const.trialsNum
    if const.run_trFreq(i) == 0 % break 
        const.time2prob = [const.time2prob; const.breakTrial_noiseFreq];
        const.probe_onset = [const.probe_onset; const.breakTrial_noiseFreq];
        const.time2resp = [const.time2resp; const.breakTrial_noiseFreq];
        const.resp_reset = [const.resp_reset; const.breakTrial_noiseFreq];

    elseif const.run_trFreq(i) == 1 % stim
        const.time2prob = [const.time2prob; const.prob_trial];
        const.probe_onset = [const.probe_onset; const.prob_onset_trial];
        const.time2resp = [const.time2resp; const.resp_trial];
        const.resp_reset = [const.resp_reset; const.resp_reset_trial];

    end
end
end