% 2025/03/03 DIP Homework

clear all; % clean all memory
close all; % close all opened figures

RGB=imread("handwrite03.jpg");
figure;
subplot(1,2,1);
imshow(RGB);
title('Original');

% mapping RGB color to grayscale
Gray = rgb2gray(RGB);
rgb_adjusted = imadjust(Gray, stretchlim(Gray, [0.02, 0.85]), []);
black_img = im2bw(rgb_adjusted, 0.5);

subplot(1,2,2);
imshow(black_img);
title("Adjusted");

% write images into another new file
imwrite(black_img, 'S11159020_03.jpg');