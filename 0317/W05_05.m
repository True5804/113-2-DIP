%point contrast
clc;
clear All;
close All;

%read original image
original_image = imread('orange.jpg');

contrast = 1.5

img_double = double(original_image);
enhanced_img = img_double *contrast;

% overflow
enhanced_img = uint8(min(255, max(0, enhanced_img)));

% 顯示結果
figure;
subplot(1,2,1), imshow(original_image), title('原圖');
subplot(1,2,2), imshow(colored_output), title('調整contrast');