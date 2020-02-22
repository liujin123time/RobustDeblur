function [ Out ] = SizeAdjust( In )
%% Description

%%
    [r,c,~] = size(In);
    r = max(r,c);
    if r > 800
        if r > c
            Out = imresize(In,800/r);
        else
            Out = imresize(In,800/c);
        end
    else
        Out = In;
    end
end