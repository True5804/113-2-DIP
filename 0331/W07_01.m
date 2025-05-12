clc;
close all;
clear all;

I = imread('lenna.jpeg');

I_double = double(I);

% create convolution 
kernel_size =3;
blur_kernel = ones(kernel_size)/(kernel_size^2);
%[1,1,1; 1,1,1;1,1,1]
%[1/9,1/9,1/9; 1/9,1/9,1/9;1/9,1/9,1/9]

kernel02=5;
blur_kernel02 = ones(kernel02)/(kernel02^2)

% apply kernel 
I_blurred = conv2(I_double, blur_kernel,'same');
I_blurred02 = conv2(I_double, blur_kernel02,'same');

I_blurred = uint8(I_blurred);
I_blurred02 = uint8(I_blurred02);

figure;
subplot(1,3,1);
imshow(I);
title('Original');

subplot(1,3,2);
imshow(I_blurred);
title('3*3 Conv2D');

subplot(1,3,3);
imshow(I_blurred02);
title('5*5 Conv2D');