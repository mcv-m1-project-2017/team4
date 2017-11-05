addpath(genpath('../../../'));
imgPath = '../../../Datasets/train_2017/train/00.001465.jpg';%'00.004817.jpg';
I = imread(imgPath);

% Test results with different thresholds
lowerBound = 0.97; upperBound = 1;              % Note, if thr = 1 the
                                                % image is left unchanged.
ovrExpThr = linspace(lowerBound, upperBound, 8);
recOperation = '/';

%% Tests in RGB, HSV and YCbCr colorspaces (other parameters left unchanged)

% RGB tests and results
colorSpace = 'RGB';

figure('Name', 'RGB reconstructed');
fprintf('Starting RGB example...\n');

for i = 1:length(ovrExpThr)
    [correctedImg] = highlightReconstruction(I, ovrExpThr(i), ...
        recOperation, colorSpace);
    subplot(2,4,i);
    imshow(correctedImg, []);
    format_str = 'Clip.thr = %.4f\n';
    str = sprintf(format_str, ovrExpThr(i));
    title(str);
end


% HSV tests and results
colorSpace = 'HSV';

figure('Name', 'HSV reconstructed');
fprintf('\n\n');
fprintf('Starting HSV example...\n');

for i = 1:length(ovrExpThr)
    [correctedImg] = highlightReconstruction(I, ovrExpThr(i), ...
        recOperation, colorSpace);
    subplot(2,4,i);
    imshow(correctedImg, []);
    format_str = 'Clip.thr = %.4f\n';
    str = sprintf(format_str, ovrExpThr(i));
    title(str);
end


% YCbCr tests and results

% if type(input) = uint8, then:
% Y is in the range [16, 235], and
% Cb and Cr are in the range [16, 240].

colorSpace = 'YCbCr';

figure('Name', 'YCbCr reconstructed');
fprintf('\n\n');
fprintf('Starting YCbCr example...\n');

for i = 1:length(ovrExpThr)
    [correctedImg] = highlightReconstruction(I, ovrExpThr(i),...
        recOperation, colorSpace);
    subplot(2,4,i);
    imshow(correctedImg, []);
    format_str = 'Clip.thr = %.4f\n';
    str = sprintf(format_str, ovrExpThr(i));
    title(str);
end

figure, imshow(I, []); title('Original Image (Highlights))');