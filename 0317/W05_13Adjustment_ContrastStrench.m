% 自適應的對比度拉伸 
clc;
clear all;

img = imread('old2.jpg');
img_double = im2double(img);

% 首先進行對比度拉伸
min_val = min(img_double(:));
max_val = max(img_double(:));
stretched_img = (img_double - min_val) / (max_val - min_val);

% 步驟2：伽瑪校正，增強中間調
gamma = 0.6;
gamma_corrected = stretched_img.^gamma;


% 顯示結果
figure;
subplot(1,3,1), imshow(img_double), title('原始影像');
subplot(1,3,2), imshow(stretched_img), title('對比度拉伸');
subplot(1,3,3), imshow(gamma_corrected), title('拉伸+Power Law變換');