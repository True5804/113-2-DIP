%% Power law transformation
clc;
clear all;
close all;
% 讀取原始影像
original_image = imread('HDR_Banff.jpeg');
if size(original_image,3) ==3
    % color image
    img_double = im2double(original_image);
else
    % gray image
    img_double = im2double(original_image);
end
% give different gamma value
gamma_value = [0.3, 0.6, 1.1,1.4,2.7];
n = length(gamma_value);
figure;
subplot(1,n+1,1), imshow(img_double), title('原始影像');
% 根據 gamma value 自動產生每一個不同的 value 的圖片
for i =1:n
    gamma =gamma_value(i);
    corrected_img = img_double.^gamma;
    % show the pic    
    subplot(1,n+1,i+1), imshow(corrected_img), title(['\gamma=', num2str(gamma)]);
end