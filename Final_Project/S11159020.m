function HistoricalDocumentProcessor()
    clc;
    clear all;
    close all;
    
    fig = figure('Name', 'Historical Document Image Processing System v2.0', ...
                 'Position', [100 0 1000 700], ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Resize', 'on', ...
                 'HandleVisibility', 'on', ...
                 'Color', [0.94 0.94 0.94], ...
                 'NumberTitle', 'off');
    
    % Initialize global variables
    originalImages = cell(1, 3);
    processedImages = cell(1, 3);
    imageNames = {'ImageA', 'ImageB', 'ImageC'};
    diagnosticResults = cell(1, 3);
    progressBar = [];
    statusText = [];
    
    % Create UI components
    createUI();
    
    function createUI()
        % Main container with better organization
        mainPanel = uipanel('Parent', fig, 'BorderType', 'none', ...
                           'Units', 'normalized', 'Position', [0 0 1 1], ...
                           'BackgroundColor', [0.94 0.94 0.94]);
        
        % Header Panel with title and info
        headerPanel = uipanel('Parent', mainPanel, ...
                             'Units', 'normalized', ...
                             'Position', [0.01 0.90 0.98 0.08], ...
                             'BackgroundColor', [0.2 0.3 0.5], ...
                             'BorderType', 'line', ...
                             'HighlightColor', [0.3 0.4 0.6]);
        
        % Title text
        uicontrol('Parent', headerPanel, 'Style', 'text', ...
                 'String', 'Historical Document Image Processing System', ...
                 'Units', 'normalized', 'Position', [0.02 0.45 0.6 0.45], ...
                 'FontSize', 16, 'FontWeight', 'bold', ...
                 'ForegroundColor', 'white', ...
                 'BackgroundColor', [0.2 0.3 0.5], ...
                 'HorizontalAlignment', 'left');
        
        % Subtitle
        uicontrol('Parent', headerPanel, 'Style', 'text', ...
                 'String', 'Student ID: S11159020 | Advanced Image Enhancement Pipeline', ...
                 'Units', 'normalized', 'Position', [0.02 0.05 0.6 0.3], ...
                 'FontSize', 10, ...
                 'ForegroundColor', [0.8 0.8 0.8], ...
                 'BackgroundColor', [0.2 0.3 0.5], ...
                 'HorizontalAlignment', 'left');
        
        % Control Panel with better styling
        controlPanel = uipanel('Parent', mainPanel, 'Title', 'Controls', ...
                              'Units', 'normalized', ...
                              'Position', [0.01 0.70 0.98 0.2], ...
                              'BackgroundColor', [0.96 0.96 0.98], ...
                              'FontSize', 12, 'FontWeight', 'bold', ...
                              'TitlePosition', 'lefttop');
        
        % Load buttons with improved styling
        buttonColors = [0.3 0.6 0.9; 0.9 0.6 0.3; 0.6 0.9 0.3];
        for i = 1:3
            uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
                     'String', ['📁 Load ' imageNames{i}], ...
                     'Units', 'normalized', ...
                     'Position', [0.02 + (i-1)*0.25 0.55 0.22 0.35], ...
                     'BackgroundColor', buttonColors(i,:), ...
                     'ForegroundColor', 'white', ...
                     'FontSize', 11, 'FontWeight', 'bold', ...
                     'Callback', @(src, evt) loadImage(i));
            
            % Status indicators
            uicontrol('Parent', controlPanel, 'Style', 'text', ...
                     'String', 'Not Loaded', ...
                     'Units', 'normalized', ...
                     'Position', [0.02 + (i-1)*0.25 0.25 0.22 0.2], ...
                     'FontSize', 9, ...
                     'ForegroundColor', [0.6 0.6 0.6], ...
                     'BackgroundColor', [0.96 0.96 0.98], ...
                     'Tag', ['Status' imageNames{i}]);
        end
        
        % Processing controls
        uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
                 'String', '⚙️ Process All Images', ...
                 'Units', 'normalized', ...
                 'Position', [0.78 0.55 0.2 0.35], ...
                 'BackgroundColor', [0.2 0.7 0.2], ...
                 'ForegroundColor', 'white', ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'Callback', @processAllImages);
        
        uicontrol('Parent', controlPanel, 'Style', 'pushbutton', ...
                 'String', '💾 Save Results', ...
                 'Units', 'normalized', ...
                 'Position', [0.78 0.15 0.2 0.35], ...
                 'BackgroundColor', [0.7 0.2 0.2], ...
                 'ForegroundColor', 'white', ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'Callback', @saveResults);
        
        % Progress bar
        progressPanel = uipanel('Parent', controlPanel, ...
                               'Units', 'normalized', ...
                               'Position', [0.02 0.05 0.74 0.2], ...
                               'BackgroundColor', [0.9 0.9 0.9], ...
                               'BorderType', 'line');
        
        progressBar = uicontrol('Parent', progressPanel, 'Style', 'text', ...
                               'String', '', ...
                               'Units', 'normalized', ...
                               'Position', [0 0 0 1], ...
                               'BackgroundColor', [0.2 0.7 0.2], ...
                               'Visible', 'off');
        
        statusText = uicontrol('Parent', controlPanel, 'Style', 'text', ...
                              'String', 'Ready to load images...', ...
                              'Units', 'normalized', ...
                              'Position', [0.02 0.3 0.74 0.15], ...
                              'FontSize', 10, ...
                              'HorizontalAlignment', 'left', ...
                              'BackgroundColor', [0.96 0.96 0.98]);
        
        % Image display area with tabs
        imagePanel = uipanel('Parent', mainPanel, 'Title', 'Image Processing Results', ...
                            'Units', 'normalized', ...
                            'Position', [0.01 0.2 0.98 0.49], ...
                            'BackgroundColor', [0.98 0.98 0.98], ...
                            'FontSize', 12, 'FontWeight', 'bold');
        
        % Create tabbed interface for images
        createTabbedImageDisplay(imagePanel);
        
        % Results panel
        resultsPanel = uipanel('Parent', mainPanel, 'Title', 'Processing Diagnostics', ...
                              'Units', 'normalized', ...
                              'Position', [0.01 0.01 0.98 0.23], ...
                              'BackgroundColor', [0.98 0.98 0.98], ...
                              'FontSize', 12, 'FontWeight', 'bold');
        
        createResultsDisplay(resultsPanel);
    end
    
    function createTabbedImageDisplay(parent)
        % Create tab group
        tabGroup = uitabgroup('Parent', parent, ...
                             'Units', 'normalized', ...
                             'Position', [0.01 0.01 0.98 0.95]);
        
        % Store tab handles for later use
        for i = 1:3
            tab = uitab(tabGroup, 'Title', imageNames{i}, ...
                       'BackgroundColor', [0.98 0.98 0.98]);
            
            % Original image axes
            axOriginal = axes('Parent', tab, ...
                             'Units', 'normalized', ...
                             'Position', [0.05 0.15 0.4 0.75], ...
                             'Tag', ['Original' imageNames{i}]);
            title(axOriginal, ['Original ' imageNames{i}], 'FontSize', 11, 'FontWeight', 'bold');
            axis(axOriginal, 'off');
            
            % Processed image axes
            axProcessed = axes('Parent', tab, ...
                              'Units', 'normalized', ...
                              'Position', [0.55 0.15 0.4 0.75], ...
                              'Tag', ['Processed' imageNames{i}]);
            title(axProcessed, ['Processed ' imageNames{i}], 'FontSize', 11, 'FontWeight', 'bold');
            axis(axProcessed, 'off');
        end
    end
    
    function createResultsDisplay(parent)
        % Create scrollable text area for results
        for i = 1:3
            resultPanel = uipanel('Parent', parent, ...
                                 'Title', imageNames{i}, ...
                                 'Units', 'normalized', ...
                                 'Position', [0.02 + (i-1)*0.32 0.05 0.3 0.9], ...
                                 'BackgroundColor', [0.95 0.95 0.97]);
            
            uicontrol('Parent', resultPanel, 'Style', 'text', ...
                     'String', 'No results yet...', ...
                     'Units', 'normalized', ...
                     'Position', [0.05 0.05 0.9 0.9], ...
                     'FontSize', 9, ...
                     'HorizontalAlignment', 'left', ...
                     'BackgroundColor', [0.95 0.95 0.97], ...
                     'Tag', ['DiagText' imageNames{i}]);
        end
    end
    
    function loadImage(imageIndex)
        updateStatus('Loading image...');
        
        [filename, pathname] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tiff', ...
                                         'Image Files (*.png,*.jpg,*.jpeg,*.bmp,*.tiff)'}, ...
                                        ['Select ' imageNames{imageIndex}]);
        if filename ~= 0
            try
                fullpath = fullfile(pathname, filename);
                originalImages{imageIndex} = imread(fullpath);
                
                % Update status indicator
                statusControl = findobj('Tag', ['Status' imageNames{imageIndex}]);
                set(statusControl, 'String', '✓ Loaded', 'ForegroundColor', [0 0.7 0]);
                
                % Display original image
                ax = findobj('Type', 'axes', 'Tag', ['Original' imageNames{imageIndex}]);
                imshow(originalImages{imageIndex}, 'Parent', ax);
                
                updateStatus(['Loaded ' imageNames{imageIndex} ': ' filename]);
                fprintf('Loaded %s: %s\n', imageNames{imageIndex}, filename);
                
            catch ME
                updateStatus(['Error loading image: ' ME.message]);
                msgbox(['Error loading image: ' ME.message], 'Load Error', 'error');
            end
        else
            updateStatus('Image loading cancelled.');
        end
    end
    
    
   function [processedImg, diagnostic] = processImage(img)
        diagnostic = struct();
        
        % Convert to grayscale
        if size(img, 3) == 3
            R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
            if all(R(:) == G(:)) && all(G(:) == B(:))
                diagnostic.colorType = 'Grayscale (3-channel)';
                gray = R;
            else
                diagnostic.colorType = 'Color';
                gray = rgb2gray(img);
            end
        else
            diagnostic.colorType = 'Grayscale (single channel)';
            gray = img;
        end
        
        % Basic diagnostic information
        diagnostic.resolution = sprintf('%dx%d', size(img,2), size(img,1));
        diagnostic.colorDepth = '8-bit grayscale';
        
        % Improved noise detection - more conservative
        noise_types = {};
        meanIntensity = mean(double(gray(:)));
        stdIntensity = std(double(gray(:)));
        
        % More conservative thresholds
        blackPixelRatio = sum(gray(:) < 10) / numel(gray);  
        whitePixelRatio = sum(gray(:) > 245) / numel(gray); 
        
        % Salt and pepper detection - more conservative
        if blackPixelRatio + whitePixelRatio > 0.02  
            noise_types{end+1} = 'salt & pepper';
        end
        
        % Gaussian noise detection based on local variance
        localVar = stdfilt(gray, ones(5,5));
        avgLocalVar = mean(localVar(:));
        if avgLocalVar > 15  
            noise_types{end+1} = 'gaussian';
        end
        
        if isempty(noise_types)
            noise_types{end+1} = 'clean';
        end
        
        diagnostic.noiseTypes = noise_types;
        
        processed_img = gray;
        filter_used = {};
        
        % Step 1: Gentle contrast enhancement (instead of harsh histogram equalization)
        % Use CLAHE (Contrast Limited Adaptive Histogram Equalization)
        processed_img = adapthisteq(processed_img, 'ClipLimit', 0.02, ...
                                   'Distribution', 'uniform', 'NumTiles', [8 8]);
        
        
        % Step 2: Conservative noise reduction only if needed
        if ismember('salt & pepper', noise_types)
            % Use smaller median filter
            processed_img = medfilt2(processed_img, [3 3]);
            filter_used{end+1} = 'Median Filter (3x3)';
        elseif ismember('gaussian', noise_types)
            % Use gentle Gaussian filter instead of mean filter
            h = fspecial('gaussian', [3 3], 0.8);
            processed_img = imfilter(processed_img, h, 'symmetric');
            filter_used{end+1} = 'Gaussian Filter (3x3, σ=0.8)';
        end
        
        % Step 3: Gentle sharpening (instead of aggressive morphological operations)
        % Use unsharp masking with conservative parameters
        processed_img = imsharpen(processed_img, 'Radius', 1, 'Amount', 0.8, 'Threshold', 0.1);
        filter_used{end+1} = 'Unsharp Masking (R=1, A=0.8)';
        
        % Step 4: Optional exposure correction - much more conservative
        % Check if image is too dark or too bright
        if meanIntensity < 80 
            gamma = 0.8;  
            processed_img = imadjust(processed_img, [], [], gamma);
            filter_used{end+1} = sprintf('Gamma Correction (γ=%.1f)', gamma);
        elseif meanIntensity > 180  
            gamma = 1.2;  
            processed_img = imadjust(processed_img, [], [], gamma);
            filter_used{end+1} = sprintf('Gamma Correction (γ=%.1f)', gamma);
        end
        
        % Step 5: Final gentle contrast adjustment
        % Use percentile-based stretching but more conservative
        low_perc = prctile(processed_img(:), 2);   
        high_perc = prctile(processed_img(:), 98); 
        if high_perc > low_perc  
            processed_img = imadjust(processed_img, [low_perc/255, high_perc/255], [0, 1]);
            filter_used{end+1} = 'Contrast Stretching (2%-98%)';
        end
        
        % Calculate quality metrics
        % Sharpness using gradient magnitude
        [Gx, Gy] = gradient(double(gray));
        sharpness_orig = mean(sqrt(Gx.^2 + Gy.^2), 'all');
        
        [Gx_proc, Gy_proc] = gradient(double(processed_img));
        sharpness_processed = mean(sqrt(Gx_proc.^2 + Gy_proc.^2), 'all');
        
        % Contrast
        contrast_orig = std(double(gray(:)));
        contrast_processed = std(double(processed_img(:)));
        
        % SNR approximation
        origSNR = meanIntensity / stdIntensity;
        procMean = mean(double(processed_img(:)));
        procStd = std(double(processed_img(:)));
        procSNR = procMean / procStd;
        
        % Store results
        diagnostic.detectedProblems = noise_types;
        diagnostic.appliedTechniques = filter_used;
        diagnostic.sharpnessImprovement = ((sharpness_processed - sharpness_orig) / sharpness_orig) * 100;
        diagnostic.contrastImprovement = ((contrast_processed - contrast_orig) / contrast_orig) * 100;
        diagnostic.snrImprovement = ((procSNR - origSNR) / origSNR) * 100;
        
        processedImg = processed_img;
    end
    
    % Alternative even more conservative version for very clean images
    function [processedImg, diagnostic] = processImageConservative(img)
        diagnostic = struct();
        
        % Convert to grayscale
        if size(img, 3) == 3
            R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
            if all(R(:) == G(:)) && all(G(:) == B(:))
                diagnostic.colorType = 'Grayscale';
                gray = R;
            else
                diagnostic.colorType = 'Color';
                gray = rgb2gray(img);
            end
        else
            diagnostic.colorType = 'Grayscale';
            gray = img;
        end
        
        diagnostic.resolution = sprintf('%dx%d', size(img,2), size(img,1));
        diagnostic.colorDepth = '8-bit grayscale';
        
        % Minimal processing approach
        processed_img = gray;
        filter_used = {};
        
        % Only apply processing if really needed
        meanIntensity = mean(double(gray(:)));
        stdIntensity = std(double(gray(:)));
        
        % Check if contrast enhancement is needed
        if stdIntensity < 40 
            processed_img = adapthisteq(processed_img, 'ClipLimit', 0.01, 'NumTiles', [4 4]);
            filter_used{end+1} = 'Gentle CLAHE';
        end
        
        % Very gentle sharpening only if image appears soft
        laplacian_var = std2(imfilter(gray, fspecial('laplacian')));
        if laplacian_var < 20 
            processed_img = imsharpen(processed_img, 'Radius', 0.5, 'Amount', 0.3);
            filter_used{end+1} = 'Minimal Sharpening';
        end
        
        diagnostic.detectedProblems = {'minimal processing needed'};
        diagnostic.appliedTechniques = filter_used;
        diagnostic.sharpnessImprovement = 0;
        diagnostic.contrastImprovement = 0;
        diagnostic.snrImprovement = 0;
        
        processedImg = processed_img;
    end

    function processAllImages(~, ~)
        for i = 1:3
            if ~isempty(originalImages{i})
                [processedImages{i}, diagnosticResults{i}] = processImage(originalImages{i});
                
                % Display processed image
                ax = findobj('Type', 'axes', 'Tag', ['Processed' imageNames{i}]);
                if isempty(ax)
                    ax = axes('Parent', findobj('Type', 'uipanel', 'Title', ''), ...
                             'Units', 'normalized', ...
                             'Position', [0.02 + (i-1)*0.32 0.15 0.25 0.25]);
                    title(ax, ['Processed ' imageNames{i}]);
                end
                imshow(processedImages{i}, 'Parent', ax);
                ax.Tag = ['Processed' imageNames{i}];
            end
        end
        
        % Display diagnostic results
        displayDiagnosticResults();
    end
    
    function displayDiagnosticResults()
        % Delete previous diagnostic text
        delete(findall(fig, 'Tag', 'DiagText'));
        
        for i = 1:3
            if ~isempty(diagnosticResults{i})
                diagResult = diagnosticResults{i};
                
                % Compose diagnostic text
                colorStr = sprintf('Color Type: %s', diagResult.colorType);
                if isfield(diagResult, 'appliedTechniques') && ~isempty(diagResult.appliedTechniques)
                    techniqueList = diagResult.appliedTechniques;
                    maxPerLine = 2;
                    techniqueLines = "";
                    for k = 1:maxPerLine:length(techniqueList)
                        endIdx = min(k+maxPerLine-1, length(techniqueList));
                        techniqueLines = techniqueLines + join(techniqueList(k:endIdx), ', ') + newline;
                    end
                    explanation = sprintf('%s\n%s', colorStr, techniqueLines);
                else
                    explanation = sprintf('%s\nNone', colorStr);
                end
                
                % Create text below each image
                xpos = 0.02 + (i-1)*0.32;
                uicontrol('Parent', fig, 'Style', 'text', ...
                          'Units', 'normalized', ...
                          'Position', [xpos, 0.05, 0.25, 0.15], ...
                          'String', explanation, ...
                          'FontSize', 9, ...
                          'HorizontalAlignment', 'left', ...
                          'Tag', 'DiagText');
            end
        end
    end
    
    function saveResults(~, ~)
        % Create output directory
        outputDir = fullfile(pwd, 'ProcessedResults');
        if ~exist(outputDir, 'dir')
            mkdir(outputDir);
        end
        
        % Save processed images
        suffixes = {'A', 'B', 'C'};
        for i = 1:3
            if ~isempty(processedImages{i})
                filename = sprintf('S11159020%s.png', suffixes{i});
                filepath = fullfile(outputDir, filename);
                imwrite(processedImages{i}, filepath);
                fprintf('Saved: %s\n', filename);
            end
        end
        
        % Generate report
        generateReport(outputDir);
        
        msgbox('Results saved successfully!', 'Save Complete', 'help');
    end
    
    function generateReport(outputDir)
        import mlreportgen.dom.*;
        
        % Generate a simple text report
        reportFile = fullfile(outputDir, sprintf('S11159020.docx'));
        doc = Document(reportFile, 'docx');
        
        append(doc, Paragraph('Historical Document Image Processing Report'));
        append(doc, Paragraph(['Student ID: S11159020']));
        append(doc, Paragraph(['Processing Date: ', datestr(now)]));
        append(doc, Paragraph(' '));
        
        for i = 1:3
            if ~isempty(diagnosticResults{i})
                diagResult = diagnosticResults{i};
                append(doc, Paragraph(sprintf('=== %s ===', imageNames{i})));
                append(doc, Paragraph(['Image Type: ', diagResult.colorType]));
                append(doc, Paragraph(['Resolution: ', diagResult.resolution]));
                append(doc, Paragraph(['Color Depth: ', diagResult.colorDepth]));
                append(doc, Paragraph(['Noise Types: ', strjoin(diagResult.noiseTypes, ', ')]));
                
                if isfield(diagResult, 'detectedProblems')
                    append(doc, Paragraph(['Detected Problems: ', strjoin(diagResult.detectedProblems, ', ')]));
                end
                if isfield(diagResult, 'sharpnessImprovement')
                    append(doc, Paragraph(sprintf('Sharpness Improvement: %.2f%%', diagResult.sharpnessImprovement)));
                    append(doc, Paragraph(sprintf('Contrast Improvement: %.2f%%', diagResult.contrastImprovement)));
                    append(doc, Paragraph(sprintf('SNR Improvement: %.2f%%', diagResult.snrImprovement)));
                end
                append(doc, Paragraph(' '));
            end
        end
        
        close(doc);
    end

function updateStatus(message)
        if ~isempty(statusText) && isvalid(statusText)
            set(statusText, 'String', message);
        end
        drawnow;
    end
    
    function updateProgress(fraction)
        if ~isempty(progressBar) && isvalid(progressBar)
            if fraction > 0
                set(progressBar, 'Visible', 'on');
                pos = get(progressBar, 'Position');
                pos(3) = fraction;
                set(progressBar, 'Position', pos);
            else
                set(progressBar, 'Visible', 'off');
            end
        end
        drawnow;
    end
end