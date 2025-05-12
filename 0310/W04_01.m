% how to use Histogram
% histogram(file/data)
clc;
clear all;
close all;

Imag01 = imread('pout.tif');
histogram(Imag01);
xlabel('intensity'); ylabel('frequency');  title('Histogram');