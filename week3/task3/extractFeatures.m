function [ freqAppearanceClass,trafficSignType, vectorFeatures, maxMinResults] = extractFeatures(datasetPath)

    %%evaluate all images and obtain all characteristics for every signal
    nDescriptors = 18;

    files = dir(strcat(datasetPath,'/*.jpg'));
    nSigns = size(files,1);
    trafficSignType = cell(1,1);
    vectorFeatures = zeros(1,nDescriptors);
    count = 1;

    for i=1:nSigns
        fprintf('----------------------------------------------------\n');
        fprintf('analysing image number  %d', i);
        imageName = files(i).name(1:end-4)
        img = imread(strcat(datasetPath, imageName,'.jpg'));
        mask = imread(strcat(datasetPath,'mask/mask.', imageName,'.png'));
        fid = fopen(strcat(datasetPath,'gt/gt.', imageName,'.txt'));
        imgData = fgetl(fid);
        while (ischar(imgData))
            imgData = strsplit(imgData);
            BB = [str2double(imgData{1}) str2double(imgData{2}) str2double(imgData{3}) str2double(imgData{4})];
            trafficSignType{count} = imgData{5};
            descriptors = imageDescriptors (img, mask, BB);
            vectorFeatures(count,:)= descriptors;
            imgData = fgetl(fid);
            count = count+1;
        end
        fclose(fid);
    end
    
        %represent all characteristics on histograms grouped by signal type
    [nImages nChars] = size(vectorFeatures);
    group = zeros(nImages,1);
    for i = 1:nImages
        if strcmp(trafficSignType{i},'A')==1
            group(i) = 1;
        elseif strcmp(trafficSignType{i},'B')==1
            group(i) = 2;
        elseif strcmp(trafficSignType{i},'C')==1
            group(i) = 3;
        elseif strcmp(trafficSignType{i},'D')==1
            group(i) = 4;
        elseif strcmp(trafficSignType{i},'E')==1
            group(i) = 5;
        elseif strcmp(trafficSignType{i},'F')==1
            group(i) = 6;
        end

    end

    [value, index] = min(vectorFeatures(group == 1,13:14))
    [value, index] = min(vectorFeatures(group == 2,13:14))
    [value, index] = min(vectorFeatures(group == 3,13:14))
    [value, index] = min(vectorFeatures(group == 4,13:14))
    [value, index] = min(vectorFeatures(group == 5,13:14))
    [value, index] = min(vectorFeatures(group == 6,13:14))
    
    [value, index] = max(vectorFeatures(group == 1,13:14))
    [value, index] = max(vectorFeatures(group == 2,13:14))
    [value, index] = max(vectorFeatures(group == 3,13:14))
    [value, index] = max(vectorFeatures(group == 4,13:14))
    [value, index] = max(vectorFeatures(group == 5,13:14))
    [value, index] = max(vectorFeatures(group == 6,13:14))
end