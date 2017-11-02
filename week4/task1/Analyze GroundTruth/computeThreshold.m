function [ circularCorr, upTriangCorr,downTriangCorr,rectCorr,corrValues,categories] = computeThreshold(datasetPath)
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
output: - circularCorr, upTriangCorr,downTriangCorr,rectCorr: ground thruth
correlation values
type
---------------------------
%}

load('templateModels.mat');

    %%Evaluate the image histogram for every signal
    files = dir(strcat(datasetPath,'/*.jpg'));
    nFiles = size(files,1);
    trafficSignType = cell(1,1);
    circularCorr = [];
    upTriangCorr = [];
    downTriangCorr = [];
    rectCorr= [];
    corrValues = [];
    categories  = {};

    
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

            %Acummulate correlation values by signal type
            if (strcmp(trafficSignType{1},'A')==1)
                corrResult = applyTemplateMask (img, mask, BB,upTriangModel);
                upTriangCorr = [upTriangCorr corrResult];
            elseif strcmp(trafficSignType{1},'B')==1
                corrResult = applyTemplateMask (img, mask, BB,downTriangModel);
                downTriangCorr = [downTriangCorr corrResult];
            elseif (strcmp(trafficSignType{1},'C')==1)|| (strcmp(trafficSignType{1},'D')==1||(strcmp(trafficSignType{1},'E')==1))
                corrResult = applyTemplateMask (img, mask, BB,circularModel);
                circularCorr = [circularCorr corrResult];
            elseif strcmp(trafficSignType{1},'F')==1
                corrResult = applyTemplateMask (img, mask, BB,rectModel);
                rectCorr = [rectCorr corrResult];
            end
            
            %Acummulate correlation values by signal type
            if (strcmp(trafficSignType{1},'A')==1)
                corrResult = applyTemplateMask (img, mask, BB,upTriangModel);
                categories{length(categories)+1} = 'Up Triangular Signal';
            elseif strcmp(trafficSignType{1},'B')==1
                corrResult = applyTemplateMask (img, mask, BB,downTriangModel);
                categories{length(categories)+1} = 'Down Triangular Signal';
            elseif (strcmp(trafficSignType{1},'C')==1)|| (strcmp(trafficSignType{1},'D')==1||(strcmp(trafficSignType{1},'E')==1))
                corrResult = applyTemplateMask (img, mask, BB,circularModel);
                categories{length(categories)+1} = 'Circular Signal';
            elseif strcmp(trafficSignType{1},'F')==1
                corrResult = applyTemplateMask (img, mask, BB,rectModel);
                categories{length(categories)+1} = 'Rectangular Signal';
            end
            corrValues = [corrValues corrResult];
            %REad next file type
            imgData = fgetl(fid);
        end
        fclose(fid);
    end

end
