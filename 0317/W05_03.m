%point bright
clc;
clear All;
close All;

%read original image
original_image = imread('orange.jpg');

Pbrightness = 50;
Nbrightness = -50;
%avoid overflow

colored_outputP = uint8(min(255, max(0, double(original_image)+ Pbrightness)));
colored_outputN = uint8(min(255, max(0, double(original_image)+ Nbrightness)));

% 顯示結果
figure;
subplot(1,3,1), imshow(original_image), title('原圖');
subplot(1,3,2), imshow(colored_outputP), title('調亮');
subplot(1,3,3), imshow(colored_outputN), title('調暗');