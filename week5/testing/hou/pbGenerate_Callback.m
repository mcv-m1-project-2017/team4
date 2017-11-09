% --- Executes on button press in pbGenerate.
function pbGenerate_Callback(hObject, eventdata, handles)
% hObject    handle to pbGenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load ObjectTemplate
S1 = zeros(180,180);
Str = {'Sq','Sc','St'};

a = 1; b = 3;
x = round(a + (b-a) * rand(1));
S2 = eval(Str{x});

a = 1; b = 90;
x = round(a + (b-a) * rand(1));
S3 = imrotate(S2,x);

S = S1;
sz = size(S3);

a = 1; b = min(sz);
x = round(a + (b-a) * rand(1));


S(x:sz(1)+x-1,x:sz(2)+x-1)=S3;
S = im2bw(S);
axes(handles.axes1);

imshow(S);
title('Original Image');
handles.S = S;
guidata(hObject, handles);
