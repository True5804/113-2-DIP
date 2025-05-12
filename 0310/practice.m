clc;
clear all;
close all;

I = imread('a.jpeg');
%figure; imshow(I); title('Original Pic');

% 提取並顯示各色彩通道
redChannel = I(:,:,1);
greenChannel = I(:,:,2);
blueChannel = I(:,:,3);

% 創建只有紅色通道的RGB圖像
blueOnly = zeros(size(I), 'uint8');
blueOnly(:,:,1) = blueChannel; % 只填充紅色通道

% 針對紅色通道偏暗的問題進行增強
enhancedBlue = imadjust(blueChannel, [0 1], [0.2 1]); % 增強紅色通道

% 創建增強後的彩色圖像
enhancedImg = I;
enhancedImg(:,:,1) = enhancedBlue; % 替換為增強後的紅色通道

% 顯示增強效果
figure;
subplot(1,3,1); imshow(I); title('原始圖像');
subplot(1,3,2); imshow(blueOnly); title('紅色通道');
subplot(1,3,3); imshow(enhancedBlue); title('紅色通道增強後');


