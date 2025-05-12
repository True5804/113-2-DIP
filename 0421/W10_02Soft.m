%% generate a new picture which is more blur smooth
clc; 
clear all;
close all;

image = imread('lenna 1.jpeg');

image = double(image);

%generate Smooth image here we use Guass
h_size = 5;
sigma = 2;
h_smooth = fspecial('gaussian',[h_size h_size],sigma);
smooth_img = imfilter(image, h_smooth, 'replicate');
imwrite(uint8(smooth_img), fullfile('smooth_image.png'));
figure;
subplot(1,2,1), imshow(uint8(image)), title('Original');
subplot(1,2,2), imshow(uint8(smooth_img)), title('Smooth Image');