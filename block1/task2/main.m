path = '/home/cesc/master/m1/project/train/';
%[train, test] = partition(path, 'A', .5)

f = load('../task1/freqAppearances.mat')

%freqs = [0.1; 0.1; 0.1; 0.2; 0.3; 0.2]
partition(path, f.freqAppearanceClass, '/tmp/train', '/tmp/valid')