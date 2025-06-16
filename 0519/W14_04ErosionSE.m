clc;
clear all;
close all;

figure('Name', '膨脹VS侵蝕 : OR vs AND', 'Position', [100, 100, 900, 600]);
BW = false(200, 200);
BW(50 : 150, 50 : 150) = true; % square
BW(90 : 110, 30 : 170) = true; % horizontal
BW(30 : 170, 90 : 110) = true; % vertical

% 在正方形內加入一些小孔洞
BW(70:80, 70:80) = false;
BW(120:130, 120:130) = false;
subplot(2, 3, 1);
imshow(BW);
title('原始二值影像');
se = strel('square', 3);

% dilation
dilated = imdilate(BW, se);
subplot(2, 3, 2);
imshow(dilated);
title('Dilation');

% erosion
eroded = imerode(BW, se);
subplot(2, 3, 3);
imshow(eroded);
title('Erotion');