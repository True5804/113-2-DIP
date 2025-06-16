clc;
clear all;
close all;

% load the picture
J = imread(['damaged_text.png']);
subplot(1, 2, 1);
imshow(J);
title('Original');

% erosion
se = strel('square', 2);
eroded = imerode(J, se);

% 線型結構元素 (水平 + 垂直)
se_line1 = strel('line', 4, 0);
BW_dil_l1 = imdilate(eroded, se_line1);

se_line2 = strel('line', 4, 90);
BW_text_repair = imdilate(BW_dil_l1, se_line2);

subplot(1, 2, 2);
imshow(BW_text_repair);
title('erosion + dilation in vertical and horizontal lines');

output_name = sprintf('S11159020_repaired.jpg');
imwrite(BW_text_repair, output_name);
