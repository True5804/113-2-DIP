clc;
clear all;
close all;
img = imread('old2.jpg');
img_double = im2double(img);

% 計算第5百分位和第95百分位
sorted_pixels = sort(img_double(:));
num_pixels = numel(sorted_pixels);
low_idx = round(0.05 * num_pixels);
high_idx = round(0.95 * num_pixels);
low_val = sorted_pixels(low_idx);
high_val = sorted_pixels(high_idx);

% 應用百分位拉伸
stretched_img = img_double;
stretched_img(img_double < low_val) = 0;
stretched_img(img_double > high_val) = 1;

% 線性映射中間區域
mask = (img_double >= low_val) & (img_double <= high_val);
stretched_img(mask) = (img_double(mask) - low_val) / (high_val - low_val);

% 顯示結果
figure;
subplot(1,2,1), imshow(img_double), title('原始影像');
subplot(1,2,2), imshow(stretched_img), title('百分位對比度拉伸');