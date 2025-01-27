function makeTextures(scr,const)
% ----------------------------------------------------------------------
% makeTextures(scr,const)
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
% Project : prfexp7t
% Version : 1.0
% ----------------------------------------------------------------------
fprintf(1,'\n\tDrawing all texture screens\n\t');

% delete old folder
if isfolder(const.stim_folder)
    rmdir(const.stim_folder,'s')
end
if ~isfolder(const.stim_folder)
    mkdir(const.stim_folder)
end

% waiting draw image
[imageToDraw,~,alpha]   =   imread('instructions/image/WaintingTex.png');
imageToDraw(:,:,4)      =   alpha;
t_handle                =   Screen('MakeTexture',scr.main,imageToDraw);
texrect                 =   Screen('Rect', t_handle);
Screen('FillRect',scr.main,const.background_color);
Screen('DrawTexture',scr.main,t_handle,texrect,[0,0,scr.scr_sizeX,scr.scr_sizeY]);
Screen('Flip',scr.main);
Screen('Close',t_handle);

% Make black noise
black_fix_noise(:,:,1)  =   zeros(round(const.noise_size),round(const.noise_size),1)+const.background_color(1);
black_fix_noise(:,:,2)  =   zeros(round(const.noise_size),round(const.noise_size),1)+const.background_color(2);
black_fix_noise(:,:,3)  =   zeros(round(const.noise_size),round(const.noise_size),1)+const.background_color(3);
black_fix_noise(:,:,4)  =   const.fix_aperture;
tex_black_fix_noise     =   Screen('MakeTexture',scr.main,black_fix_noise);

% Make annulus
fix_ann                 =   ones(round(const.noise_size),round(const.noise_size),4);
fix_ann_no_probe(:,:,1) =   fix_ann(:,:,1)*const.ann_color(1);
fix_ann_no_probe(:,:,2) =   fix_ann(:,:,2)*const.ann_color(2);
fix_ann_no_probe(:,:,3) =   fix_ann(:,:,3)*const.ann_color(3);
fix_ann_no_probe(:,:,4) =   const.fix_annulus;
tex_fix_ann_no_probe    =   Screen('MakeTexture',scr.main,fix_ann_no_probe);

% Make annulus when probe
fix_ann_probe(:,:,1)    =   fix_ann(:,:,1)*const.ann_probe_color(1);
fix_ann_probe(:,:,2)    =   fix_ann(:,:,2)*const.ann_probe_color(2);
fix_ann_probe(:,:,3)    =   fix_ann(:,:,3)*const.ann_probe_color(3);
fix_ann_probe(:,:,4)    =   const.fix_annulus;
tex_fix_ann_probe       =   Screen('MakeTexture',scr.main,fix_ann_probe);

% Make fixation dot
fix_dot                 =   ones(round(const.noise_size),round(const.noise_size),4);
fix_dot_no_probe(:,:,1) =   fix_dot(:,:,1)*const.dot_color(1);
fix_dot_no_probe(:,:,2) =   fix_dot(:,:,2)*const.dot_color(2);
fix_dot_no_probe(:,:,3) =   fix_dot(:,:,3)*const.dot_color(3);
fix_dot_no_probe(:,:,4) =   const.fix_dot;
tex_fix_dot_no_probe    =   Screen('MakeTexture',scr.main,fix_dot_no_probe);

% Make fixation dot when probe
fix_dot_probe(:,:,1)    =   fix_dot(:,:,1)*const.dot_probe_color(1);
fix_dot_probe(:,:,2)    =   fix_dot(:,:,2)*const.dot_probe_color(2);
fix_dot_probe(:,:,3)    =   fix_dot(:,:,3)*const.dot_probe_color(3);
fix_dot_probe(:,:,4)    =   const.fix_dot_probe;
tex_fix_dot_probe       =   Screen('MakeTexture',scr.main,fix_dot_probe);

% Make noise and combine all

kappa_val_num           =   const.num_steps_kappa;
noise_rand_num          =   const.noise_num;


