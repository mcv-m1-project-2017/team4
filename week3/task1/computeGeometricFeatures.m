%% Script to compute the training set geometric features of each instance
% 
% Jonatan Poveda
% Martí Cobos
% Juan Francesc Serracant
% Ferran Pérez
% Master in Computer Vision
% Computer Vision Center, Barcelona
% ---------------------------
% Project M1/Block3
% ---------------------------
% 
% These features are: mask area, filling factor and aspect ratio/form
% factor.
% For area and form factor, the instance to which the instance belong is
% not considered. Alternatively, for the filling factor (as it is a very
% distinctive factor to filter by shape), the classes are treated
% separately.
% For each vector/matrix of features (3 separate arrays), the minimum,
% maximum, mean and std value are computed. Finally, all this information
% is stored in a MAT file that should be loaded by the function that
% selects the thresholds based on such values.

addpath(genpath('../../../'));
train_masks = '../../../datasets/trafficsigns/train/';
f = dir([train_masks, '/*.jpg']);
numClasses = 6;
areaStats = [];
fillRatioStats = [];
formFactorStats = [];
BBboxes = [];
labelVector = [];
countInstances = zeros(numClasses,1);
for i=1:size(f,1)
    if f(i).isdir == 0
        % 1) Compute connected components and their area and aspect ratio
        % Compute area, filling factor and aspect ratio
        % Read mask
        mask = imread(['mask/mask.', strrep(f(i).name, 'jpg', 'png')]);
        % Fix wrong formatted masks (with values diff. than 0 and 1)
        mask(mask>0) = 1;
        % CANNOT DO THIS BECAUSE SOME GT MASKS OVERLAP OTHERS==> diff nº of
        % CC and instances of signals in the txt file. Instead use solely
        % the text file (SEE BELOW). In fact masks contain each separate
        % object with different value (1, 2,3...) but some of them have 2
        % objects and values 1 and 4 instead of 1, 2...(easier to read txt
        % files)
%         % Compute connected components
%         maskCC = bwconncomp(mask);
%         % Compute 'Area' and 'BoundingBox' of CC
%         CC_props = regionprops(maskCC, 'Area', 'BoundingBox');
% 
%         % Store the area of all CC for this image in the vector
%         areaStats = [areaStats; [CC_props.Area]'];
%         
%         % Compute aspect ratio/form factor
%         BBs = vertcat(CC_props.BoundingBox);
%         % BB(:,3)-> width, BB(:,4) -> height (all BBs in img)
%         areasBB = BBs(:,3).*BBs(:,4);
%         formFactorStats = [formFactorStats; BBs(:,3)./BBs(:,4)];
%         % Compute filling factor with mask area/BB area 
%         fillRatioStats = [fillRatioStats; [CC_props.Area]'./areasBB];
        
        % 2) Read txt, get class, update counter and create a label vector
        % by writing down the number of class so we can remap filling
        % factor values to each class (actually 3 groups, see below).
        fileID = fopen(['gt/gt.', strrep(f(i).name, 'jpg', 'txt')]);
        lineRead = fgetl(fileID);
        while(lineRead > 0)                   % there are more lines to read
                lineParts = strsplit(lineRead);
                TopLeftY = str2double(lineParts{1});
                TopLeftX = str2double(lineParts{2});
                BottomRightY = str2double(lineParts{3});
                BottomRightX = str2double(lineParts{4});
                
                BB_height = BottomRightY - TopLeftY;
                BB_width = BottomRightX - TopLeftX;
                
                formFactorStats = [formFactorStats; BB_width/BB_height];
                % Create a tmp crop of the mask inside the bounding box
                % and compute area and then filling ratio
                tmpCrop_msk = imcrop(mask, [TopLeftX, TopLeftY, BB_width, BB_height]);
                mskArea = sum(tmpCrop_msk(:));
                areaStats = [areaStats; sum(tmpCrop_msk(:))];
                
                fillRatioStats = [fillRatioStats; mskArea/(BB_width*BB_height)];
                
                signalType = lineParts{end};   % Get signal type.
                indexType = signalType - 64;
                if(indexType < 1 || indexType > numClasses)
                    fprintf('Invalid class label (negative or out of bounds)\n');
                    % Read next line (if there is one)
                    continue;
                else
                    % Generate label vector to map back the fill ratio for
                    % each class (use numbers instead of the letters).
                    countInstances(indexType) = countInstances(indexType)+1;
                    labelVector = [labelVector; indexType];
                    
                end
                 % Try to line next line
                lineRead = fgetl(fileID);
        end
    end
end
% Remap filling factor values to 3 different vectors (regarding size)
% before computing max, min, mean and std.
% 1st group ==> A, B (triangular signals)
% 2nd group ==> C, D, E (circular signals)
% 3rd group ==> F (rectangular/square signals)

triang_idx = find(labelVector == 1 | labelVector == 2);
circ_idx = find(labelVector == 3 | labelVector == 4 | labelVector == 5);
rect_idx = find(labelVector == 6);

triangularSignals_FR = fillRatioStats(triang_idx);
circularSignals_FR = fillRatioStats(circ_idx);
rectangularSignals_FR = fillRatioStats(rect_idx);

% Compute max, min, mean and std of each feature that will be added to a
% column vector with the following contents per row:
% geometricFeatures(1):         min(signalArea)
% geometricFeatures(2):         max(signalArea)
% geometricFeatures(3):         mean(signalArea)
% geometricFeatures(4):         std(signalArea)
% geometricFeatures(5):         min(formFactor)
% geometricFeatures(6):         max(formFactor)
% geometricFeatures(7):         mean(formFactor)
% geometricFeatures(8):         std(formFactor)
% geometricFeatures(9):         min(fillingRatio triangular)
% geometricFeatures(10):        max(fillingRatio triangular)
% geometricFeatures(11):        mean(fillingRatio triangular)
% geometricFeatures(12):        std(fillingRatio triangular)
% geometricFeatures(13):        min(fillingRatio circular)
% geometricFeatures(14):        max(fillingRatio circular)
% geometricFeatures(15):        mean(fillingRatio circular)
% geometricFeatures(16):        std(fillingRatio circular)
% geometricFeatures(17):        min(fillingRatio rectangular)
% geometricFeatures(18):        max(fillingRatio rectangular)
% geometricFeatures(19):        mean(fillingRatio rectangular)
% geometricFeatures(20):        std(fillingRatio rectangular)

geometricFeatures = [min(areaStats); max(areaStats); mean(areaStats);...
    std(areaStats); min(formFactorStats); max(formFactorStats);...
    mean(formFactorStats); std(formFactorStats); min(triangularSignals_FR);...
    max(triangularSignals_FR); mean(triangularSignals_FR); ...
    std(triangularSignals_FR); min(circularSignals_FR); ...
    max(circularSignals_FR); mean(circularSignals_FR); ...
    std(circularSignals_FR); min(rectangularSignals_FR); ...
    max(rectangularSignals_FR); mean(rectangularSignals_FR); ...
    std(rectangularSignals_FR)];
    
% Store matrix with geometric features in a .mat file
save('GeometricFeatures_train.mat', 'geometricFeatures');