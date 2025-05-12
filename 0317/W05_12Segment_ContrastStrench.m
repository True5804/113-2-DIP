% 分段線性對比度拉伸
clc;
clear all;

img = imread('old2.jpg');
img_double = im2double(img);

% 定義分段線性變換的參數
r1 = 0.2;  % 輸入下限
r2 = 0.6;  % 輸入上限
s1 = 0.0;  % 輸出下限
s2 = 1.0;  % 輸出上限

% 利用contrast strench
stretched_img = img_double;
stretched_img(img_double<r1) = s1; 
stretched_img(img_double>r2) = s2;
% 線性映射中間區域 
mask = (img_double>= r1) &(img_double<=r2);
stretched_img(mask)=(img_double(mask)-r1)*(s2-s1)/(r2-r1) + s1;

% 顯示結果
figure;
subplot(1,2,1), imshow(img_double), title('原始影像');
subplot(1,2,2), imshow(stretched_img), title('分段線性對比度拉伸');