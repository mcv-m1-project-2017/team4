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

    for i=1:nChars
        if (i == 15|| i == 16 || i ==18)
            if (i==15)
                counts = linspace(0.5,2.5,10);
            elseif (i==16)
                counts = linspace(0,60000,10);
            elseif (i ==18)
                counts = linspace(0.4,1,20);
            end
            figure()
            data = vectorFeatures(:,i);
            histogram(data(group ==1),counts);
            hold on;
            histogram(data(group ==2),counts);
            histogram(data(group ==3),counts);
            histogram(data(group ==4),counts);
            histogram(data(group ==5),counts);
            histogram(data(group ==6),counts);
        end
    end
    
    %Compute max and min of size, form factor and filling ratio for every signal type
    % the results are stored in a 6*6 matrix where the columns are maxSize,
    % minSize, minFormFactor, maxFormFactor, minFillingRatio, maxFillingRatio the
    %columns are the signal group (A,B,C,D,E,F)
    
    maxMinResults = zeros(6);
    
    for i = 1:6
        
        maxMinResults(1,i) = max(vectorFeatures(group == i,16))/1000;
        maxMinResults(2,i) = min(vectorFeatures(group == i,16))/1000;
        maxMinResults(3,i) = max(vectorFeatures(group == i,15));
        maxMinResults(4,i) = min(vectorFeatures(group == i,15));
        maxMinResults(5,i) = max(vectorFeatures(group == i,18));
        maxMinResults(6,i) = min(vectorFeatures(group == i,18));
    end
    fprintf('----------------------------------------------------\n');
    fprintf('Maximum and minimum values of size, form factor and filling ratio grouped:');
    maxMinResults
    
    % obtain frequencies for each signal type on dataset
    numClasses = 6;
    groundTruth_directory = strcat(datasetPath,'gt/');
    f = dir(strcat(groundTruth_directory,'/*.txt'));
    numExamples = size(f,1);


    [freqAppearanceClass, numCounts] = frequencyAppearances(groundTruth_directory, ...
        numClasses);

    fprintf('----------------------------------------------------\n');
    for i = 1:numClasses
        fprintf('Class number  %d (%s): %.4f - %.2f %%\n', i, char(i+64), freqAppearanceClass(i),...
            freqAppearanceClass(i)*100);
    end

    fprintf('----------------------------------------------------\n');
    fprintf('Num. examples: %d | %.4f - %.2f %%\n', numCounts, sum(freqAppearanceClass), ...
        sum(freqAppearanceClass)*100);
    fprintf('Computed for a dataset of %d images\n', numExamples);

end