numPrint                =   0;
rect_noise              =   const.rect_noise;



sp_intervals = const.sp_intervals;
contrast_intervals = const.contrast_intervals;


% compute total amount of picture to print
total_amount            =   ((kappa_val_num-1) * noise_rand_num * length(sp_intervals)) + ...
                            noise_rand_num * length(sp_intervals) + ...
                            1;

textprogressbar('Progress: ');


stim_ori = 1;
for kappa_val_stim = 1:kappa_val_num
    for noise_rand = 1:noise_rand_num
        for i = 1:length(sp_intervals)
            for mc_contrast = contrast_intervals
                sp_interval = sp_intervals{i};
                low_cut = sp_interval(1);
                high_cut = sp_interval(2);
            
                % make stim texture full screen
                mat_noise = genNoisePatch(const, [low_cut, high_cut], const.noise_kappa(kappa_val_stim), mc_contrast);
                
   
                noise_patch(:,:,1)      =   mat_noise*const.stim_color(1);
                noise_patch(:,:,2)      =   mat_noise*const.stim_color(2);
                noise_patch(:,:,3)      =   mat_noise*const.stim_color(3);
                noise_patch(:,:,4)      =   const.stim_aperture;
                
                
                tex_stim                =   Screen('MakeTexture',scr.main,noise_patch);
                clear noise_patch
                
                            
                % define all texture parameters
                rects                   =   [   rect_noise,...                                                  % stim noise
                                                rect_noise,...                                                  % fix annulus
                                                rect_noise,...                                                  % empty center
                                                rect_noise];                                                    % fixation dot
    
                % rects                   =   [   rect_noise];                                                  % stim noise
    
                
                texs                    =   [   tex_stim,...                                                    % stim noise
                                                tex_fix_ann_probe,...                                           % fix anulus
                                                tex_black_fix_noise,...                                         % empty center
                                                tex_fix_dot_probe];                                             % fixation dot
                
                % texs                    =   [tex_stim];                                                   % stim noise
    
                
                angles                  =   [   const.noise_angle(stim_ori),...                                 % stim noise
                                                0,...                                                           % fix anulus
                                                0,...                                                           % empty center
                                                0];                                                             % fixation dot
                % angles                  =   [   const.noise_angle(stim_ori)];                                 % stim noise
                          
                % draw all textures
                Screen('FillRect',scr.main,const.background_color);
                Screen('DrawTextures',scr.main,texs,[],rects,0) % angle to 0 
                Screen('FillRect',scr.main,const.background_color,const.left_propixx_hide)
                Screen('FillRect',scr.main,const.background_color,const.right_propixx_hide)
                Screen('DrawingFinished',scr.main,[],1);
    
                if const.drawStimuli
                    % plot and save the sreenshot
                    Screen('Flip',scr.main);
                    screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,[],0,1);
                    
                else
                    % save the sreenshot
                    screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,'backBuffer',[],1);
                end
                screen_filename         =   sprintf('%s/probe_kappaStim%i_stimOri-%i_noiseRand%i_cutoff-%i-%i_contrast-%i_cu.mat',...
                    const.stim_folder,kappa_val_stim,stim_ori,noise_rand, low_cut, high_cut, mc_contrast);
                %save(screen_filename,'screen_stim','-v7.3','-nocompression')
                save(screen_filename,'screen_stim')
                clear screen_stim
                
                numPrint                =   numPrint+1;
                textprogressbar(numPrint*100/total_amount);
        
                % close opened texture
                Screen('Close',tex_stim);
            end
        end
    end
end

