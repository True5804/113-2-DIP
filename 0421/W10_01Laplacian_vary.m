%觀察數值
clc; clear all; close all;
image = imread('smooth_image.png');
image_gray = double(image);
disp(['Original', class(image_gray)]);
disp(['Original Range from', num2str(double(min(image_gray(:)))), ' to ', num2str(double(max(image_gray(:))))]);
% 拉普拉斯濾波器
laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];
%uint8
laplacian_image = imfilter(image_gray, laplacian_filter, 'replicate');
% check laplacian range
disp(['Laplacian', class(laplacian_image)]);
disp(['Laplacian range from ', num2str(double(min(laplacian_image(:)))), ' to ', num2str(double(max(laplacian_image(:))))]);
%method 1 under uint8
lambda = 0.5;
sharpened_uint8 = uint8(double(image_gray) - lambda * double(laplacian_image));
% method 2 using double
image_gray_double = im2double(image_gray);
laplacian_double = imfilter(image_gray_double, laplacian_filter, 'replicate');
disp(['Transfer to double ', num2str(min(laplacian_double(:))), ' to ', num2str(max(laplacian_double(:)))]);
lambda_double = 0.5;
sharpened_double = image_gray_double - lambda_double * laplacian_double;
% 確保像素值在有效範圍內
sharpened_double = min(max(sharpened_double, 0), 1);
% 顯示結果
figure;
subplot(2,2,1), imshow(image), title('Original');
subplot(2,2,2), imshow(laplacian_image, []), title('Lap');
subplot(2,2,3), imshow(sharpened_uint8), title(['uint8 λ = ', num2str(lambda)]);
subplot(2,2,4), imshow(sharpened_double), title(['double λ = ', num2str(lambda_double)]);