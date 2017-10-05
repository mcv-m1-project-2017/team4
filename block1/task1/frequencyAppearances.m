function [freqAppearanceClass, numCounts] = frequencyAppearances(groundTruth_dir,numClasses)
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

f = dir(groundTruth_dir);                           % List directory's contents.
totalAppearances = zeros(numClasses,1);          % Allocate output vector.
for i=1:size(f,1)
    if f(i).isdir == 0                              % Check that is a txt file.
        if(strcmp(f(i).name(end-2:end), 'txt') == 1)
            fileID = fopen(f(i).name);              % Open file.
            file_content = textscan(fileID, '%s');  % Read contents as cell array.
            % Note {1,1} because there is only one line per file
            lastCharacter = file_content{1,1} (end, 1);
            % Finally convert it to a char to use strcmp and determine the
            % class
            signalType = strjoin(lastCharacter);    % Char as 'A', 'D',...
            
            % Now compare with the class labels and add appearance:
            switch (signalType)
                case 'A'
                    totalAppearances(1) = totalAppearances(1) + 1;
                case 'B'
                    totalAppearances(2) = totalAppearances(2) + 1;
                case 'C'
                    totalAppearances(3) = totalAppearances(3) + 1;
                case 'D'
                    totalAppearances(4) = totalAppearances(4) + 1;
                case 'E'
                    totalAppearances(5) = totalAppearances(5) + 1;
                case 'F'
                    totalAppearances(6) = totalAppearances(6) + 1;
                otherwise
                    fprintf('Unexpected class, appearance not counted\n');
            end
        end
    end
    
end

%% Compute frequency of appearance with respect to the total # of examples
% Compute the relative frequency of appearance after checking that the nº
% of total counts has been correctly computed.
numExamples = size(f,1) - 2;                  % Subtract '.' and '..' folders
numCounts = sum(totalAppearances);
if (numExamples == numCounts)
    freqAppearanceClass = totalAppearances./numExamples;
else
    fprintf('Error: the number of theoretical files/examples and the total count do not match\n');
    fprintf('This error may have caused by some corrupted txt file with an unvalid class label\n');
end

end