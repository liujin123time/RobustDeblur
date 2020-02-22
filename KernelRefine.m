function [ kernelRefined ] = KernelRefine( K ,Blur_x, Blur_y, edgeImg_x, edgeImg_y)
%% Refine the kernel estimate by phase one, by Iterative Support Detection
% INPUT
%    kernel            (matrix) the motion kernel estimated by Eq.6
% OUTPUt
%   kernelRefined      (matrix) the kernel refined by iterative Support Detectiion
% AUTHOR
%   Luo Zhijian, June, 18, 2013

%%
    kernelSize = size(K,1);
    
    fft_AtAx = abs(fft2(edgeImg_x)).^2;
    fft_AtAy = abs(fft2(edgeImg_y)).^2;
    fft_AtBx = conj(fft2(edgeImg_x)).*fft2(Blur_x);
    fft_AtBy = conj(fft2(edgeImg_y)).*fft2(Blur_y);
    f = fft_AtBx + fft_AtBy;
    A0 = fft_AtAx + fft_AtAy;
    I = eye(kernelSize,kernelSize);
    [m,n] = size(Blur_x);
    I(m,n) = 0;
    
    % Initialization Parameters
    round = 1;
    epsilon_k = 1e-3; 
    gamma = 1;
    
    % Initialization the loop
    currentK = K(:);
    currentK = abs(currentK);
    V_SC = support_detection(currentK, round, kernelSize);
    V_S = double(V_SC == 0);    
    Support = reshape(V_SC,kernelSize,kernelSize);
    
    currentK = currentK .* V_S;
    
    %% iterative reweighted least square
    while (1)
        preK = currentK;
        Phi = max(1e-5 , norm(preK,1));
        
        A = A0 + gamma * (fft2(Support,m,n)).*ifft2(I) / Phi;
        fft_k = f ./ A;
        K = otf2psf(fft_k,[kernelSize,kernelSize]);
        K(K < 0) = 0;
        ksum = sum(K(:));
        K = K./ksum;
        currentK = K(:);
        
        round = round + 1;
        V_SC = support_detection(currentK, round,kernelSize);
        Support = reshape(V_SC,kernelSize,kernelSize);        
        V_S = double(V_SC==0);
        
        currentK = currentK .* V_S;
        
        condition = norm(currentK - preK , 'fro') / norm(preK, 'fro');
        if (condition <= epsilon_k)
            break;
        end
    end
    %%
    s = sum(currentK);
    currentK = currentK ./ s;
    kernelRefined = reshape(currentK, kernelSize,kernelSize);
    end