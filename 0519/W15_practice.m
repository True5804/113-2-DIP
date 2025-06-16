clc; 
close all; 
clear all;


J = imread(['finger.png']);
% SE : Square r = 2
se = strel('square', 2);
se_line1 = strel('line', 4, 0);

%open operating (erosion then dilation)
opened_image=imopen(J,se_line1);
closed_image = imclose(J,se_line1);

% opening
erode_image = imerode(J,se_line1);
dilate_image = imdilate(J,se_line1);
subplot(4, 2, 1);
imshow(dilate_image);
title('Dilation operation');
subplot(4, 2, 2);
imshow(erode_image);
title('Erode Operation');
subplot(4, 2, 3);
imshow(opened_image);
title('Open Operation');
% closing
subplot(4, 2, 4);
imshow(closed_image);
title('Close Operation');

dilate_square_image = imdilate(opened_image,se);
subplot(4, 2, 5);
imshow(dilate_square_image);
title('Diliation after opening');


output_name = sprintf('S11159020.jpg');
imwrite(dilate_square_image, output_name);


