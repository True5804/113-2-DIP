I = imread('cameraman.tif');

%how many threshold
m = multithresh(I, 2); % threshold m1 = 100, m2 = 175 0-99, 100-174, 174-255
q = imquantize(I, m); % separate into several levels
r = label2rgb(q); % 用彩色的顏色將圖片分類

figure;
subplot(1, 3, 1); imshow(I); title('Origial');
subplot(1, 3, 2); imshow(q, []); title('MultiQuntize');
subplot(1, 3, 3); imshow(r); title('Color labeling');