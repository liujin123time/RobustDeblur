function [ tao_r ] = InitialTao_r(I_x, I_y, gradConf, kSize)
%% Initial the Parameter tao_r
% INPUT
%    imgSize           (matrix) The size of image(m by n)m*n
%    kernelSize        (scalar) the size of kernel(k by k)
%    gradConf          (matrix) The Gradient Confidence defined in Selective Shape edge
%    Image             (matrix) the constant parameter
% OUTPUt
%    tao_r             (scalar) the parameter tao_r
% AUTHOR
%   Luo Zhijian, June, 15, 2013
%%
    [r,c] = size(I_x);
    num =  uint16(sqrt(r * c * kSize * kSize) / 2);
    tan = I_y ./ I_x;
    
    r = zeros(4,1);
    
    r1 = gradConf(tan >= 0 & tan <= 1);
    r1 = r1(:);
    array = sort(r1,'descend');  
    r(1) = array(num);
    
    r2 = gradConf (tan > 1); 
    r2 = r2(:);
    array = sort(r2,'descend');  r(2) = array(num);
    
    r3 = gradConf(tan < -1);
    r3 = r3(:);
    array = sort(r3,'descend');  r(3) = array(num);
    
    r4 = gradConf(tan <= 0 & tan >= -1); 
    r4 = r4(:);
    array = sort(r4,'descend');  r(4) = array(num);
    
    tao_r = min(r);
end

