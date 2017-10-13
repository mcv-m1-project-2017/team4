function [ histogramModels] = generateHistogramModel(datasetPath)
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
    nBins = 20;
    files = dir(strcat(datasetPath,'/*.jpg'));
    nFiles = size(files,1);
    trafficSignType = cell(1,1);
    histogramsModels = zeros(nBins,6);
    nSignals = zeros(6,1); % Amount of signals type A, B, C, D, E, F 

    for i=1:nFiles
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
            trafficSignType{1} = imgData{5};
            colorHistogram = imageDescriptors (img, mask, BB,nBins);
            
            %Acummulate color histogram by signal type
            if strcmp(trafficSignType{1},'A')==1
                histogramsModels(:,1) = histogramsModels(:,1) + colorHistogram;
                nSignals(1) = nSignals(1)+ 1;
            elseif strcmp(trafficSignType{1},'B')==1
                histogramsModels(:,2) = histogramsModels(:,2) + colorHistogram;
                nSignals(2) = nSignals(2)+ 1;
            elseif strcmp(trafficSignType{1},'C')==1
                histogramsModels(:,3) = histogramsModels(:,3) + colorHistogram;
                nSignals(3) = nSignals(3)+ 1;
            elseif strcmp(trafficSignType{1},'D')==1
                histogramsModels(:,4) = histogramsModels(:,4) + colorHistogram;
                nSignals(4) = nSignals(4)+ 1;
            elseif strcmp(trafficSignType{1},'E')==1
                histogramsModels(:,5) = histogramsModels(:,5) + colorHistogram;
                nSignals(5) = nSignals(5)+ 1;
            elseif strcmp(trafficSignType{1},'F')==1
                histogramsModels(:,6) = histogramsModels(:,6) + colorHistogram;
                nSignals(6) = nSignals(6)+ 1;
            end
            
            %REad next file type
            imgData = fgetl(fid);
        end
        fclose(fid);
    end
    
    
    %Histogram normalization
    for i=1:6
        histogramsModels(:,i) = histogramsModels(:,i)/nSignals(i);
    end

end