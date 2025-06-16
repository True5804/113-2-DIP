%use coin as our sample
I = imread('coins.png');
I_gray = im2gray(I);

%set a threshold
V_threshold = 100;
BW_simple = I_gray > V_threshold;

%adaptive threshold
BW_adapt = adaptthresh(I_gray, 0.5);
BW_adapt = imbinarize(I_gray, BW_adapt);

% Otsu Method
level = graythresh(I_gray);
BW_otsu = imbinarize(I_gray,level);

figure;
subplot(2,2,1); imshow(I_gray); title('Original');
subplot(2,2,2); imshow(BW_simple); title('SimpleT');
subplot(2,2,3); imshow(BW_adapt); title('AdaptT');
subplot(2,2,4); imshow(BW_otsu); title('Otsu');