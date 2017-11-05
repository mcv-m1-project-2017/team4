
clear all
%%function to evaluate all images and obtain all characteristics
imagePath = '..\..\..\train\';
nDescriptors = 18;

files = dir(strcat(imagePath,'/*.jpg'));
nSigns = size(files,1);
signalGroup = cell(1,1);
imageCharacteristics = zeros(1,nDescriptors);

for i=1:nSigns
    i
    imageName = files(i).name(1:end-4)
    img = imread(strcat(imagePath, imageName,'.jpg'));
    mask = imread(strcat(imagePath,'mask\mask.', imageName,'.png'));
    fid = fopen(strcat(imagePath,'gt\gt.', imageName,'.txt'));
    while ~(feof(fid))
        imgData = fgetl(fid);
        imgData = strsplit(imgData);
        BB = [str2double(imgData{1}) str2double(imgData{2}) str2double(imgData{3}) str2double(imgData{4})];
        signalGroup{i} = imgData{5};
        descriptors = imageDescriptors (img, mask, BB);
        imageCharacteristics(i,:)= descriptors;
    end
    fclose(fid);
end

[nImages nChars] = size(imageCharacteristics)
group = zeros(nImages,1);
for i = 1:nImages
    if strcmp(signalGroup{i},'A')==1
        group(i) = 1;
    elseif strcmp(signalGroup{i},'B')==1
        group(i) = 2;
    elseif strcmp(signalGroup{i},'C')==1
        group(i) = 3;
    elseif strcmp(signalGroup{i},'D')==1
        group(i) = 4;
    elseif strcmp(signalGroup{i},'E')==1
        group(i) = 5;
    elseif strcmp(signalGroup{i},'F')==1
        group(i) = 6;
    end

end

for i=1:nChars
    figure()
    data = imageCharacteristics(:,i);
    histogram(data(group ==1));
    hold on;
    histogram(data(group ==2));
    histogram(data(group ==3));
    histogram(data(group ==4));
    histogram(data(group ==5));
    histogram(data(group ==6));
end