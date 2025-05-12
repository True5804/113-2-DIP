%load color image and process it
clc;
clear All;
close All;

colorImg = imread('6.png');
figure;
imshow(colorImg); title('彩色原圖');

% 提取並顯示各色彩通道
redChannel = colorImg(:,:,1);
greenChannel = colorImg(:,:,2);
blueChannel = colorImg(:,:,3);

% 創建只有紅色通道的RGB圖像
redOnly = zeros(size(colorImg), 'uint8');
redOnly(:,:,1) = redChannel; % 只填充紅色通道

% 針對紅色通道偏暗的問題進行增強
enhancedRed = imadjust(redChannel, [0 1], [0.2 1]); % 增強紅色通道

% 創建增強後的彩色圖像
enhancedImg = colorImg;
enhancedImg(:,:,1) = enhancedRed; % 替換為增強後的紅色通道

% 顯示增強效果
figure;
subplot(1,3,1); imshow(colorImg); title('原始圖像');
subplot(1,3,2); imshow(redOnly); title('紅色通道');
subplot(1,3,3); imshow(enhancedImg); title('紅色通道增強後');

% 顯示增強前後的紅色通道直方圖比較
figure;
subplot(1,2,1); imhist(redChannel); title('原始紅色通道直方圖');
subplot(1,2,2); imhist(enhancedRed); title('增強後紅色通道直方圖');