%% Power law with auto adjustment
clc;
clear all;
close all;
% 讀取原始影像
original_image = imread('flower.jpg');
img_double = im2double(original_image);
% count average bright
mean_intensity = mean(img_double(:));
% 根據 mean_intensity 自動的調整 gamma value
% 圖片本身很暗 -> 較小的 gamma value
if mean_intensity <0.4
    gamma =0.35; %調亮
elseif mean_intensity >0.7
    gamma =1.5; %增強過量的影像對比度
else
    gamma = 1;
end
corrected_img = img_double.^gamma;
% 顯示結果
figure;
subplot(1,2,1), imshow(original_image), title('原始影像');
%subplot(1,2,2), imshow(corrected_img), title('自動校正');
subplot(1,2,2), imshow(corrected_img), title(['自動校正 \gamma=', num2str(gamma)]);