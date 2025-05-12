%histogram equalization
clc;
clear All;
close All;
I = imread('pout.tif');
%figure; imshow(I); title('Original Pic');

% applying histogram equalization 
h = histeq(I);
figure;
subplot(1,4,1), imshow(I);title('Original Pic');
subplot(1,4,2), imhist(I);title('Original Hist');
subplot(1,4,3), imshow(h);title('Equalization Pic');
subplot(1,4,4), imhist(h);title('Equalization Hist');
