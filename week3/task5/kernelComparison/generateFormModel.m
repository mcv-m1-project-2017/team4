function [ circularModel, upTriangModel,downTriangModel,rectModel] = generateFormModel(datasetPath, nBins)
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
    circularModel = zeros(40,40);
    upTriangModel = zeros(40,40);
    downTriangModel = zeros(40,40);
    rectModel= zeros(40,40);
    nCircular = 0;
    nUpTriang = 0;
    nDownTriang = 0;
    nRect = 0;
    
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
            [formModel] = calculateModel (img, mask, BB,nBins);

            %Acummulate color histogram by signal type
            if (strcmp(trafficSignType{1},'A')==1)
                upTriangModel = upTriangModel+ double(formModel);
                nUpTriang = nUpTriang +1 ;
            elseif strcmp(trafficSignType{1},'B')==1
                downTriangModel = downTriangModel + double(formModel);
                nDownTriang = nDownTriang +1;
            elseif (strcmp(trafficSignType{1},'C')==1)|| (strcmp(trafficSignType{1},'D')==1||(strcmp(trafficSignType{1},'E')==1))
                circularModel = circularModel + double(formModel);
                nCircular = nCircular +1;
            elseif strcmp(trafficSignType{1},'F')==1
                rectModel = rectModel  + double(formModel);
                nRect = nRect +1 ;
            end

            %REad next file type
            imgData = fgetl(fid);
        end
        fclose(fid);
    end

%model normalizaion
    upTriangModel = upTriangModel ./nUpTriang;
    downTriangModel = downTriangModel./nDownTriang;
    circularModel = circularModel./nCircular;
    rectModel= rectModel./nRect;
end
