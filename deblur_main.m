function [Img, time] =  deblur_main( fileName, blurLevel, isResize )
%% The program interface for user
% INPUT
%    fileName          (string) the filename of blurry image 
%    blurLevel         (scalar) the blurry level 1:small, 2:medium(default), 3:large 
%    isResize          (scalar) whether to do resize. 1:resize, 0:no resize
% OUTPUt
%    Img               (matrix) the laten image resotred by our algorithm.
% AUTHOR
%   Luo Zhijian, Nov, 10, 2013

%%
    if ~exist('blurLevel','var')
        blurLevel = 2;
    end
    if ~exist('isResize','var')
        isResize = 1;
    end
    
    [pathstr, name, ext] = fileparts(fileName);
    
    Blur = im2double(imread(fileName));
    if isResize == 1
        Blur = SizeAdjust(Blur);
    end
    
    [Img, time] = RobustDeblur(Blur,blurLevel);
    imwrite(Img,sprintf('%s\\deblur_%s%s',pathstr,name,ext));
end

