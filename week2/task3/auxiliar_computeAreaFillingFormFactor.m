%% Test script to measure area, fillratio and formfactor train_old dataset
% And then compute max, min, mean and std of those values. Store this in
% .mat file
% NOTE: we will not distinguish among signal classes, we should compute for
% each feature in week1/task1 the max, min, mean and std for future weeks
% (accounting by class).

addpath(genpath('../../../'));
trainold_masks = '../../../datasets/trafficsigns/train_old/';
f = dir([trainold_masks, '/*.jpg']);
areaMask = [];
fillRatioVec = [];
formFactorVec = [];
for i=1:size(f,1)
    if f(i).isdir == 0 
        
        % Get mask to compute CC's area
        % Read mask, get CC's area and store it in an array.
        mask = imread(['mask/mask.', strrep(f(i).name, 'jpg', 'png')]);
        % Fix wrong formatted masks (with values diff. than 0 and 1)
        mask(mask>0) = 1;
        % Need to use 'bwconncomp' to avoid considering different signals as
        % one (occurs when calling 'regionprops' directly.
        maskCC = bwconncomp(mask);
        CC_props = regionprops(maskCC,'Area', 'BoundingBox');
        areaMask = [areaMask; [CC_props.Area]'];
        
        % Get filling ratio and form factor from regionprops bounding box
        % (ideally we would use the .txt labels but it is far slower and
        % probably even less accurate.
        % In region props the width and height of the bounding box are
        % stored in the 3rd and 4th position, respectively.
        BBs = vertcat(CC_props.BoundingBox);
        areasBB = BBs(:,3).*BBs(:,4);
        
        fillRatioVec = [fillRatioVec; (areasBB./[CC_props.Area]')];
        formFactorVec = [formFactorVec; BBs(:,3)./BBs(:,4)];
    end
end

% Max, min, mean and std of Area
fillFormArea_stats = [max(areaMask), min(areaMask), mean(areaMask), std(areaMask),...
    max(fillRatioVec), min(fillRatioVec), mean(fillRatioVec), std(fillRatioVec),...
    max(formFactorVec), min(formFactorVec), mean(formFactorVec), std(formFactorVec)];
save('AreaFillingFormFactor_trainingOld.mat', 'fillFormArea_stats');