for noise_rand = 1:noise_rand_num
    for i = 1:length(sp_intervals)
        for mc_contrast = contrast_intervals
            sp_interval = sp_intervals{i};
            low_cut = sp_interval(1);
            high_cut = sp_interval(2);

            % make stim texture
            mat_noise = genNoisePatch(const, [low_cut, high_cut], const.noise_kappa(1), mc_contrast);
        
            noise_patch(:,:,1)      =   mat_noise*const.stim_color(1);
            noise_patch(:,:,2)      =   mat_noise*const.stim_color(2);
            noise_patch(:,:,3)      =   mat_noise*const.stim_color(3);
            noise_patch(:,:,4)      =   const.stim_aperture;
            bar_dir_list            =   [1,3];
        
            tex_stim                =   Screen('MakeTexture',scr.main,noise_patch);
            clear noise_patch
        
            % define all texture parameters
            rects                   =   [   rect_noise,...                                                  % stim noise
                                            rect_noise,...                                                  % fix annulus
                                            rect_noise,...                                                  % empty center
                                            rect_noise];                                                    % fixation dot
        
            texs                    =   [   tex_stim,...                                                    % stim noise
                                            tex_fix_ann_no_probe,...                                        % fix anulus
                                            tex_black_fix_noise,...                                         % empty center
                                            tex_fix_dot_no_probe];                                          % fixation dot
        
            angles                  =   [   0,...                                                           % stim noise
                                            0,...                                                           % fix anulus
                                            0,...                                                           % empty center
                                            0];                                                             % fixation dot
        
        
            % draw all textures
            Screen('FillRect',scr.main,const.background_color);
            Screen('DrawTextures',scr.main,texs,[],rects,angles)
            Screen('FillRect',scr.main,const.background_color,const.left_propixx_hide)
            Screen('FillRect',scr.main,const.background_color,const.right_propixx_hide)
            Screen('DrawingFinished',scr.main,[],1);
        
            if const.drawStimuli
                % plot save the sreenshot
                Screen('Flip',scr.main);
                screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,[],0,1);
            else
                % save the sreenshot
                screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,'backBuffer',[],1);
            end
            screen_filename         =   sprintf('%s/noprobe_noiseRand%i_cutoff-%i-%i_contrast-%i_cu.mat',...
                const.stim_folder,noise_rand, low_cut, high_cut, mc_contrast);
        
            %save(screen_filename,'screen_stim','-v7.3','-nocompression')
            save(screen_filename,'screen_stim')
            clear screen_stim
        
            numPrint                =   numPrint+1;
            textprogressbar(numPrint*100/total_amount);
        
            % close opened texture
	        Screen('Close',tex_stim);

        end
    end
end

% make inter-interval screenshot
rects                   =   [rect_noise,...                                                                         % fix annulus
                             rect_noise,...                                                                         % empty center
                             rect_noise];                                                                           % fixation dot
texs                    =   [tex_fix_ann_no_probe,...                                                               % fix annulus
                             tex_black_fix_noise,...                                                                % empty center
                             tex_fix_dot_no_probe];                                                                 % fixation dot

Screen('FillRect',scr.main,const.background_color);
Screen('DrawTextures',scr.main,texs,[],rects)
Screen('FillRect',scr.main,const.background_color,const.left_propixx_hide)
Screen('FillRect',scr.main,const.background_color,const.right_propixx_hide)
Screen('DrawingFinished',scr.main,[],1);

if const.drawStimuli
    % plot and save the screenshot
	Screen('Flip',scr.main);
	screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,[],0,1);
else
    % save the sreenshot
    screen_stim             =   Screen('GetImage', scr.main,const.stim_rect,'backBuffer',[],1);
end
screen_filename         =   sprintf('%s/blank.mat',const.stim_folder);
%save(screen_filename,'screen_stim','-v7.3','-nocompression')
save(screen_filename,'screen_stim')
clear screen_stim

numPrint                =   numPrint+1;
textprogressbar(numPrint*100/total_amount);
textprogressbar(numPrint*100/total_amount);

% Close all textures
Screen('Close',tex_black_fix_noise);
Screen('Close',tex_fix_ann_probe);
Screen('Close',tex_fix_ann_no_probe);
Screen('Close',tex_fix_dot_no_probe);
Screen('Close',tex_fix_dot_probe);

end