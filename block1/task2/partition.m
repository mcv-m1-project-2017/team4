
path = 'master/m1/project/train/gt/';
files = dir(strcat(path,'*.txt'));

filematrix = [];

for i = 1:size(files)
	fid = fopen(strcat(path,files(i).name));
	line = fgetl(fid);
	category = line(end);
	numfile = str2num( files(i).name(7:12) );
		  
	filematrix = [filematrix; [hex2dec(category) numfile] ];
end
	    
A = filematrix(filematrix(:,1) == hex2dec('A'), :)
B = filematrix(filematrix(:,1) == hex2dec('B'), :)
C = filematrix(filematrix(:,1) == hex2dec('C'), :)
D = filematrix(filematrix(:,1) == hex2dec('D'), :)
E = filematrix(filematrix(:,1) == hex2dec('E'), :)
F = filematrix(filematrix(:,1) == hex2dec('F'), :)

datasample(A, 10)
