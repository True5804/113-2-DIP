%% Power law of partial 
clc;
clear all;
close all;

% 讀取原始影像
original_image = imread('orange.jpg');
img_double = im2double(original_image);

% 計算影像的平均亮度
mean_intensity = mean(img_double(:));

% 把一張圖片切割成許多的網格
block_size = 64;
[h, w, c] = size(img_double);
corrected_img = zeros(size(img_double));

% 一一的對切割後的網格進行適當的gamma adjustment
for i=1:block_size:h
    for j=1:block_size:w
        %定義目前這一塊的範圍
        row_end =min(i+block_size-1,h);
        col_end = min(j+block_size-1,w);

        %提取當前的這一塊 
        block = img_double(i:row_end, j:col_end,:);
        %計算 block 的平均亮度
        mean_block = mean(block(:));
        if mean_block <0.3 
            gamma = 0.4; %提高暗的影像
        elseif mean_block <0.5 
            gamma = 0.7 % 增強過量影像的對比度
        elseif mean_block <0.7
            gamma = 1.0;
        else 
            gamma = 1.5;
        end

        % apply power law 
        corrected_block=block.^gamma;

        % 完成後將校正的結果放回影像中
        corrected_img(i:row_end, j:col_end,:)=corrected_block;
    end
end

% show output
figure;
subplot(1,2,1), imshow(img_double), title("Original");
subplot(1,2,2), imshow(corrected_img), title('Partial Adjusted Gamma');
