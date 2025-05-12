% W03-01 image reading and storing
clear all; % clean all memory
close all; % close all opened figures

I=imread("flowers.jpg");
J=imread("fruits.jpg");
figure;
% put all images in one figure
%subplot(row, column, #of column);
subplot(1,2,1);
imshow(I);
title('Flowers');
subplot(1,2,2);
imshow(J);
title('Fruit');

% write images into another new file
imwrite(I, 'newFlowers.png');