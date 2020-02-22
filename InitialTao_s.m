function [ tao_s ] = InitialTao_s( I_x, I_y, Mask, kernelSize )
%% Initial the Parameter tao_r
% INPUT
%    kernelSize        (scalar) the size of kernel(m by m) m
%    Mask              (matrix) Mask
%    Image             (matrix) the constant parameter
% OUTPUt
%    tao_s             (scalar) the parameter tao_s
% AUTHOR
%   Luo Zhijian, June, 15, 2013
%%
    num = 2 * kernelSize;
    
    tan = I_y ./ I_x;
    Norm = sqrt(I_x.^2 + I_y.^2);
    Mask = Mask .* Norm;
    
    s = zeros(4,1);
    
    Mask1 = Mask(tan >= 0 & tan <= 1);     Mask1 = Mask1(:);
    array = sort(Mask1,'descend');  s(1) = array(num);
    
    Mask2 = Mask(tan > 1);                 Mask2 = Mask2(:);
    array = sort(Mask2,'descend');  s(2) = array(num);
    
    Mask3 = Mask(tan < -1);                Mask3 = Mask3(:);
    array = sort(Mask3,'descend');  s(3) = array(num);
    
    Mask4 = Mask(tan <= 0 & tan >= -1);    Mask4 = Mask4(:);
    array = sort(Mask4,'descend');  s(4) = array(num);
    
    tao_s = min(s);
end

