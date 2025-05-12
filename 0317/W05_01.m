%load pic
original_image=imread('orange.jpg');

% check whether color or gray
if size(original_image, 3) == 3
    gray_image = rgb2gray(original_image);
else
    gray_image = original_image;
end

% file is uint 8 ->255 2^8=256 -1
% file is unit 16
negative_image = 255-gray_image;


% 顯示結果
figure;
subplot(1,3,1), imshow(original_image), title('原始影像');
subplot(1,3,2), imshow(gray_image), title('灰階影像');
subplot(1,3,3), imshow(negative_image), title('負片效果');