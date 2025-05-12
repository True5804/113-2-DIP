clc;
clear all;
close all;

dark = imread('pout.tif');
bright = 255-dark; % 利用反轉的效果來獲得比較亮的圖片 
% imadjust 
low_contrast = imadjust(dark,[0.2 0.8],[0.2 0.8]);
high_contrast = imadjust(dark,[0.2 0.8],[0 1]);

figure;
subplot(1,2,1); imshow(dark); title('暗圖像');
subplot(1,2,2); imhist(dark); title('暗圖像直方圖');
figure;
subplot(1,2,1); imshow(bright); title('亮圖像');
subplot(1,2,2); imhist(bright); title('亮圖像直方圖');
figure;
subplot(1,2,1); imshow(low_contrast); title('低對比度');
subplot(1,2,2); imhist(low_contrast); title('低對比度直方圖');
figure;
subplot(1,2,1); imshow(high_contrast); title('高對比度');
subplot(1,2,2); imhist(high_contrast); title('高對比度直方圖');
