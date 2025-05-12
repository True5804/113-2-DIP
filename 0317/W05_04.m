%point bright by channel
clc;
clear All;
close All;

%read original image
original_image = imread('orange.jpg');

% brightness to each different channels 
% show each channel
R = original_image(:,:,1);
G = original_image(:,:,2);
B = original_image(:,:,3);

R_new=uint8(min(255, max(0, double(R)+ 50)));


% 三個不同 channel -> 整併
colored_output = cat(3, R_new,G,B);

% 顯示結果
figure;
subplot(1,2,1), imshow(original_image), title('原圖');
subplot(1,2,2), imshow(colored_output), title('調亮R channel');