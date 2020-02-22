function [ Blur ] = FastDeconvolution( Blur, kernel )
%% Deconvolve three color channels independdently using TV-l1 model and 
%  Alternating Minimization Method.
%
% INPUT
%    Blur              (matrix) gradient in vertical of the Burry Gray image
%    kernel            (matrix) the motion kernel estimated by Kernel Estimation
% OUTPUt
%    Blur              (matrix) the Image restored by TV-l1 deconvolution
% AUTHOR
%   Luo Zhijian, Aug, 21, 2013

%% 
    % Parameter Initialization
    lambda = 2e-2;
    beta0 = 1;
    theta0 = 1 / lambda;
    beta_min = 0.01;
    theta_min = 0.01;
    
    % Edge taping
    Blur = edgetaper(Blur,kernel);
    
    dimColor = size(Blur,3);
    C = getC(Blur(:,:,1), kernel);
    
    for c = 1:dimColor
        beta = beta0;
        Img = Blur(:,:,c);
        
        % Main loop
        while(1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Solve for v using Eq.(18);
            DataReg = real(ifft2(C.K .* fft2(Img))) - Blur(:,:,c);
            v = max(abs(DataReg) - beta , 0).*sign(DataReg);
            Bv = Blur(:,:,c) + v;
            clear DataReg;
            clear v;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            theta = theta0;
            while(1)               
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Solve for w using Eq.(17)
                [Dx, Dy] = ForwardGradient(Img);
                V = sqrt(Dx.^2 +Dy.^2);
                V(V==0) = 1;
                
                % ====================================
                %      Shrinkage Step for w
                % ====================================
                V = max(V - theta*lambda , 0) ./V;
                wx = Dx .* V;
                wy = Dy .* V;
                clear Dx;
                clear Dy;
                clear V;
                % End Solve for w using Eq.(17)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Solve for I in the frequency domain using Eq.(15)
                Denom = theta .* C.KtK + beta .* C.DtD;
                Nomin = theta .* C.Kt .* fft2(Bv) +...
                    beta .*(C.Dxt .* fft2(wx) + C.Dyt .* fft2(wy));
                Img = Nomin ./ Denom;
                Img = real(ifft2(Img));
                % End Solve for I in the frequency domain using Eq.(15)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                theta = theta / 5;
                if theta < theta_min
                    break;
                end
            end
            beta = beta / 5;
            if beta < beta_min
                break;
            end
        end
        Blur(:,:,c) = Img;
    end
end

%% ---------------------SUBFUNCTION-------------------------------------
function C = getC(F, H)
    [m,n] = size(F);
    C.Dx = psf2otf([1,-1],[m,n]); C.Dxt = conj(C.Dx);
    C.Dy = psf2otf([1;-1],[m,n]); C.Dyt = conj(C.Dy);
    C.DtD = abs(psf2otf([1,-1],[m,n])).^2 + abs(psf2otf([1;-1],[m,n])).^2;
    C.K = psf2otf(H,[m,n]);
    C.Kt = conj(C.K);
    C.KtK = abs(C.K).^2;
end