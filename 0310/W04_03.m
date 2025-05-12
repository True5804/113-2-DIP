% different image with diff. histogram
uniform = ones(100)*128;
gradient = repmat(linspace(0,255,100)',1,100);
natural = imread('cameraman.tif');

figure;
subplot(3,2,1); imshow(uint8(uniform)); title('均勻灰色');
subplot(3,2,2); imhist(uint8(uniform)); title('均勻灰色直方圖');
subplot(3,2,3); imshow(uint8(gradient)); title('簡單漸變');
subplot(3,2,4); imhist(uint8(gradient)); title('漸變直方圖');
subplot(3,2,5); imshow(natural); title('自然圖像');
subplot(3,2,6); imhist(natural); title('自然圖像直方圖');
