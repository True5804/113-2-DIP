clc;
clear All;
close All;

%read original image
original_image = imread('orange.jpg');

% 如果是彩色影像，先轉為灰度
if size(original_image, 3) == 3
    gray_image = rgb2gray(original_image);
else
    gray_image = original_image;
end
% 設定 threshold
threshold = 180;

binary_image = gray_image >= threshold  % 128-255 
% 顯示結果
figure;
subplot(1,3,1), imshow(original_image), title('原始影像');
subplot(1,3,2), imshow(gray_image), title('灰階影像');
subplot(1,3,3), imshow(binary_image), title('閥值效果');