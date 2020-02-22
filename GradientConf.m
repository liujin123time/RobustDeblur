function gradConf = GradientConf(Bx, By, maskSize)
%% Compute the gradient confidence r for all pixels (Eq.(2))
% INPUT
%    Blur              (matrix) the Burry image(gray)
%    maskSize          (scalar) the size of kernel(m by m) m is odd.
% OUTPUt
%    gradConf          (matrix) the gradient confidence r
% AUTHOR
%   Luo Zhijian, June, 15, 2013
%%    
    Mask = ones(maskSize);
    NormB = sqrt(Bx.^2 + By.^2);
    
    Bx_conv = conv2(Bx, Mask, 'same');
    By_conv = conv2(By, Mask, 'same');
    Numerator = sqrt(Bx_conv.^2 + By_conv.^2);
    
    Denominator = conv2(NormB,Mask,'same') + 0.5;
    
    gradConf = Numerator ./ Denominator;
end
