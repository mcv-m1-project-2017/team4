function [freqAppearanceClass, numCounts] = frequencyAppearances(groundTruth_dir, numClasses)
% COUNTCLASSAPPEARANCES Count the number of items in each class (e.g.:
% signal type)
%   Iterate over the Ground Truth (gt) text files to obtain the class
%   label and count the number of examples for each class. Once we have
%   the total number of items per class, we can compute the frequency of
%   appearance as: n_occurencesClass#/n_total_items.
%
%   Input parameters:
%       - groundTruth_dir:          directory where the gt txt files are
%                               stored. By default: '../Datasets/train_2017/train/gt'
%       - numClasses:               number of classes. E.g.: in the signals
%                                   example, numClasses=6 (signals from A-F).
%
%   Output parameters:
%       - freqAppearanceClass:   frequency of appearance of all clases
%                                   stored in a vector (for easier generali-
%                                   zation and operation).
%       - totalAppearances:      outputted to compute nº of counts per
%                                   class (if needed)

%% Read txt files from folder and count appearances per class

f = dir([groundTruth_dir, '/*.txt']);            % List directory's contents.
numExamples = size(f,1);
totalAppearances = zeros(numClasses,1);          % Allocate output vector.
for i=1:numExamples
    if f(i).isdir == 0                              % Check that is a txt file.
        if(strcmp(f(i).name(end-2:end), 'txt') == 1)
            fileID = fopen(f(i).name);              % Open file.
            lineRead = fgetl(fileID);               % Read line (only content).
            % Check if there are more lines to read:
            while(lineRead > 0)           % there are more lines to read
                signalType = lineRead(end);                % Get signal type.
                indexType = signalType - 64;
                if(indexType < 1 || indexType > numClasses)
                    fprintf('Invalid class label (negative or out of bounds)\n');
                    continue;
                else
                    totalAppearances(indexType) = totalAppearances(indexType) + 1;
                end
                % Try to line next line
                lineRead = fgetl(fileID);
            end
        end
    end
end

%% Compute frequency of appearance with respect to the total # of examples
% Compute the relative frequency of appearance
numCounts = sum(totalAppearances);
freqAppearanceClass = totalAppearances./numCounts;
end