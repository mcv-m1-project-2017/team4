cd% Set path to code
addpath(genpath('.'))
% Set path to external code
addpath('../:../evaluation/')

if (is_octave())
  disp('Octave detected. Loading packages..')
  pkg load image # octave-command
end  

global dataset_path
root = fileparts(fileparts(fileparts(pwd)))
dataset_path = fullfile(root, 'datasets', 'trafficsigns')
% The dataset folder is on the following path:
% home/mcv04/datasets/trafficsigns/train/...

%% Task 1: Determine the characteristics of the signals in the training set: 
%   max and min size, form factor, filling ratio of each type of signal, 
%   frequency of appearance (using text annotations and ground-truth masks). 
%   Group the signals according to their shape and color.
% [ traffic_sign_type, vector_of_features] = extract_features(dataset_path)
%[ freqAppearanceClass,trafficSignType, vectorFeatures, maxMinResults] = extractFeatures(strcat(dataset_path, '/train/'))
addpath(genpath(dataset_path));
% [ freqAppearanceClass,trafficSignType, vectorFeatures] = extractFeatures(strcat(dataset_path,'/train/'));
close all

% Task 2: Create balanced train/validation split using provided dataset.
% [ paths_for_training, paths_for_validation ] = split(dataset_path, 
%                                                      traffic_sign_type, 
%                                                      vector_of_features, 
%                                                      validation_percentage)
%[ paths_for_training, paths_for_validation ] = partition(dataset_path, traffic_sign_type, vector_of_features,  validation_percentage)
f = load('/task1/freqAppearances.mat')
partition(fullfile(dataset_path, 'train'), f.freqAppearanceClass, fullfile(dataset_path, 't'), fullfile(dataset_path, 'v'))

% Task 3: Color segmentation to generate a mask
% [ features ] = train(paths_for_training, class_names)
% [ paths_of_computed_masks ] = predict(paths_for_validation, features)
paths_for_training = [
  '/home/jon/mcv_repos/datasets/trafficsigns/train/00.000948.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/00.000949.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/01.002810.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/00.004782.jpg',
];
paths_for_validation = [
  '/home/jon/mcv_repos/datasets/trafficsigns/train/00.004815.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/00.005893.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/01.001340.jpg',
  '/home/jon/mcv_repos/datasets/trafficsigns/train/01.001788.jpg',
];

features = train(paths_for_training);
%disp(features(1))
mask_paths = predict(features, paths_for_validation);

% Task 4: Evaluate the segmentation using ground truth
% [ precision, accuracy, recall, f1_mesure, 
%   tp, fp, fn, time_per_frame ] = evaluate(paths_for_validation, computed_maks) 

% Task 5: Study the influence of luminance normalization (Optional)
% ...




