% catch RGB channel

clc;
clear All;
close All;
I = imread('6.png'); % 讀取彩色影像
figure;
imshow(I);
R = I(:,:,1); G = I(:,:,2); B = I(:,:,3); % 拆分 RGB 通道 
figure;
subplot(3,1,1), imhist(R); title('紅色通道'); 
subplot(3,1,2), imhist(G); title('綠色通道'); 
subplot(3,1,3), imhist(B); title('藍色通道');