function [Image,time] = RobustDeblur( Blur, blurLevel)
%% Main interface for image debluring
% INPUT
%    Blur              (matrix) Blur image(rgb)
%    blurLevel         (scalar) show the kernel:1-17, 2-31, 3-51
% OUTPUt
%    Image             (matrix) restored image
% AUTHOR
%   Luo Zhijian, Sept, 26, 2013

%%
    Blur_gray = rgb2gray(Blur);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % kernel size
    ks = cell(3,1);
    ks{1} = [1,2,3,4,6,9,12];
    ks{2} = [1,2,3,4,6,9,12,17];
    ks{3} = [1,2,3,4,6,9,12,17,25];
    
    iterations =[15,20,30]; 

    tStart = tic;
    
    [ kernel ,Blur_x, Blur_y, edgeImg_x, edgeImg_y ] = KernelInitial(...
        Blur_gray, ks{blurLevel},iterations(blurLevel));
    
    kernel = KernelRefine(kernel,Blur_x, Blur_y, edgeImg_x, edgeImg_y);
    
    save('kernel.mat','kernel');
    
    Image = FastDeconvolution(Blur, kernel);
    
    time = toc(tStart);
end

