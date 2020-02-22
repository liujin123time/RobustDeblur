function[kernel,Img] = kernel_coarse_est(Is_x,Ix_y,blur_x,blur_y,blur,kSize,lambda,gamma)
%% Estimate the laten image I^l with the spatial prior (Eq.8)
%    and Estimate kernel with the Gaussian prior (Eq.6)
% INPUT
%    Is_x              (matrix) gradient in vertical of edge-sharped image
%    Is_y              (matrix) gradient in horizen of edge-sharped image
%    blur_x            (matrix) gradient in vertical of Blur Image
%    blur_y            (matrix) gradient in horizen of Blur Image
%    blur              (matrix) the blury image
%    gamma             (scalar) the constant parameter
%    lambda            (scalar) the constant parameter
% OUTPUt
%   img                (matrix) the image estiamted with spatial prior
% AUTHOR
%   Luo Zhijian, Aug, 06, 2013

%%
    [xim,yim]=size(blur);
    F1 = [-1,1];
    F2 = [-1;1];
    
    FFtIsh_x = fft2(Is_x);
    FFtIsh_y = fft2(Ix_y);
    FFtIm_x = fft2(blur_x);
    FFtIm_y = fft2(blur_y);
    FFtF1 = psf2otf(F1,[xim,yim]);
    FFtF2 = psf2otf(F2,[xim,yim]);
    FFtIm = fft2(blur);

    Nomin = conj(FFtIsh_x).*FFtIm_x+conj(FFtIsh_y).*FFtIm_y;
    Denom = conj(FFtIsh_x).*FFtIsh_x+conj(FFtIsh_y).*FFtIsh_y+gamma;
    FFtk = (Nomin./Denom);
    kernel = otf2psf(FFtk,[kSize,kSize]);
    kernel(kernel < 0) = 0;
    ksum = sum(kernel(:));
    kernel = kernel./ksum;

    FFtk = psf2otf(kernel,[xim,yim]);
    Nomin = conj(FFtk).*FFtIm+lambda*(conj(FFtF1).*FFtIsh_x+conj(FFtF2).*FFtIsh_y);
    Denom = conj(FFtk).*FFtk+lambda*(conj(FFtF1).*FFtF1+conj(FFtF2).*FFtF2);
    Img = real(ifft2(Nomin./Denom));

end