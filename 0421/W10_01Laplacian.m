clc;
clear all;
close all;

image = imread('lenna 1.jpeg');
lap_filter = [0 1 0; 1 -4 1; 0 1 0];

lap_image = imfilter(image, lap_filter, 'replicate');

%lambda
lambda = 0.5;
% 銳化
sharp_image = image - lambda*lap_image;
figure;
subplot(1,3,1), imshow(image), title('Original');
subplot(1,3,2), imshow(lap_image), title('Laplician');
subplot(1,3,3), imshow(sharp_image), title('Sharp Processing');