function [ aHistogramsModels,bHistogramsModels] = generateHistogramModel(datasetPath, nBins)
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Block2
---------------------------
This function is used to generate the histogram back projection model.
input:  - datasetPath: the input path containing validation images      
output: - histogramModels: histogram back projection model for each sign
type
---------------------------
%}

    %%Evaluate the image histogram for every signal
    files = dir(strcat(datasetPath,'/*.jpg'));
    nFiles = size(files,1);
    trafficSignType = cell(1,1);
    aHistogramsModels = zeros(3,nBins);
    bHistogramsModels = zeros(3,nBins);
    nSignals = zeros(3,1); % Amount of signals type (A, B& C), (D&F) & E

    for i=1:nFiles
        fprintf('----------------------------------------------------\n');
        fprintf('analysing image number  %d', i);
        imageName = files(i).name(1:end-4)
        img = imread(strcat(datasetPath,'/', imageName,'.jpg'));
        mask = imread(strcat(datasetPath,'/mask/mask.', imageName,'.png'));
        fid = fopen(strcat(datasetPath,'/gt/gt.', imageName,'.txt'));
        imgData = fgetl(fid);
        while (ischar(imgData))
            imgData = strsplit(imgData);
            BB = [str2double(imgData{1}) str2double(imgData{2}) str2double(imgData{3}) str2double(imgData{4})];
            trafficSignType{1} = imgData{5};
            [aColorHistogram, bColorHistogram] = calculateHistogram (img, mask, BB,nBins);
            
            %Acummulate color histogram by signal type
            if (strcmp(trafficSignType{1},'A')==1)|| (strcmp(trafficSignType{1},'B')==1) ||(strcmp(trafficSignType{1},'C')==1)
                aHistogramsModels(1,:) = aHistogramsModels(1,:) + aColorHistogram;
                bHistogramsModels(1,:) = bHistogramsModels(1,:) + bColorHistogram;
                nSignals(1) = nSignals(1)+ 1;
            elseif (strcmp(trafficSignType{1},'D')==1)|| (strcmp(trafficSignType{1},'F')==1)
                aHistogramsModels(2,:) = aHistogramsModels(2,:) + aColorHistogram;
                bHistogramsModels(2,:) = bHistogramsModels(2,:) + bColorHistogram;
                nSignals(2) = nSignals(2)+ 1;
            elseif strcmp(trafficSignType{1},'E')==1
                aHistogramsModels(3,:) = aHistogramsModels(3,:) + aColorHistogram;
                bHistogramsModels(3,:) = bHistogramsModels(3,:) + bColorHistogram;
                nSignals(3) = nSignals(3)+ 1;
            end
            
            %REad next file type
            imgData = fgetl(fid);
        end
        fclose(fid);
    end
    
    
    %Histogram normalization
    for i=1:3
        aHistogramsModels(:,i) = aHistogramsModels(:,i)/nSignals(i);
        bHistogramsModels(:,i) = bHistogramsModels(:,i)/nSignals(i);
    end

end