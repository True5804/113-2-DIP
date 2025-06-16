clc;
clear all;
close all;

%applied onto real picture

figure('Name', '膨脹修復破損物體', 'Position', [100, 100, 1000, 400]);

% load the rice.png
J = imread('rice.png');
subplot(2, 4, 1);
imshow(J);
title('原始米粒影像');

%binary
BW_rice = imbinarize(J);
subplot(2, 4, 2);
imshow(BW_rice);
title('二值化後的米粒');

% risk = 3;
se2 = strel('disk', 3);
BW_rice_repair = imdilate(BW_rice, se2);
subplot(2, 4, 3);
imshow(BW_rice_repair);
title('用 disk 修復rice.png');

subplot(2, 4, 4);
imshowpair(BW_rice, BW_rice_repair, 'montage');
title('Before VS After');

% Fit onto the original image
subplot(2, 4, 5);
overlay_repaired = labeloverlay(J,BW_rice_repair,'Transparency',0.6,"Colormap",[0 1 0]);
imshow(overlay_repaired);
title('Fit onto the original');

% 計數未處理前圖像中的米粒個數
[labeled_orig, num_objects_orig] = bwlabel(BW_rice);
subplot(2, 4, 6);
imshow(label2rgb(labeled_orig, 'jet', 'k', 'shuffle'));
title(['before dilation: ' num2str(num_objects_orig) ' 個物體']);
% 計數處理後圖像中的米粒個數
[labeled_orig, num_objects_orig] = bwlabel(BW_rice_repair);
subplot(2, 4, 7);
imshow(label2rgb(labeled_orig, 'jet', 'k', 'shuffle'));
title(['After dilation: ' num2str(num_objects_orig) ' 個物體']);