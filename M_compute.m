function [M , tau_r] = M_compute(I_x,I_y,r,i,tau_r,kSize)
%% Compute the rmap and tao_r
% INPUT
%    I_x               (matrix) the vertical gradient of image I
%    I_y               (matrix) the horizen gradient of image I
%    r                 (matrix) the gradient confidence of Image
%    tau_r             (scalar) the threshoding of gradient confidence
%    kSize             (scalar) the size of kernel
% OUTPUt
%    M                 (matrix) the gradient confidence map
%    tau_r             (scalar) the threshoding of gradient confidence
% AUTHOR
%   Luo Zhijian, June, 15, 2013
%%
    if i == 1
        tau_r = InitialTao_r(I_x, I_y, r, kSize);
    end
    M = double(r >= tau_r);
    tau_r = tau_r / 1.1;
end

