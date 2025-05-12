% 將 RGB 圖像或顏色 mapping to gray, HSV
% adjust uint16 -> uint 64, uint 8 ->16~
close all;
clear all;
clc;

RGB = imread("flowers.jpg");
Gray = rgb2gray(RGB);
BW = im2bw(Gray);
BW3 = im2bw(Gray, 0.3);
BW7 = im2bw(RGB, 0.7);
rgb_adjusted = imadjust(RGB, [0.8 0.99], []);


figure;
subplot(1,4,1), imshow(RGB), title('Original');
% subplot(1,4,2), imshow(Gray), title('Gray');
% subplot(1,4,3), imshow(rgb_adjusted), title('Adjusted');
subplot(1,4,4), imshow(BW7), title('B&W0.7');

subplot(1,4,2), imshow(BW), title('B&W');
subplot(1,4,3), imshow(BW3), title('B&W0.3');