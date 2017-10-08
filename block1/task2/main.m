path = '/home/cesc/master/m1/project/train/';

f = load('../task1/freqAppearances.mat')
partition(path, f.freqAppearanceClass, '/tmp/train', '/tmp/valid')
