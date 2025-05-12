% Sobel 
clear all; close all; clc;
img = imread('smooth_image.png');
img = double(img);
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
gradient_x = imfilter(img, sobel_x, 'replicate'); % 水平梯度
gradient_y = imfilter(img, sobel_y, 'replicate'); % 垂直梯度
gradient_magnitude = sqrt(gradient_x.^2 + gradient_y.^2);
%normalization
gradient_magnitude = gradient_magnitude / max(gradient_magnitude(:)) * 255;
gradient_direction = atan2(gradient_y, gradient_x);
subplot(1, 4, 1);
imshow(uint8(img));
title('Original');
subplot(1, 4, 2);
imshow(uint8(abs(gradient_x)));
title('水平梯度 (Sobel_x)');
subplot(1, 4, 3);
imshow(uint8(abs(gradient_y)));
title('垂直梯度 (Sobel_y)');
subplot(1, 4, 4);
imshow(uint8(gradient_magnitude));
title('Gradient');
%
figure('Name', 'Sobel enforcement result');
threshold = 40;  
binary_edge = gradient_magnitude > threshold;
binary_edge = imdilate(binary_edge, strel('disk', 1));
%將照片 edge 疊加回圖片中
alpha = 0.3;
normalized_gradient = gradient_magnitude / max(gradient_magnitude(:));
enhanced_direct = img + alpha * img .* normalized_gradient;
enhanced_direct = max(0, min(255, enhanced_direct));
subplot(2, 2, 1);
imshow(uint8(img));
title('Original');
subplot(2, 2, 2);
imshow(uint8(enhanced_direct));
title('Sobel');