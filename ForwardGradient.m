function [ Dux, Duy ] = ForwardGradient( U )
%% Compute the gradient Of U
% INPUT
%    U                 (matrix) the matrix U
% OUTPUt
%    Dux               (matrix) horizonal difference of U
%    Duy               (matrix) vertical difference of U
% AUTHOR
%   Luo Zhijian, Aug, 28, 2013

%%
    Dux = [diff(U,1,2), U(:,1) - U(:,end)];
    Duy = [diff(U,1,1); U(1,:) - U(end,:)];
end
