close all;
clear; 
clc;

blurPath = input('Please Input the path of Blurry image:\n','s');
fprintf('\n');

blur_level = input('Please Input the blurry level--1:small, 2:medium(default), 3:large\n');
fprintf('\n');
if isempty(blur_level)
    blur_level = 2;
end
if blur_level ~= 1 && blur_level ~=2 && blur_level~=3
    blur_level = 2;
end

isResize = input('Image need to be resized? 1:resize(default) 0:not resize\n');
fprintf('\n');
if isempty(isResize)
    isResize = 1;
end
if isResize~=0 && isResize~=1
    isResize = 1;
end
Blur = im2double(imread(blurPath));
[Image, time] = deblur_main(blurPath,blur_level, isResize);

figure;
imshow(Blur);
title('Blur image');

figure;
imshow(Image);
title(sprintf('Restored image, deblur time=%.2f second',time));