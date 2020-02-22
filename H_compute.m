function [H, tau_s] = H_compute(I_x,I_y,M,i,tau_s,kSize)
%% Compute the rmap and tao_r
% INPUT
%    I_x               (matrix) the vertical gradient of image I
%    I_y               (matrix) the horizen gradient of image I
%    M                 (matrix) the rMap of Image
%    tau_s             (scalar) the threshoding of rMap
%    kSize             (scalar) the size of kernel
% OUTPUt
%    H                 (matrix) the gradient confidence map
%    tau_s             (scalar) the threshoding of gradient confidence
% AUTHOR
%   Luo Zhijian, June, 15, 2013
%%
    if i == 1
        tau_s = InitialTao_s(I_x,I_y,M,kSize);
    end
    Norm = sqrt(I_x.^2 + I_y.^2);
    Tmp = Norm .* M;
    
    H = double(Tmp >= tau_s);
    tau_s = tau_s / 1.1;
end
%%