crop= [  36  36  34  33  37  33  32  33  35  29  26  32  42  37  39  46  51  52  49  46  42  44  53  51  71  59  63  39  36  23  28  35  40  37  34  41  51  47  47  47  49  54
  34  34  33  31  33  27  23  24  30  34  35  41  46  52  51  53  53  53  52  50  47  51  52  41  53  46  62  55  63  55  38  23  27  39  43  42  38  48  47  49  52  55
  34  37  34  32  32  33  25  22  28  38  52  63  70  60  57  55  51  49  47  47  47  62  64  57  63  52  53  39  39  56  57  53  48  44  42  46  54  54  56  58  61  63
  40  42  39  35  32  26  29  34  44  54  61  66  68  50  46  42  37  36  34  34  34  30  37  47  58  61  60  52  50  43  62  77  75  60  50  59  72  67  69  73  75  76
  42  43  37  31  28  18  34  55  67  64  53  39  31  31  30  29  26  25  23  22  21  16  17  23  27  43  52  67  75  61  57  54  57  68  77  76  73  83  85  88  89  88
  42  38  32  28  27  46  55  62  58  46  33  25  19  23  24  25  25  23  21  20  18  26  21  23  15  28  30  46  53  78  61  41  40  59  83  89  86  92  94  95  94  92
  40  35  31  35  41  70  66  53  36  23  22  24  25  24  26  27  26  25  23  22  21  14  13  26  20  33  26  37  35  52  57  59  51  52  66  85  97  95  96  96  93  90
  35  31  30  42  55  57  52  43  30  24  24  18  12  26  28  27  24  24  24  25  23  27  24  34  20  28  15  25  19  17  40  64  66  59  59  69  77  89  91  90  86  84
  31  17  36  60  56  49  42  33  28  25  22  17  17  27  27  26  26  25  25  25  25  27  25  24  25  28  29  27  25  23  26  42  60  64  54  49  51  71  76  75  67  63
  37  22  34  55  54  38  34  30  28  25  23  18  18  27  27  26  26  26  26  26  27  27  25  24  25  27  29  28  26  24  24  32  49  61  61  52  47  64  71  75  68  67
  45  32  40  52  50  30  28  28  26  26  24  21  20  26  26  26  26  26  26  27  28  27  25  24  24  26  27  27  27  24  22  23  35  54  67  61  50  54  63  71  69  68
  45  43  47  47  41  26  28  28  29  28  26  23  22  25  25  25  25  25  26  27  27  26  25  24  24  25  26  26  26  22  24  23  25  40  59  67  61  43  52  62  65  65
  42  53  54  43  34  27  30  32  32  31  27  25  25  26  26  25  25  25  25  26  27  26  27  27  27  26  25  24  24  20  29  29  23  26  46  66  75  41  46  56  61  63
  41  61  60  40  31  28  32  34  33  31  29  27  28  30  29  28  27  27  27  27  27  29  32  34  34  31  27  25  24  20  29  31  24  21  33  56  75  50  48  50  57  62
  40  61  55  32  30  27  31  35  33  31  29  32  34  35  34  33  31  30  29  29  29  34  38  42  42  37  31  27  25  23  24  26  26  26  30  43  58  63  53  48  54  62
  39  58  46  25  28  25  29  33  32  30  31  34  37  41  38  36  34  33  32  31  31  38  43  48  48  42  34  29  26  26  19  18  27  34  31  34  41  69  53  44  51  60
  46  54  39  22  22  33  32  34  37  34  27  27  33  49  42  44  43  36  39  42  34  32  41  48  48  45  41  35  28  26  26  25  27  24  24  33  44  71  67  40  43  60
  45  53  39  22  22  29  29  33  39  42  43  47  54  68  55  50  42  28  27  31  25  34  44  53  55  54  51  45  38  48  41  32  28  25  22  26  34  67  66  41  41  53
  46  54  38  22  24  27  28  33  42  48  54  60  67  71  57  51  42  26  25  31  29  31  43  55  60  62  61  56  50  65  54  39  32  25  21  23  29  60  64  42  38  44
  47  55  40  21  23  28  31  38  44  49  51  55  57  61  52  52  48  34  30  37  38  34  44  52  54  53  51  46  39  61  55  45  38  28  22  26  33  53  64  46  39  38
  50  57  41  21  22  27  36  45  48  47  45  44  43  54  50  57  59  44  36  41  43  47  52  53  47  41  37  32  27  47  50  51  45  30  19  24  37  49  64  48  39  36
  52  58  43  23  22  26  40  50  48  43  41  42  41  42  41  54  62  50  44  53  60  60  61  57  49  45  47  50  50  39  47  55  48  29  16  21  34  46  64  49  39  35
  51  59  44  25  24  24  42  53  47  37  36  41  46  41  37  49  57  47  45  62  75  75  72  62  50  47  55  65  70  37  44  52  47  30  17  20  32  45  63  48  36  33
  51  61  46  27  26  24  42  51  42  30  31  41  51  55  46  52  52  38  35  56  72  91  82  65  43  35  39  50  56  36  41  45  43  31  21  24  33  45  63  46  34  32
  49  68  46  22  28  22  35  45  43  34  27  35  43  28  33  43  42  40  33  34  32  47  50  54  46  36  26  27  30  36  38  42  41  29  18  23  33  46  60  46  38  33
  47  73  61  33  26  22  30  42  48  43  36  31  28  30  34  40  40  35  31  29  30  37  40  44  45  42  36  30  28  38  38  38  36  25  18  25  39  49  61  46  37  33
  39  71  72  42  20  21  24  32  43  47  45  35  27  34  38  40  39  34  30  29  30  34  33  35  43  54  59  57  52  56  53  47  37  24  18  26  38  53  64  44  34  30
  32  59  70  49  23  25  22  24  34  44  51  54  49  45  46  45  42  37  34  34  35  40  34  29  34  47  59  65  66  56  54  47  36  25  22  28  38  57  66  42  31  28
  31  45  62  60  41  27  25  26  31  40  51  59  63  51  50  48  44  41  39  39  40  42  37  31  27  29  33  38  42  30  32  31  27  24  28  37  45  60  66  38  26  24
  39  38  53  68  63  25  24  25  27  32  36  41  43  41  38  37  33  32  31  32  31  28  30  32  29  25  21  22  24  23  28  27  25  26  35  43  49  56  61  33  21  21
  49  34  43  67  70  34  30  24  24  24  25  23  22  28  26  26  23  25  24  25  23  21  23  30  29  30  26  27  28  28  33  33  28  29  39  48  53  49  53  26  17  19
  55  31  34  58  64  57  44  31  24  26  27  25  22  29  28  26  26  27  28  28  27  28  27  26  25  25  26  26  26  22  26  26  24  27  42  55  62  43  49  24  16  20
  54  47  33  35  47  77  52  26  16  23  30  29  25  26  28  30  31  30  28  25  23  27  26  26  26  27  28  28  28  29  26  25  30  37  48  56  59  36  29  18  14  17
  55  48  39  40  49  55  56  55  45  32  23  23  27  26  26  25  26  27  30  32  34  31  32  33  32  29  27  26  26  28  26  28  39  51  58  58  56  34  26  20  17  19
  58  53  50  50  52  49  61  68  59  39  23  24  30  29  29  28  27  27  28  29  30  25  29  33  33  31  29  30  32  30  29  36  48  61  64  53  43  26  22  20  18  23
  62  58  60  60  53  48  51  56  58  56  46  34  26  23  25  27  29  29  27  25  23  23  26  30  29  27  26  30  34  38  39  46  55  61  54  41  29  19  18  20  20  25
  68  64  67  64  54  39  39  45  61  74  71  53  33  25  25  26  27  29  30  31  31  34  35  34  31  28  29  33  37  50  52  57  56  51  38  28  20  16  17  20  24  27
  72  69  70  67  59  45  43  43  47  56  64  69  69  49  44  36  30  27  28  32  34  35  34  34  35  39  44  49  52  56  57  58  52  39  28  21  18  16  19  22  26  29
  74  72  70  67  64  62  56  48  39  37  45  61  73  64  60  54  47  42  39  38  37  37  36  37  43  52  59  60  58  48  46  44  38  31  25  20  18  20  21  25  27  29
  72  73  69  67  67  60  60  59  54  46  41  38  34  55  57  62  65  64  59  53  49  50  47  48  53  59  59  52  47  42  36  31  29  30  27  22  19  23  26  28  27  27
  70  71  71  72  73  72  69  66  64  63  59  53  47  37  39  40  38  44  56  60  59  62  60  59  59  57  51  41  36  26  21  20  24  32  37  35  31  35  34  33  31  32
  70  71  70  70  70  69  67  64  64  66  63  58  52  32  35  38  36  39  46  50  50  44  42  41  43  45  46  42  39  36  29  23  23  30  34  35  33  25  24  28  38  41
  71  71  69  68  67  68  66  64  65  69  68  64  57  52  55  55  48  43  41  38  34  35  31  26  28  35  43  50  52  42  33  24  21  27  34  37  39  48  41  41  53  59];
