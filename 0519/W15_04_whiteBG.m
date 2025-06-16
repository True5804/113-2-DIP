clc; 
close all; 
clear all;
% gen broken text image
%text_img = false(300, 1000);
text_img = true(300, 1000);
img_rgb = cat(3, text_img, text_img, text_img);
img_rgb = uint8(img_rgb * 255);
img_rgb = insertText(img_rgb, [50, 100], 'Computer Vision', 'FontSize', 60, 'BoxOpacity', 0, 'TextColor', 'black');
img_rgb = insertText(img_rgb, [50, 200], 'Text Recognition', 'FontSize', 60, 'BoxOpacity', 0, 'TextColor', 'black');
text_img = rgb2gray(img_rgb) > 0;

% 顯示原始文字影像
subplot(3, 3, 1);
imshow(text_img);
title('原始文字影像');
% gen noise and destroy
noise_salt = rand(size(text_img)) > 0.995;
noise_pepper = rand(size(text_img)) > 0.9;
random_breaks = rand(size(text_img)) > 0.02;
text_damaged = (text_img | noise_salt) & random_breaks;
text_damaged(text_img & noise_pepper) = false;
% 顯示損壞的文字影像
subplot(3, 3, 2);
imshow(text_damaged);
title('損壞的文字影像 (有噪聲和斷裂)');

%SE
se = strel('disk', 3);
%open operating (erosion then dilation)
opened_image=imopen(text_damaged,se);

% only dilation or only erosion
erode_image = imerode(text_damaged,se);
dilate_image = imdilate(text_damaged,se);
subplot(3, 3, 4);
imshow(dilate_image);
title('Dilation operation');
subplot(3, 3, 5);
imshow(erode_image);
title('Erode Operation');
subplot(3, 3, 6);
imshow(opened_image);
title('Open Operation');

se_s = strel('square', 1);
%open operating (erosion then dilation)
opened_image=imopen(text_damaged,se_s);

% only dilation or only erosion
erode_image = imerode(text_damaged,se_s);
dilate_image = imdilate(text_damaged,se_s);
subplot(3, 3, 7);
imshow(dilate_image);
title('Dilation operation');
subplot(3, 3, 8);
imshow(erode_image);
title('Erode Operation');
subplot(3, 3, 9);
imshow(opened_image);
title('Open Operation');
