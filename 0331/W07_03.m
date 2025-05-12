% use different shape full same valid
clc;
close all;
clear all;

I = imread('lenna.jpeg');

I_double = double(I);
% create convolution 
kernel_size =9;
blur_kernel = ones(kernel_size)/(kernel_size^2);

% 使用 conv2 進行卷積
I_blur_same = conv2(I_double, blur_kernel, 'same');
I_blur_full = conv2(I_double, blur_kernel, 'full');
I_blur_valid = conv2(I_double, blur_kernel, 'valid');


% 顯示結果
figure;
subplot(2, 2, 1);
imshow(uint8(I_double));
title('原始影像');

subplot(2, 2, 2);
imshow(uint8(I_blur_same));
title(sprintf('Same [%dx%d]', size(I_blur_same)));

subplot(2, 2, 3);
imshow(uint8(I_blur_full));
title(sprintf('Full [%dx%d]', size(I_blur_full)));

subplot(2, 2, 4);
imshow(uint8(I_blur_valid));
title(sprintf('Valid [%dx%d]', size(I_blur_valid)));

crop_size = 50;
figure;
subplot(2, 2, 1);
imshow(uint8(I_double(1:crop_size, 1:crop_size)));
title('原始影像 (左上角)');

subplot(2, 2, 2);
imshow(uint8(I_blur_same(1:crop_size, 1:crop_size)));
title('Same (左上角)');

subplot(2, 2, 3);
imshow(uint8(I_blur_full(1:crop_size, 1:crop_size)));
title('Full (左上角，注意擴展)');

subplot(2, 2, 4);
if size(I_blur_valid, 1) >= crop_size && size(I_blur_valid, 2) >= crop_size
    imshow(uint8(I_blur_valid(1:crop_size, 1:crop_size)));
else
    imshow(uint8(I_blur_valid));
end
title('Valid (注意縮小)');