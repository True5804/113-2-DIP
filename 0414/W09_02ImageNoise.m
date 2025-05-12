%% noise generator
clc;
clear all();
close all;

% get image
I = imread('lenna 1.jpeg');
I_double = im2double(I);

% create a folder for noise images
if ~exist('noise_images', 'dir')
    mkdir('noise_images');
end

imwrite(I, 'noise_images/lenna_original.png');

% 高斯噪聲
% J = imnoise(I,"gaussian")

% 不同均值和方差的高斯噪聲
gauss_params = [
    0, 0.01;   % 均值為0，方差為0.01
    0, 0.03;   % 均值為0，方差為0.03
    0, 0.05;   % 均值為0，方差為0.05
    0.1, 0.01; % 均值為0.1，方差為0.01
    -0.1, 0.01 % 均值為-0.1，方差為0.01
];

figure('Name', '高斯噪聲', 'Position', [100, 100, 1200, 400]);
subplot(2, 6, 1);
imshow(I_double);
title('原圖');

for i = 1:size(gauss_params, 1)
    m = gauss_params(i, 1);
    var = gauss_params(i, 2);
    %J = imnoise(I,"gaussian",m,var_gauss)
    noisy_img=imnoise(I_double,'gaussian',m,var);

    % save the noise image into the folder
    filename = sprintf('noise_images/lenna_gaussian_m%.1f_var%.2f.png', m, var);
    imwrite(noisy_img, filename);

    %show pic
    subplot(2, 6, i+1);
    imshow(noisy_img);
    title(sprintf('高斯噪聲 (m=%.1f, var=%.2f)', m, var));
end

%Poisson noise
poisson_img = imnoise(I_double, 'poisson');
subplot(2, 6, 7);
imshow(poisson_img);
title('Poisson');
imwrite(poisson_img, 'noise_images/lenna_poisson.png');

% Salt & pepper noise
salt_img = imnoise(I_double, 'salt & pepper', 0.1);
subplot(2, 6, 8);
imshow(salt_img);
title('Salt & Pepper');
imwrite(salt_img, 'noise_images/lenna_saltANDpepper.png');

% Speckle noise with specified variance
speckle_var = 0.05;
speckle_img = imnoise(I_double, 'speckle', speckle_var);
subplot(2, 6, 9);
imshow(speckle_img);
title(sprintf('Speckle (var=%.2f)', speckle_var));
imwrite(speckle_img, 'noise_images/lenna_speckle.png');

% Combined Poisson + Speckle noise
speckleANDpoisson = imnoise(poisson_img, 'speckle', speckle_var);
subplot(2, 6, 10);
imshow(speckleANDpoisson);
title('Poisson + Speckle');
imwrite(speckleANDpoisson, 'noise_images/lenna_speckleANDpoisson.png');