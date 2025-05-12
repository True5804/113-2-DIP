% make the color of RGB picture mapping to gray, HSV
% adjust uint16 -> uint64, uint8 -> uint 16
close all;
clear all;
clc; %clean up command

I = imread("flowers.jpg");
figure;
subplot(1,3,1);
imshow(I);
title("RGB");

%% Transfer this data format from uint 8 -> uint 16
% I16 = uint16(I);
% subplot(1,2,2);
% imshow(I16);

% mapping RGB color to grayscale
Gray = rgb2gray(I);
subplot(1,3,2);
imshow(Gray);
title("Gray");

% mapping HSV
HSV = rgb2hsv(I);
subplot(1,3,3);
imshow(HSV);
title("HSV");