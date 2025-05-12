% show histogram by imhist()
clc;
clear all;
close all;

I = imread('pout.tif');
imhist(I);
figure;
subplot(1,2,1);
histogram(I);
title('Histogram');
subplot(1,2,2);
imhist(I);
title('imhist');

