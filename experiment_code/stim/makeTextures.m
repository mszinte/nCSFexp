function makeTextures(scr, const)
% ----------------------------------------------------------------------
% makeTextures(scr, const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make textures for later drawing them
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% none - images saved
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Adapted by Uriel LASCOMBES (uriel.lascombes@laposte.net)
% Project : nCSFexp
% ----------------------------------------------------------------------
fprintf(1,'\n\tDrawing all texture screens\n\t');

% delete old folder
if isfolder(const.stim_folder)
    rmdir(const.stim_folder, 's')
end
if ~isfolder(const.stim_folder)
    mkdir(const.stim_folder)
end

% waiting draw image
[imageToDraw, ~, alpha] = imread('instructions/image/WaintingTex.png');
imageToDraw(:, :, 4) = alpha;
t_handle = Screen('MakeTexture', scr.main, imageToDraw);
texrect = Screen('Rect', t_handle);
Screen('FillRect', scr.main, const.background_color);
Screen('DrawTexture', scr.main, t_handle, texrect, [0, 0, scr.scr_sizeX,scr.scr_sizeY]);
Screen('Flip', scr.main);
Screen('Close', t_handle);

% Make black noise
black_fix_noise(:, :, 1) = zeros(round(const.noise_size), round(const.noise_size), 1) + const.background_color(1);
black_fix_noise(:, :, 2) = zeros(round(const.noise_size), round(const.noise_size), 1) + const.background_color(2);
black_fix_noise(:, :, 3) = zeros(round(const.noise_size), round(const.noise_size), 1) + const.background_color(3);
black_fix_noise(:, :, 4) = const.fix_aperture;
tex_black_fix_noise = Screen('MakeTexture', scr.main, black_fix_noise);

% Make annulus
fix_ann = ones(round(const.noise_size), round(const.noise_size), 4);
fix_ann_no_probe(:, :, 1) = fix_ann(:, :, 1) * const.ann_color(1);
fix_ann_no_probe(:, :, 2) = fix_ann(:, :, 2) * const.ann_color(2);
fix_ann_no_probe(:, :, 3) = fix_ann(:, :, 3) * const.ann_color(3);
fix_ann_no_probe(:, :, 4) = const.fix_annulus;
tex_fix_ann_no_probe = Screen('MakeTexture', scr.main, fix_ann_no_probe);

% Make annulus when probe
fix_ann_probe(:, :, 1) = fix_ann(:, :, 1) * const.ann_probe_color(1);
fix_ann_probe(:, :, 2) = fix_ann(:, :, 2) * const.ann_probe_color(2);
fix_ann_probe(:, :, 3) = fix_ann(:, :, 3) * const.ann_probe_color(3);
fix_ann_probe(:, :, 4) = const.fix_annulus;
tex_fix_ann_probe = Screen('MakeTexture', scr.main, fix_ann_probe);

% Make fixation dot
fix_dot = ones(round(const.noise_size), round(const.noise_size), 4);
fix_dot_no_probe(:, :, 1) = fix_dot(:, :, 1) * const.dot_color(1);
fix_dot_no_probe(:, :, 2) = fix_dot(:, :, 2) * const.dot_color(2);
fix_dot_no_probe(:, :, 3) = fix_dot(:, :, 3) * const.dot_color(3);
fix_dot_no_probe(:, :, 4) = const.fix_dot;
tex_fix_dot_no_probe = Screen('MakeTexture', scr.main, fix_dot_no_probe);

% Make fixation dot when probe
fix_dot_probe(:, :, 1) = fix_dot(:, :, 1) * const.dot_probe_color(1);
fix_dot_probe(:, :, 2) = fix_dot(:, :, 2) * const.dot_probe_color(2);
fix_dot_probe(:, :, 3) = fix_dot(:, :, 3) * const.dot_probe_color(3);
fix_dot_probe(:, :, 4) = const.fix_dot_probe;
tex_fix_dot_probe = Screen('MakeTexture', scr.main, fix_dot_probe);

% Make noise and combine all
noise_rand_num = const.noise_num;
sf_cut_num = const.sf_filtNum;
mc_cut_num = const.contNum;
kappa_num = const.num_steps_kappa_used;
ori_num = const.oriNum;

% Define rect
rect_noise = const.rect_noise;

% compute total amount of picture to print
numPrint = 0;
total_amount = (noise_rand_num * sf_cut_num * mc_cut_num * kappa_num) + 2;
textprogressbar('Progress: ');

seed_num = 0;
for kappa = 1:const.num_steps_kappa_used
    for sp_val_stim = 1:sf_cut_num
        for contrast_val_stim = 1:mc_cut_num
            for noise_rand = 1:noise_rand_num
                for noise_ori = 1:ori_num
                    % Noise seed
                    seed_num = seed_num +1;
    
                    % make stim texture full screen
                    sp_sigma_val = const.sf_cutSigma;
                    sp_center_val = const.sf_filtCenters(sp_val_stim);
                    contrast_val = const.contValues(contrast_val_stim);
                    orientation_val = const.noise_orientations(noise_ori);
                    if kappa == 1
                        kappa_val = const.noise_kappa(const.kappa_noise_num);
                        tex_fix_dot = tex_fix_dot_no_probe;
                        orientation_val = 0;
                        screen_filename = sprintf('%s/noprobe_sfStim%i_contStim%i_noiseRand%i_kappaNum%i.mat', ...
                                                  const.stim_folder, sp_val_stim,...
                                                  contrast_val_stim, noise_rand, const.kappa_noise_num);
                    elseif kappa == 2
                        kappa_val = const.noise_kappa(const.kappa_probe_num);
                        tex_fix_dot = tex_fix_dot_probe;
    
                        screen_filename = sprintf('%s/probe_sfStim%i_contStim%i_noiseRand%i_kappaNum%i_ori-%i.mat', ...
                                                  const.stim_folder, sp_val_stim,...
                                                  contrast_val_stim, noise_rand, const.kappa_probe_num, noise_ori);
                    end
                        
                    mat_noise = genNoisePatch(const, sp_center_val, ...
                        sp_sigma_val, kappa_val, orientation_val, contrast_val, const.noise_seeds(seed_num));
    
                    noise_patch(:,:,1) = mat_noise * const.stim_color(1);
                    noise_patch(:,:,2) = mat_noise * const.stim_color(2);
                    noise_patch(:,:,3) = mat_noise * const.stim_color(3);
                    noise_patch(:,:,4) = const.stim_aperture;
    
                    tex_stim = Screen('MakeTexture', scr.main, noise_patch);
                    clear noise_patch
    
                    % define all texture parameters
                    rects = [rect_noise,...                                 % stim noise
                             rect_noise,...                                 % fix annulus
                             rect_noise,...                                 % empty center
                             rect_noise];                                   % fixation dot
    
                    texs = [tex_stim,...                                    % stim noise
                            tex_fix_ann_probe,...                           % fix annulus
                            tex_black_fix_noise,...                         % empty center
                            tex_fix_dot];                                   % fixation dot
    
                    % draw all textures
                    Screen('FillRect', scr.main, const.background_color);
                    Screen('DrawTextures', scr.main, texs, [], rects)
                    Screen('DrawLines', scr.main, const.line_fix_up_left, const.line_width, const.white, [], 1);
                    Screen('DrawLines', scr.main, const.line_fix_up_right, const.line_width, const.white, [], 1);
                    Screen('DrawLines', scr.main, const.line_fix_down_left, const.line_width, const.white, [], 1);
                    Screen('DrawLines', scr.main, const.line_fix_down_right, const.line_width, const.white, [], 1);
                    Screen('DrawingFinished', scr.main, [], 1);
                
                    if const.drawStimuli
                        % plot and save the screenshot
                        Screen('Flip', scr.main);
                        screen_stim = Screen('GetImage', scr.main, const.stim_rect, [], 0, 1);
                    else
                        % save the screenshot
                        screen_stim = Screen('GetImage', scr.main, const.stim_rect, 'backBuffer', [], 1);
                    end
    
                    save(screen_filename, 'screen_stim')
                    clear screen_stim
    
                    numPrint = numPrint + 1;
                    textprogressbar(numPrint * 100 / total_amount);
    
                    % close opened texture
                    Screen('Close', tex_stim);
            
                end
            end
        end
    end
end

% make wait first tr screenshot
rects = [rect_noise,...                                                 % fix annulus
         rect_noise,...                                                 % empty center
         rect_noise];                                                   % fixation dot
texs = [tex_fix_ann_no_probe,...                                        % fix annulus
        tex_black_fix_noise,...                                         % empty center
        tex_fix_dot_probe];                                             % fixation dot

Screen('FillRect', scr.main, const.background_color);
Screen('DrawTextures', scr.main, texs, [], rects)
Screen('DrawLines', scr.main, const.line_fix_up_left, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_up_right, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_down_left, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_down_right, const.line_width, const.white, [], 1);
Screen('DrawingFinished', scr.main, [], 1);

if const.drawStimuli
    % plot and save the screenshot
    Screen('Flip', scr.main);
    screen_stim = Screen('GetImage', scr.main, const.stim_rect, [], 0, 1);
else
    % save the screenshot
    screen_stim = Screen('GetImage', scr.main, const.stim_rect, 'backBuffer', [], 1);
end
screen_filename = sprintf('%s/first_tr.mat', const.stim_folder);
save(screen_filename, 'screen_stim')
clear screen_stim

numPrint = numPrint + 1;
textprogressbar(numPrint * 100 / total_amount);

% make inter-interval screenshot
rects = [rect_noise,...                                                  % fix annulus
         rect_noise,...                                                  % empty center
         rect_noise];                                                    % fixation dot
texs = [tex_fix_ann_no_probe,...                                         % fix annulus
         tex_black_fix_noise,...                                         % empty center
         tex_fix_dot_no_probe];                                          % fixation dot

Screen('FillRect', scr.main, const.background_color);
Screen('DrawTextures', scr.main, texs, [], rects)
Screen('DrawLines', scr.main, const.line_fix_up_left, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_up_right, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_down_left, const.line_width, const.white, [], 1);
Screen('DrawLines', scr.main, const.line_fix_down_right, const.line_width, const.white, [], 1);
Screen('DrawingFinished', scr.main, [], 1);

if const.drawStimuli
    % plot and save the screenshot
    Screen('Flip', scr.main);
    screen_stim = Screen('GetImage', scr.main, const.stim_rect, [], 0, 1);
else
    % save the screenshot
    screen_stim = Screen('GetImage', scr.main, const.stim_rect, 'backBuffer', [], 1);
end
screen_filename = sprintf('%s/blank.mat', const.stim_folder);
save(screen_filename, 'screen_stim')
clear screen_stim

numPrint = numPrint + 1;
textprogressbar(numPrint * 100 / total_amount);

% Close all textures
Screen('Close', tex_black_fix_noise);
Screen('Close', tex_fix_ann_probe);
Screen('Close', tex_fix_ann_no_probe);
Screen('Close', tex_fix_dot_no_probe);
Screen('Close', tex_fix_dot_probe);

end