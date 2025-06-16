%% 膨脹示範
clc;
clear all;
close all;

figure('Name', '膨脹操作示範');

% subplot 1
subplot(3, 4, 1);
BW = false(200,200);
BW(50 : 150, 50 : 150) = true; % square
BW(90 : 110, 30 : 170) = true; % horizontal
BW(30 : 170, 90 : 110) = true; % vertical

imshow(BW);
title('原始二值影像');

%create a 3*3 square
subplot(3, 4, 2);
sel = strel('square', 3);
BW_dil1 = imdilate(BW, sel);
imshow(BW_dil1);
title('3x3方形SE 膨脹');

% create a 7*7 sqare
subplot(3,4,3);
sel = strel('square', 7);
BW_dil2 = imdilate(BW, sel);
imshow(BW_dil2);
title('7x7方形SE 膨脹');

% create a 15*15 sqare
subplot(3,4,4);
sel = strel('square', 15);
BW_dil3 = imdilate(BW, sel);
imshow(BW_dil3);
title('15x15方形SE 膨脹');

% 使用圓形結構元素
subplot(3,4,5);
se_disk1 = strel('disk',5);
BW_dil_disk1 = imdilate(BW, se_disk1);
imshow(BW_dil_disk1);
title('圓形SE膨脹');

subplot(3,4,6);
se_disk2 = strel('disk',15);
BW_dil_disk2 = imdilate(BW, se_disk2);
imshow(BW_dil_disk2);
title('圓形 r=15 SE膨脹');


% 使用線型結構元素 (水平)
subplot(3,4,7);
se_line1 = strel('line', 10, 0);
BW_dil_l1 = imdilate(BW, se_line1);
imshow(BW_dil_l1);
title('水平線SE膨脹');

% 使用線型結構元素 (垂直)
subplot(3,4,8);
se_line2 = strel('line', 10, 90);
BW_dil_l2 = imdilate(BW, se_line2);
imshow(BW_dil_l2);
title('垂直線SE膨脹');


