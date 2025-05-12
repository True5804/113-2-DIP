% Canny Edge detection
clear all; close all; clc;
img = imread('smooth_image.png');
 
edges = edge(img, 'canny');
 
edge_enhanced = double(img);  
%edge_enhanced(edges) = 255;   % edge become white
edge_enhanced = uint8(edge_enhanced);
subplot(1, 3, 1);
imshow(img);
title('Oringinal');
subplot(1, 3, 2);
imshow(edges);
title('Canny edge detection');
subplot(1, 3, 3);
imshow(edge_enhanced);
title('Edge map to image');