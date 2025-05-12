%GUI interface 
% 創建一個簡單的圖像上傳和顯示介面
function imageProcessingApp
    % 創建主窗口
    fig = figure('Name', '影像處理應用', 'Position', [200 100 800 500]);
    
    % 添加上傳按鈕
    uicontrol('Style', 'pushbutton', 'String', 'Upload Image', ...
        'Position', [50 420 100 30], 'Callback', @uploadImage);
    
    % 添加處理按鈕
    uicontrol('Style', 'pushbutton', 'String', 'Process Image', ...
        'Position', [160 420 100 30], 'Callback', @processImage);

    % 添加儲存按鈕
    uicontrol('Style', 'pushbutton', 'String', 'Save Image', ...
        'Position', [270 420 100 30], 'Callback', @saveImage);

    % Sliders for interactive control 
    % Gamma slider for Power Law Transformation
    uicontrol('Style', 'text', 'String', 'Gamma (Power Law) :', ...
        'Position', [370 450 120 30]);
    gammaSlider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 3, 'Value', 1, ...
        'Position', [490 465 200 15], 'Callback', @updatePreview);
    
    % Lower percentile slider for contrast stretching
    uicontrol('Style', 'text', 'String', 'Lower Percentile:', ...
        'Position', [370 420 100 30]);
    lowPercentileSlider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 0.2, 'Value', 0.05, ...
        'Position', [470 435 200 15], 'Callback', @updatePreview);
    
    % Upper percentile slider for contrast stretching
    uicontrol('Style', 'text', 'String', 'Upper Percentile:', ...
        'Position', [370 390 100 30]);
    highPercentileSlider = uicontrol('Style', 'slider', 'Min', 0.8, 'Max', 1, 'Value', 0.95, ...
        'Position', [470 405 200 15], 'Callback', @updatePreview);

    % 創建顯示區域
    originalAxes = axes('Position', [0.1 0.1 0.35 0.6]);
    title(originalAxes, 'Original Image');
    
    processedAxes = axes('Position', [0.55 0.1 0.35 0.6]);
    title(processedAxes, 'Processed Image');
    
    % 共享數據
    data = struct('originalImage', [], 'processedImage', [], 'filename', '');
    setappdata(fig, 'appData', data);
    
    % 上傳影像回調函數
    function uploadImage(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.tif;*.bmp', '影像檔案'}, '選擇影像');
        if isequal(filename, 0) || isequal(pathname, 0)
            return;
        end
        
        fullPath = fullfile(pathname, filename);
        img = imread(fullPath);
        
        % 儲存並顯示圖像
        data.originalImage = img;
        data.filename = filename;
        setappdata(fig, 'appData', data);
        
        axes(originalAxes);
        imshow(img);
        title(originalAxes, 'Original Image');
    end
    
    function processImage(~, ~)
        clc;
        data = getappdata(fig, 'appData');
        originalImg = data.originalImage;

        if isempty(data.originalImage)
            msgbox('Please upload an image first!', 'Error');
            return;
        end
        
        % Get slider values
        gamma = get(gammaSlider, 'Value');
        lowPercentile = get(lowPercentileSlider, 'Value');
        highPercentile = get(highPercentileSlider, 'Value');

       % === Step 1: 灰階圖 + 二值遮罩建立（偵測白點） ===
        gray = rgb2gray(originalImg);
        threshold = 240/255;
        bw = im2double(gray) > threshold;   % 白點區
        bw = imdilate(bw, strel('disk', 2));   % 擴張一點點讓邊緣完整
        
        % === Step 2: 抓出邊界區塊 ===
        [B, L] = bwboundaries(bw, 'noholes');
        filled_img = im2double(originalImg);            % 初始化補色圖
        
        % === Step 3: 對每個區塊進行補色處理 ===
        windowSize = 5;
        pad = floor(windowSize / 2);
        padded_img = padarray(filled_img, [pad pad], 'symmetric');
        padded_label = padarray(L, [pad pad]);
        
        for k = 1:length(B)
            area = sum(L(:) == k);  % 該區塊面積
        
            if area < 300  % 僅補小區塊
                [yIdx, xIdx] = find(L == k);
                for i = 1:length(yIdx)
                    y = yIdx(i);
                    x = xIdx(i);
                    for c = 1:3
                        region = padded_img(y:y+windowSize-1, x:x+windowSize-1, c);
                        region_label = padded_label(y:y+windowSize-1, x:x+windowSize-1);
                        valid_pixels = region(region_label ~= k);  % 周圍非本區的像素
                        if ~isempty(valid_pixels)
                            filled_img(y,x,c) = mean(valid_pixels);
                        end
                    end
                end
            end
        end

        % === Step 4: 轉灰階進入增強處理 ===
        img_gray = rgb2gray(filled_img);

        % === Step 5: Percentile contrast stretching ===
        sorted_pixels = sort(img_gray(:));
        num_pixels = numel(sorted_pixels);
        low_idx = round(lowPercentile * num_pixels);
        high_idx = round(highPercentile * num_pixels);
        if low_idx < 1, low_idx = 1; end
        if high_idx > num_pixels, high_idx = num_pixels; end
        low_val = sorted_pixels(low_idx);
        high_val = sorted_pixels(high_idx);

        stretched = img_gray;
        stretched(img_gray < low_val) = 0;
        stretched(img_gray > high_val) = 1;
        valid_range = (img_gray >= low_val) & (img_gray <= high_val);
        stretched(valid_range) = (img_gray(valid_range) - low_val) / (high_val - low_val);

        % === Step 6: Adaptive gamma correction ===
        gamma_corrected = stretched .^ gamma;

        % === Step 7: Histogram equalization ===
        equalized_img = histeq(gamma_corrected);

        data.processedImage = equalized_img;
        setappdata(fig, 'appData', data);
        axes(processedAxes);
        imshow(equalized_img);
        title(processedAxes, 'Processed Image');
    end

    function updatePreview(~, ~)
        processImage([], []);
    end

    % 儲存影像回調函數
    function saveImage(~, ~)
        data = getappdata(fig, 'appData');
        if isempty(data.processedImage)
            msgbox('請先處理影像！', '錯誤');
            return;
        end
        
        % 提取原始檔案的副檔名
        [~, ~, ext] = fileparts(data.filename);
        output_filename = ['output' ext]; % 輸出檔案名為 "output.<原始副檔名>"
        
        % 儲存處理後的圖像
        imwrite(data.processedImage, output_filename);
        msgbox(['處理後的圖像已儲存為：' output_filename], '成功');
    end
end