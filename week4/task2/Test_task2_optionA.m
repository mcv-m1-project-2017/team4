% Script to test task 2 option a (without k-means)
% Task 2: Template matching using Distance Transform and chamfer distance
% do_plots = true;

numTemplates = 4;   % Up/down triangle, rectangle and circle
numScales = 3;      % Number of scales at which templates are "passed"
scales = [50, 70, 90];                    % through the image
threshold = 0.90;

load('formModels.mat')

dataset = 'validation';
% Add repository functions to path
addpath(genpath('../../../'));

root = '../../../';
% Set paths
% inputMasksPath = fullfile(root, 'm1-results', 'week3', 'm1', dataset);
inputMasksPath = fullfile(root, 'm1-results', 'week3', dataset,'method1');
% groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', 'split', dataset, 'mask');
groundThruthPath = fullfile(root, 'datasets', 'trafficsigns', dataset, 'mask');
tmpPath =  fullfile(root, 'datasets', 'trafficsigns', 'tmp', dataset);
mkdir(tmpPath)

resultFolder = fullfile(root, 'm1-results', 'week4', 'task2a', dataset);

% Get all the files
inputMasks = dir(fullfile(inputMasksPath, '*.png'));
gtMasks = dir(fullfile(groundThruthPath, '*.png'));

processingTime = [];
% for i = 1:size(inputMasks,1)
for i = 1:size(inputMasks,1)
    fprintf('Checking mask %d out of %d\n', i, size(inputMasks,1));
    inputMaskObject = inputMasks(i);
    inputMaskPath = fullfile(inputMasksPath, inputMaskObject.name);
    inMask = imread(inputMaskPath);
    
    gtMaskObject = gtMasks(i);
    gtMaskPath = fullfile(groundThruthPath, gtMaskObject.name);
    gtMask = imread(gtMaskPath);
    % Convert it to logical (faster)
    gtMask = gtMask > 0;
    
    % DO ALL THE MAGIC HERE
    %   iMask = zeros(400,400);
    %   iMask(50:149, 100:199)=1;
    %   iMask(200:299, 200:299)=1;
    %   iMask(170:190, 100:119)=1;
    %   iMask(220:279 , 50:109)=1;
    %   featureMask = edge(iMask,'Canny');
    %   template = ones(100,100);
    %   template([1,end],:)=0; template(:,[1,end])=0;
    tic;
    featureMask = edge(inMask, 'Canny');
    
    
    outMask = [];
    for t = 1:numTemplates
        for s = 1:numScales
            switch t
                case 1 % Circ
                    template = imresize(circularModel, [scales(s), scales(s)]);
                    template = edge(template, 'Canny')+0;
                case 2 % Rect
                    template = imresize(rectModel, [scales(s), scales(s)]);
                    template = edge(template, 'Canny')+0;
                case 3 % Up-triangle
                    template = imresize(upTriangModel, [scales(s), scales(s)]);
                    template = edge(template, 'Canny')+0;
                case 4 % Down-triangle
                    template = imresize(downTriangModel, [scales(s), scales(s)]);
                    template = edge(template, 'Canny')+0;
                otherwise
                    error('Fatal error!');
            end
            %             template = edge(template, 'Canny')+0;
            %   correlated = xcorr2(template, transformedMask);
            paddedMask = padarray(featureMask, size(template)/2, 0, 'both');
            transformedMask = distanceTransform(paddedMask);
            correlated = xcorr2(transformedMask, template);
            %correlated = normxcorr2(template, transformedMask);
            border = size(template,1);
            correlated = correlated(border:(end-border), border:(end-border));
            correlated = correlated./max(correlated(:));
            c = correlated;
            if (isnan(correlated) | isnan(c))
                outMask = inMask;
                break;
            end
            
            %c = ind2rgb(c, jet(256));
            %1-correlated;
            %c = c > 0.9;
            %cor(cor<0.01)=255;
            %cor = int16(cor);
            %c = c*255;
            %             min(c(:)), max(c(:))
            %se = ones(3);
            %   se = strel('disk',3);
            %se = ones(3,1);
            % se = [0 1 0;
            %       1 1 1;
            %       0 1 0];
            se = ones(1,3);
            %             betterC = imbothat(c, se);
            %             betterC = imtophat(betterC, se');
            %             betterC = betterC ./ max(betterC);
            %             min(betterC(:)), max(betterC(:))
            
            bestC = c;
            positions = extractLocalMinima(bestC, threshold);
            % MAGIC CODE GOES HERE
            tmpOutMask = computeResultingMask(positions, inMask);
            % Compute or with the previous temporal mask
            if (t == 1 && s == 1) % First iteration per image
                outMask = tmpOutMask;
            else
                outMask = outMask | tmpOutMask;
            end
            %
            betterC = c;
            % 'Symmetric' image of im inside the extractLocalMinima
            % function (this plots 'supposed signals' as white instead of
            % black)
            c(betterC < 1 - threshold) = 1;
            %   % for i = 1:size(positions, 1)
            %   %
            %   % end % for
            %   % %c(c==min(c(:)))=256;
            %   %[min(c(:)),   max(c(:))]
            %
            %   % Save mask
            %   % oMaskPath = fullfile(tmpPath, inputMaskObject.name);
            %   % sprintf('Writing in %s', oMaskPath)
            %   % oMask = iMask & ~cancellingMask;
            %   % imwrite(oMask, oMaskPath);
            %
            %   % Save regions
            %   % name = strsplit(inputMaskObject.name, '.png');
            %   % name = name{1};
            %   % region_path = fullfile(tmpPath, strcat(name, '.mat'));
            %   % save(region_path, 'regionProposal');
            %
            %   if do_plots
            %     figure(1)
            % %     figure('Name',sprintf('Mask %d', i));
            %     % Show input mask
            %     subplot(2,3,1);
            %     imshow(featureMask,[]);
            %     title('Feature mask');
            %
            %     % Show transformed
            %     subplot(2,3,2);
            %     imshow(transformedMask,[]);
            %     title('distance mask');
            %     %plot = falseXx
            %
            %     % Show output mask
            %     subplot(2,3,3);
            %     imshow(template,[]);
            %     title('template');
            %     axis([1, size(featureMask,1), 1, size(featureMask,2)]);
            %
            %     % Show ground truth mask
            %     subplot(2,3,4);
            %     imshow(gtMask,[]);
            %     title('GroundTruth mask');
            %
            %     % Show ground truth mask
            %     subplot(2,3,5);
            %     imshow(correlated,[]);
            %     title('correlated mask');
            %
            %     % Show ground truth mask
            %     subplot(2,3,6);
            %     imshow(c*256,hsv(256));
            %     title('cor mask');
            %
            %     figure(2), subplot(2,1,1), imshow(c, []);
            %     subplot(2,1,2), imshow(betterC, []);
            %
            %   end
        end
    end
    % Compute windowCandidates from  final masks and store masks
    processingTime = [processingTime; toc];
    [CC, CC_stats] = computeCC_regionProps(outMask);
    windowCandidates = createListOfWindows(CC_stats);
    
    if (exist(resultFolder, 'dir') == 0)
        % Create folder
        status = mkdir(resultFolder);
        if (status == 0)
            error('Could not create directory ''%s''\n', resultFolder);
        end
    end
    
    save(strcat(resultFolder, '/',...
        inputMaskObject.name(1:size(inputMaskObject.name,2)-3), 'mat'),...
        'windowCandidates');
    imwrite(outMask,strcat(resultFolder, '/',...
        inputMaskObject.name));
end