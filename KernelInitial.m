function [ kernel ,blur_x, blur_y, Is_x, Is_y ] = KernelInitial( Blur ,ks, iteration)
%% Initialize the kernel at the phase one
% INPUT
%    Blur              (matrix) the Burry image(gray)
%    ks                (vector) the size of each level
%    iteration         (scalar) the iteration
% OUTPUt
%    kernel            (matrix) the kernel
%    blur_x            (matrix) gradient in vertical of blury image
%    blur_y            (matrix) gradient in horizon of blury image
%    Is_x              (matrix) gradient in vertical of edge-sharped image
%    Is_y              (matrix) gradient in horizon of edge-sharped image
% AUTHOR
%   Luo Zhijian, June, 15, 2013

%%
    % Parameters Initialization
    gamma = 10;
    lambda = 2e-3;
    sigma = 0.2;
    tau_r = 0;
    tau_s = 0;
    
    levels = length(ks);
    ratio = ones(levels,1);
    for i = levels-1:-1:1
        ratio(i) = ratio(i+1)*sqrt(2);
    end

    Img = Blur;
    OrgSize = size(Blur);
    
    for i = 1:levels
        %% Imresize for multi-scale computing
        blur = imresize(Blur,1/ratio(i),'bilinear');
        Img = imresize(Img,1/ratio(i),'bilinear');
        
        %%Image expanding
        kSize = 2*ks(i)+1;
        blur = padarray(blur,[1 1]*ks(i),'replicate','both'); 
        kernel_gaus = fspecial('gaussian',kSize,sigma);
        for j = 1:3
            blur = edgetaper(blur,kernel_gaus);
        end

        [blur_x,blur_y] = ForwardGradient(blur);
        gradConf = GradientConf(blur_x,blur_y,kSize);
        
        for j = 1:iteration
            Img = padarray(Img,[1 1]*ks(i),'replicate','both');
            for k = 1:3
                Img = edgetaper(Img,kernel_gaus);
            end
            Img = bilateral_filter(Img);
            Ish = shock_filter(Img);
            [Ish_x,Ish_y] = ForwardGradient(Ish);
            
            %%M = Heaviside(rmap-tau_r)
            [M, tau_r] = M_compute(Ish_x,Ish_y,gradConf,j,tau_r,kSize);
            %%H = Heaviside(M.*||I_sh||_2 - tau_s)
            [H, tau_s] = H_compute(Ish_x,Ish_y,M,j,tau_s,kSize);
            
            Is_x = Ish_x .* H;
            Is_y = Ish_y .* H;
            
            [kernel, Img] = kernel_coarse_est(Is_x,Is_y,blur_x,blur_y,blur,kSize,lambda,gamma);
            
            [m,n] = size(Ish);
            Img = Img(ks(i)+1:m-ks(i),ks(i)+1:n-ks(i));
        end
        
        if i< levels
            Img = imresize(Img,OrgSize,'bilinear');
        end
    end
    blur_x = blur_x(ks(levels)+1:m-ks(levels),ks(levels)+1:n-ks(levels));
    blur_y = blur_y(ks(levels)+1:m-ks(levels),ks(levels)+1:n-ks(levels));
    Is_x = Is_x(ks(levels)+1:m-ks(levels),ks(levels)+1:n-ks(levels));
    Is_y = Is_y(ks(levels)+1:m-ks(levels),ks(levels)+1:n-ks(levels));
end