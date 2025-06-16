%% using dilation and erosion on texting feature recognization

figure('Name','文字辨識中的膨脹應用', 'Position', [100, 100, 1000, 800]);

% text gen
text_img = false(300,1000);
img_rgb = cat(3, text_img, text_img, text_img);
img_rgb = uint8(img_rgb * 255);
img_rgb = insertText(img_rgb, [50, 100], 'Computer Vision', 'FontSize', 60, 'BoxOpacity', 0, 'TextColor', 'white');
img_rgb = insertText(img_rgb, [50, 200], 'Text Recognition', 'FontSize', 60, 'BoxOpacity', 0, 'TextColor', 'white');
% to binary
text_img = rgb2gray(img_rgb) >0;
% show Original
subplot(3, 3, 1);
imshow(text_img);
title('原始文字影像');

% simulate with noise and destory
% salt and pepper
noise_salt = rand(size(text_img)) > 0.995;  % add white noise
noise_pepper = rand(size(text_img)) > 0.9;  % add black noise

% simulate the words with break
random_breaks = rand(size(text_img)) > 0.02;
% add noise and break into the original pic
text_damaged = (text_img | noise_salt) & random_breaks;
text_damaged(text_img & noise_pepper) = false;
% 顯示損壞的文字影像
subplot(3, 3, 2);
imshow(text_damaged);
title('損壞的文字影像 (有噪聲和斷裂)');

% Dilation and Erotion
% SE
% dilation : imdilate(text_damaged, SE)
subplot(3, 3, 3);
sel = strel('square', 3);
text_damaged_dil1 = imdilate(text_damaged, sel);
imshow(text_damaged_dil1);
title('3x3方形SE 膨脹');

subplot(3,3,4);
se_disk1 = strel('disk',1);
text_damaged_disk1 = imdilate(text_damaged, se_disk1);
imshow(text_damaged_disk1);
title('圓形SE r=1 膨脹');

subplot(3,3,5);
se_disk2 = strel('disk',5);
text_damaged_disk2 = imdilate(text_damaged, se_disk2);
imshow(text_damaged_disk2);
title('圓形SE r=5 膨脹');

% Erotion : imerote(text_damaged, SE)
se = strel('square', 3);
eroded = imerode(text_damaged, se);
subplot(3, 3, 6);
imshow(eroded);
title('方形 3*3 縮小');
