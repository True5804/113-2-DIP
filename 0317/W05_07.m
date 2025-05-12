%% Affine rotate / change angle
clc;
clear all;
close all;
% 讀取原始影像
original_image = imread('flower.jpg');
% 定義旋轉角度(弧度)
theta = 45 * (pi/180); % 45度旋轉
% 旋轉矩陣
cos_theta = cos(theta);
sin_theta = sin(theta);
% tform = affine2d([1 0 0; 0 1 0; tx ty 1]);
tform = affine2d([cos_theta -sin_theta 0; sin_theta cos_theta 0; 0 0 1]);
% 應用變換
outputImg = imwarp(original_image, tform);
% 顯示結果
figure;
subplot(1,2,1), imshow(original_image), title('原始影像');
subplot(1,2,2), imshow(outputImg), title('旋轉後影像');