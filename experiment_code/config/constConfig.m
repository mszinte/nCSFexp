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


%% Stim parameters

% Colors
% ------
const.white = [255,255,255];                                                % White color
const.gray = [128, 128, 128];                                               % Mid gray
const.black = [0,0,0];                                                      % Black color
const.background_color = const.gray;                                        % Background color
const.stim_color = const.white;                                             % Stimulus color
const.ann_color = const.white;                                              % Define anulus around fixation color
const.ann_probe_color = const.white;                                        % Define anulus around fixation color when probe
const.dot_color = const.white;                                              % Define fixation dot color
const.dot_probe_color = const.background_color;                             % Define fixation dot color when probe

% Noise parameters
% ----------------
const.noise_num = 20;                                                       % Number of generated patches
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

%% Time parameters

const.noise_freq = 10;                                                      % Compute noise frequency in hertz
const.noise_dur_sec = 1 / const.noise_freq;                                 % compute single patch duration in seconds
const.TR_dur_sec = 1.6;                                                     % Repetition time in seconds
const.TR_dur_nnf = (floor(const.TR_dur_sec * const.noise_freq));            % Repetition time in number of noise frames
const.probe_dur_sec = const.TR_dur_sec / 2;                                 % Probe duration in seconds
const.probe_dur_nnf = (floor(const.probe_dur_sec * const.noise_freq));      % Probe duration in number of noise frames
const.no_probe_dur_nnf = (const.TR_dur_nnf - const.probe_dur_nnf) / 2;      % Number of frame without probe in noise frames
const.resp_dur_nnf = const.probe_dur_nnf + const.no_probe_dur_nnf;          % Reponse window in noise frames

% Create timings trials
% ----------------------
const.time2probe = [zeros(const.no_probe_dur_nnf, 1);...                  
                    ones(const.probe_dur_nnf, 1); ...
                    zeros(const.no_probe_dur_nnf, 1)];                      % Matrix of time to probe in a trial
                
const.resp_reset = [1; zeros(const.TR_dur_nnf-1, 1)];                       % Matrix of reset answer window in one trial

const.time2resp = [zeros(const.no_probe_dur_nnf, 1);...                      
                    ones(const.resp_dur_nnf, 1)];                           % Matrix of response window

const.probe_onset = [zeros(const.no_probe_dur_nnf, 1);...
                     1; ...
                     zeros(const.resp_dur_nnf - 1, 1)];                     % Matrix of probe onset

const.rand_num_tex = randperm(const.noise_num);
const.rand_num_tex = const.rand_num_tex(1:const.TR_dur_nnf);                % Matrix of random noise generation number in each trial

%% Experimentatal settings

% Orientation
% -----------
const.oriNum = 2;                                                           % Number of signal orientations
const.noise_orientations = [45, -45];                                       % Signal orientations
const.num_steps_kappa = 15;                                                 % Number of kappa steps in pRF task
const.noise_kappa = [0, 10.^(linspace(-1, 1.5, ...
                                      const.num_steps_kappa-1))];           % Von misses filter kappa parameter (1st = noise, last = less noisy) in pRF

const.num_steps_kappa_used = 2;                                             % kappa level used in nCSF task
const.kappa_noise_num = 1;                                                  % kappa for noise texture
const.kappa_probe_num = 10;                                                 % kappa for probe texture (defined as a function of previous experience)

% Spatial Frequency filter
% ------------------------
const.sf_minFreq = 0.05;                                                     % Minimal central spatial frequency filter in cycle/dva
const.sf_maxFreq = 0.5;                                                      % Maximal central spatial frequency filter in cycle/dva
const.sf_filtNum = 6;                                                       % Number of spatial frequency filters
const.sf_filtOverlap = 0.6;                                                 % Proportion of overlaping for the gaussian spatial frequency filters 
const.sf_filtCenters = round(logspace(log10(const.sf_minFreq), ...          % Centers (mu) of the gaussians spatial frequency filters
    log10(const.sf_maxFreq), const.sf_filtNum),2);
const.sf_logDiff = log10(const.sf_filtCenters(2)) - ...
    log10(const.sf_filtCenters(1));
const.sf_cutSigma  = sqrt(-const.sf_logDiff^2 / ...                         % Sigma (std) of the gaussians spatial frequency filters
    (4 * log(const.sf_filtOverlap)));         


% Luminance
% ---------
const.mean_luminance = 0.5;                                                 % Noise mean luminance in ratio of full luminance

% Michelson contrast
% ------------------
if const.psy
    const.minCont = 0.0025;                                                 % Minimal Michelson contrast value
    const.maxCont = 0.8;                                                    % Maximal Michelson contrast value
    const.contNum = 12;                                                     % Number of Michelson contrast value
else
    const.minCont = 0.0025;                                                 % Minimal Michelson contrast value
    const.maxCont = 0.8;                                                    % Maximal Michelson contrast value
    const.contNum = 12;                                                      % Number of Michelson contrast value
end
const.contValues = logspace(log10(const.minCont), ...                       % Michelson contrast values
log10(const.maxCont), const.contNum);

% General settings
% ----------------
if const.psy
    const.breakNum = 2;                                                     % Number of breaks
    const.break_trs = 4;                                                    % Duration of breaks (in TR)
    const.run_sequence = repmat([2, 1], 1, const.sf_filtNum);               % 1: ascending contrast; 2: descending contrast;
    const.run_sequence = [repmat(3, 1, 1),...
                          const.run_sequence,...
                          repmat(3, 1, 1)];                                 % add blank at the begining and at the end
    const.trialsNum = const.sf_filtNum * const.contNum * 2 ...
                      + const.breakNum * const.break_trs;                   % Total ammount of trials
else
    const.breakNum = const.sf_filtNum + 1;                                  % Number of breaks
    const.break_trs = 10;                                                   % Duration of breaks (in TR)
    const.run_sequence = repmat([3, 2, 1], 1, const.sf_filtNum);            % 1: ascending contrast; 2: descending contrast; 3: Blank
    const.run_sequence = [const.run_sequence, 3];                           % add last blank
    const.trialsNum = const.sf_filtNum * const.contNum * 2 + ...            % Total ammount of trials
                  const.breakNum * const.break_trs;
end 

const.TRs = const.trialsNum;                                                % Number of TR
if const.scanner
    fprintf(1,'\n\tScanner parameters; %1.0f TRs, %1.2f seconds, %s\n', ...
        const.TRs, const.TR_dur_sec, datestr(seconds((const.TRs * const.TR_dur_sec)),'MM:SS'));              
end
end