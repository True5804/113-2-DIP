%% Affine translate 
 
% 讀取原始影像
original_image = imread('flower.jpg');
% 定義平移參數(x方向移動50像素，y方向移動30像素)
tx = 50;
ty = 30;
% 創建平移矩陣 [ , , ]
tform = affine2d([1 0 0; 0 1 0; tx ty 1]);
% 創建一個比原始影像大的輸出視圖，確保能看到平移部分
[h, w, ~] = size(original_image);
outputView = imref2d([h+abs(ty)*2, w+abs(tx)*2]);
outputView.XWorldLimits = outputView.XWorldLimits - tx;
outputView.YWorldLimits = outputView.YWorldLimits - ty;
% 應用變換
outputImg = imwarp(original_image, tform, 'OutputView', outputView);
% 顯示結果
figure;
subplot(1,2,1), imshow(original_image), title('原始影像');
subplot(1,2,2), imshow(outputImg), title('平移後影像');