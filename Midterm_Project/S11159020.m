clc;
clear all;
close all;

% 讀取圖像
images = {'01.jpg', '02.jpg', '03.jpg'};
output_images = {};
output_reports = {};

for idx = 1:length(images)
    img = imread(images{idx});
    figure, imshow(img), title(['Original Image ', images{idx}]);

    % 判斷是否為彩色圖像（檢查通道數）
    is_color = size(img, 3) == 3;
    if is_color
        R = img(:,:,1);
        G = img(:,:,2);
        B = img(:,:,3);
        % 進一步檢查是否為黑白照片（即使有三個通道，R、G、B 是否相同）
        is_grayscale = all(R(:) == G(:)) && all(G(:) == B(:));
        if is_grayscale
            % 如果是黑白照片，將圖像轉為灰階形式，但保留三通道格式以便後續處理
            img = cat(3, R, R, R);
        end
    else
        % 單通道圖像，直接視為黑白照片
        R = img;
        G = img;
        B = img;
        img = cat(3, R, G, B);
        is_grayscale = true;
    end
    
    % 基本特性
    [height, width, depth] = size(img);
    fprintf('Image %s: Size = %dx%d, Depth = %d\n', images{idx}, height, width, depth);
    
    % 計算每個通道的統計數據
    histR = imhist(R);
    histG = imhist(G);
    histB = imhist(B);
    
    meanR = mean(double(R(:)));
    meanG = mean(double(G(:)));
    meanB = mean(double(B(:)));
    stdR = std(double(R(:)));
    stdG = std(double(G(:)));
    stdB = std(double(B(:)));
    
    meanIntensity = (meanR + meanG + meanB) / 3;
    stdIntensity = (stdR + stdG + stdB) / 3;
    
    % 噪聲判斷
    blackPixelRatioR = sum(R(:) == 0) / numel(R);
    whitePixelRatioR = sum(R(:) == 255) / numel(R);
    blackPixelRatioG = sum(G(:) == 0) / numel(G);
    whitePixelRatioG = sum(G(:) == 255) / numel(G);
    blackPixelRatioB = sum(B(:) == 0) / numel(B);
    whitePixelRatioB = sum(B(:) == 255) / numel(B);
    
    blackPixelRatio = (blackPixelRatioR + blackPixelRatioG + blackPixelRatioB) / 3;
    whitePixelRatio = (whitePixelRatioR + whitePixelRatioG + whitePixelRatioB) / 3;
    saltPepperThreshold = 0.05;
    
    % 直方圖平滑處理
    windowSize = 5;
    histSmoothR = movmean(histR, windowSize);
    histSmoothG = movmean(histG, windowSize);
    histSmoothB = movmean(histB, windowSize);
    
    % 計算亮區和暗區的標準差（用於 Poisson 噪聲判斷）
    brightAreaR = R > 180;
    darkAreaR = R < 70;
    brightAreaG = G > 180;
    darkAreaG = G < 70;
    brightAreaB = B > 180;
    darkAreaB = B < 70;
    
    brightStdR = std(double(R(brightAreaR)));
    darkStdR = std(double(R(darkAreaR)));
    brightStdG = std(double(G(brightAreaG)));
    darkStdG = std(double(G(darkAreaG)));
    brightStdB = std(double(B(brightAreaB)));
    darkStdB = std(double(B(darkAreaB)));
    
    brightStd = (brightStdR + brightStdG + brightStdB) / 3;
    darkStd = (darkStdR + darkStdG + darkStdB) / 3;
    
    % 檢查直方圖分佈的均勻性（用於 Speckle 和 Localvar 噪聲判斷）
    histVarR = std(histSmoothR);
    histVarG = std(histSmoothG);
    histVarB = std(histSmoothB);
    histVar = (histVarR + histVarG + histVarB) / 3;
    
    % 噪聲檢測
    noise_types = {};
    if blackPixelRatio + whitePixelRatio > saltPepperThreshold
        noise_types{end+1} = 'salt & pepper';
    end
    if stdIntensity > 100 && histVar > 1500
        noise_types{end+1} = 'localvar';
    end
    if stdIntensity > 80 && histVar > 1000
        noise_types{end+1} = 'speckle';
    end
    if brightStd > darkStd * 1.5 && brightStd > 50
        noise_types{end+1} = 'poisson';
    end
    if stdIntensity > 20
        noise_types{end+1} = 'gaussian';
    end
    if isempty(noise_types)
        noise_types{end+1} = 'unknown';
    end
    
    % 根據是否為黑白照片調整處理流程
    filter_used = {};
    num_small_areas = 0;  % 記錄補色的小區塊數量
    
    if is_grayscale
        % 黑白照片：先補色後去噪
        % 補色功能：修復舊照片中的白點或損壞區域
        % Step 1: 灰階圖 + 二值遮罩建立（偵測白點）
        gray = rgb2gray(img);
        threshold = 240/255;
        bw = im2double(gray) > threshold;   % 白點區
        bw = imdilate(bw, strel('disk', 2));   % 擴張一點點讓邊緣完整
        
        % Step 2: 抓出邊界區塊
        [boundaries, L] = bwboundaries(bw, 'noholes');
        filled_img = im2double(img);   % 初始化補色圖
        
        % Step 3: 對每個區塊進行補色處理
        windowSize = 5;
        pad = floor(windowSize / 2);
        padded_img = padarray(filled_img, [pad pad], 'symmetric');
        padded_label = padarray(L, [pad pad]);
        
        % 獲取 padded_img 的大小
        [padded_height, padded_width, ~] = size(padded_img);
        
        for k = 1:length(boundaries)
            area = sum(L(:) == k);  % 該區塊面積
            if area < 300  % 僅補小區塊
                num_small_areas = num_small_areas + 1;
                [yIdx, xIdx] = find(L == k);
                for i = 1:length(yIdx)
                    y = yIdx(i);
                    x = xIdx(i);
                    % 調整座標以匹配填充後的圖像
                    y_padded = y + pad;
                    x_padded = x + pad;
                    % 檢查邊界，確保不超出 padded_img 和 padded_label
                    if y_padded + windowSize - 1 <= padded_height && x_padded + windowSize - 1 <= padded_width
                        region = padded_img(y_padded:y_padded+windowSize-1, x_padded:x_padded+windowSize-1, :);
                        region_label = padded_label(y_padded:y_padded+windowSize-1, x_padded:x_padded+windowSize-1);
                        for c = 1:3
                            region_channel = region(:,:,c);
                            valid_pixels = region_channel(region_label ~= k);  % 周圍非本區的像素
                            if ~isempty(valid_pixels)
                                filled_img(y,x,c) = mean(valid_pixels);
                            end
                        end
                    end
                end
            end
        end
        % 將補色後的圖像轉回 uint8 格式
        filtered_img = uint8(filled_img * 255);
        
        % 去噪：根據檢測到的噪聲類型動態應用濾波
        if ismember('salt & pepper', noise_types) || ismember('speckle', noise_types)
            % 中值濾波：對椒鹽噪聲和斑點噪聲有效，增大窗口到 5x5
            for c = 1:size(filtered_img, 3)
                filtered_img(:,:,c) = medfilt2(filtered_img(:,:,c), [5 5]);
            end
            filter_used{end+1} = 'Median Filter (5x5)';
        end
        if ismember('gaussian', noise_types) || ismember('poisson', noise_types) || ismember('localvar', noise_types)
            % 均值濾波：對高斯噪聲、泊松噪聲和局部變異噪聲有效，增大窗口到 5x5
            for c = 1:size(filtered_img, 3)
                filtered_img(:,:,c) = uint8(conv2(double(filtered_img(:,:,c)), ones(5)/25, 'same'));
            end
            filter_used{end+1} = 'Mean Filter (5x5)';
        end
    else
        % 彩色照片：直接去噪，不補色
        filtered_img = img;
        if ismember('salt & pepper', noise_types) || ismember('speckle', noise_types)
            % 中值濾波：對椒鹽噪聲和斑點噪聲有效，增大窗口到 5x5
            for c = 1:size(filtered_img, 3)
                filtered_img(:,:,c) = medfilt2(filtered_img(:,:,c), [5 5]);
            end
            filter_used{end+1} = 'Median Filter (5x5)';
        end
        if ismember('gaussian', noise_types) || ismember('poisson', noise_types) || ismember('localvar', noise_types)
            % 均值濾波：對高斯噪聲、泊松噪聲和局部變異噪聲有效，增大窗口到 5x5
            for c = 1:size(filtered_img, 3)
                filtered_img(:,:,c) = uint8(conv2(double(filtered_img(:,:,c)), ones(5)/25, 'same'));
            end
            filter_used{end+1} = 'Mean Filter (5x5)';
        end
    end
    
    % 模糊類型判斷：使用傅立葉變換檢測模糊類型
    gray_img = rgb2gray(filtered_img);
    fft_img = fft2(double(gray_img));
    fft_shifted = fftshift(abs(fft_img));
    
    % 簡單的方向性檢測：計算頻域圖像的梯度方向
    [gx, gy] = gradient(fft_shifted);
    gradient_magnitude = sqrt(gx.^2 + gy.^2);
    gradient_direction = atan2(gy, gx);
    
    % 統計梯度方向的直方圖，檢查是否有明顯的方向性
    direction_hist = imhist(uint8((gradient_direction + pi) * 180 / (2 * pi)));
    max_direction_peak = max(direction_hist) / sum(direction_hist);
    
    % 如果頻域中有明顯的方向性（例如某方向占比 > 20%），假設為運動模糊
    if max_direction_peak > 0.2
        blur_type = 'motion';
        deblur_method = 'deconvlucy';
        % 估計運動模糊的 PSF（假設長度為 10 像素，角度為 45 度）
        LEN = 10;
        THETA = 45;
        psf = fspecial('motion', LEN, THETA);
    else
        blur_type = 'gaussian';
        deblur_method = 'deconvwnr';
        % 假設高斯模糊的 PSF（3x3，標準差 0.5）
        psf = fspecial('gaussian', [3 3], 0.5);
    end
    
    % 去模糊
    deblurred_img = filtered_img;
    if strcmp(blur_type, 'motion')
        % 運動模糊：使用 deconvlucy 去模糊
        for c = 1:size(deblurred_img, 3)
            deblurred_img(:,:,c) = deconvlucy(deblurred_img(:,:,c), psf, 10);
        end
    else
        % 高斯模糊：使用 deconvwnr 去模糊
        % 估計噪聲功率（假設為 0.01）
        NSR = 0.01;
        for c = 1:size(deblurred_img, 3)
            deblurred_img(:,:,c) = deconvwnr(deblurred_img(:,:,c), psf, NSR);
        end
    end
    
    % 過曝判斷：檢查高亮像素比例
    highBrightThreshold = 230;
    highBrightRatioR = sum(R(:) > highBrightThreshold) / numel(R);
    highBrightRatioG = sum(G(:) > highBrightThreshold) / numel(G);
    highBrightRatioB = sum(B(:) > highBrightThreshold) / numel(B);
    highBrightRatio = (highBrightRatioR + highBrightRatioG + highBrightRatioB) / 3;
    
    % 修改過曝條件
    is_overexposed = highBrightRatio > 0.1 || highBrightRatioR > 0.15 || highBrightRatioG > 0.15 || highBrightRatioB > 0.15;
    gamma_applied = 'None';
    
    % 如果過曝，應用 Gamma 校正
    if is_overexposed
        gamma = 1.5;
        R_adjusted = double(deblurred_img(:,:,1)) / 255;
        G_adjusted = double(deblurred_img(:,:,2)) / 255;
        B_adjusted = double(deblurred_img(:,:,3)) / 255;
        R_adjusted = R_adjusted .^ gamma;
        G_adjusted = G_adjusted .^ gamma;
        B_adjusted = B_adjusted .^ gamma;
        deblurred_img = cat(3, uint8(R_adjusted * 255), uint8(G_adjusted * 255), uint8(B_adjusted * 255));
        gamma_applied = sprintf('Gamma Correction (gamma=%.1f)', gamma);
    end
    
    % 銳化處理：使用 imsharpen 對去模糊後的圖像進行銳化
    sharpened_img = imsharpen(deblurred_img);
    
    % 分析圖片清晰度和對比度（原始圖像和處理後圖像）
    gray_orig = rgb2gray(img);
    laplacian_filter = fspecial('laplacian', 0);
    laplacian_orig = imfilter(double(gray_orig), laplacian_filter, 'symmetric');
    sharpness_orig = std(laplacian_orig(:))^2;
    
    gray_processed = rgb2gray(sharpened_img);
    laplacian_processed = imfilter(double(gray_processed), laplacian_filter, 'symmetric');
    sharpness_processed = std(laplacian_processed(:))^2;
    
    contrast_orig = std(double(gray_orig(:)));
    contrast_processed = std(double(gray_processed(:)));
    
    % 儲存處理後圖片
    output_name = sprintf('A%02d.jpg', idx);
    imwrite(sharpened_img, output_name);
    output_images{end+1} = output_name;
    
    % 比較說明文件
    report_name = sprintf('A%02d.txt', idx);
    fid = fopen(report_name, 'w');
    fprintf(fid, 'Image: %s\n', images{idx});
    fprintf(fid, 'Is Grayscale: %s\n', mat2str(is_grayscale));
    fprintf(fid, 'Noise Types Detected: %s\n', strjoin(noise_types, ', '));
    fprintf(fid, 'Blur Type Detected: %s\n', blur_type);
    fprintf(fid, 'Overexposure Detected: %s\n', mat2str(is_overexposed));

    fprintf(fid, '\nOriginal Size: %dx%d, Depth = %d\n', height, width, depth);
    fprintf(fid, 'Original Sharpness (Laplacian Variance): %.2f\n', sharpness_orig);
    fprintf(fid, 'Processed Sharpness (Laplacian Variance): %.2f\n', sharpness_processed);
    fprintf(fid, 'Original Contrast (Intensity Std): %.2f\n', contrast_orig);
    fprintf(fid, 'Processed Contrast (Intensity Std): %.2f\n', contrast_processed);

    fprintf(fid, '\nFilters Applied: %s\n', strjoin(filter_used, ', '));
    fprintf(fid, 'Deblur Method: %s\n', deblur_method);
    fprintf(fid, 'Gamma Correction: %s\n', gamma_applied);
    fprintf(fid, 'Inpainted Small Regions: %d\n', num_small_areas);
    fclose(fid);
    output_reports{end+1} = report_name;
    
    figure, imshow(sharpened_img), title(['Processed Image ', images{idx}]);
end