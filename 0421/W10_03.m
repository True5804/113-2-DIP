clear; clc; close all;
I=imread('lenna 1.jpeg');
smooth_img = imread('smooth_image.png');
I_double=double(I);
smooth_img = double(smooth_img);
high_boost_filter = [
    -1, -1, -1;
    -1,  8, -1;
    -1, -1, -1
];
edge_Oimg = imfilter(I_double, high_boost_filter, 'replicate');
edge_Simg = imfilter(smooth_img, high_boost_filter, 'replicate');
% normalization
edge_Oimg = abs(edge_Oimg);
edge_Oimg = edge_Oimg / max(edge_Oimg(:)) * 255;
edge_Simg = abs(edge_Simg);
edge_Simg = edge_Simg / max(edge_Simg(:)) * 255;
subplot(2, 2, 1);
imshow(uint8(I_double));
title('Origin');
subplot(2, 2, 3);
imshow(uint8(smooth_img));
title('Smooth');
subplot(2, 2, 2);
imshow(uint8(edge_Oimg));
title('Origin Edge');
subplot(2, 2, 4);
imshow(uint8(edge_Simg));
title('Smooth Edge');