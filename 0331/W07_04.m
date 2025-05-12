%Noise generater
clc;
clear all;
close all;
% 讀取影像
I = imread('lenna.jpeg');
% 顯示原始圖片
figure;
subplot(2, 3, 1);
imshow(I);
title('原始圖片');
% 添加高斯噪聲
I_gaussian_noise = imnoise(I, 'gaussian', 0, 0.01);
subplot(2, 3, 2);
imshow(I_gaussian_noise);
title('添加高斯噪聲');
% 添加椒鹽噪聲 (Salt & Pepper)
I_salt_pepper = imnoise(I, 'salt & pepper', 0.05);
subplot(2, 3, 3);
imshow(I_salt_pepper);
title('添加椒鹽噪聲');

% Denoising
kernel_size = 3;
kernel = ones(kernel_size) / (kernel_size^2);
% mean filter to GAUSSIAN NOISE
I_double = double(I_gaussian_noise);
I_mean_filter_gaussian = conv2(I_double, kernel, 'same');
I_mean_filter_gaussian = uint8(I_mean_filter_gaussian);
subplot(2, 3, 5);
imshow(I_mean_filter_gaussian);
title('高斯噪聲均值濾波結果');
% TO pepper and salt noise
I_double = double(I_salt_pepper);
I_mean_filter_salt_pepper = conv2(I_double, kernel, 'same');
I_mean_filter_salt_pepper = uint8(I_mean_filter_salt_pepper);
subplot(2, 3, 6);
imshow(I_mean_filter_salt_pepper);
title('P&S噪聲均值濾波結果');
% try different kernel
figure;
window_sizes = [3, 5, 7, 9];
for i = 1:length(window_sizes)
    ws = window_sizes(i);
    kernel = ones(ws) / (ws^2);
    
    I_double = double(I_gaussian_noise);
    filtered = conv2(I_double, kernel, 'same');
    filtered = uint8(filtered);
    
    subplot(2, 2, i);
    imshow(filtered);
    title(sprintf('%dx%d 均值濾波器', ws, ws));
end
figure;
subplot(2, 2, 1);
imshow(I);
title('原始圖片');
subplot(2, 2, 2);
imshow(I_salt_pepper);
title('椒鹽噪聲');
subplot(2, 2, 3);
imshow(I_mean_filter_salt_pepper);
title('均值濾波');
% 使用中值濾波處理椒鹽噪聲
I_median_filter = medfilt2(I_salt_pepper, [3 3]);
subplot(2, 2, 4);
imshow(I_median_filter);
title('中值濾波');