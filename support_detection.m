function V_SC = support_detection(V_k, round, kernelSize)
%% Generate the spatial Support using "first significant jump"
% INPUT
%    V_k               (vector) the vector form of kernel(positive)
%    round             (scalar) the iteratation number
%    kernelSize        (scalar) the size of kernel
% OUTPUt
%    V_SC              (vector) the gradient support of small-valur element
% AUTHOR
%   Luo Zhijian, June, 18, 2013
%%
    kernelOrder = sort(V_k,'ascend');
    kerdiff = diff(kernelOrder);
    kerMax = max(V_k);
    threshod = kerMax / (2 * kernelSize * round);
    ind = kerdiff > threshod;
    if any(ind)
        pos = find(ind,1,'first');
        epsilon = kernelOrder(pos+1);
    else
        epsilon = kernelOrder(1);
    end
    V_SC = double(V_k <= epsilon);
end