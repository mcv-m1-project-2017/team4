% --- Executes on button press in pbDetect.
function pbDetect_Callback(hObject, eventdata, handles)
% hObject    handle to pbDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
[maxval,maxind] = max(data);
medval = median(data);

[p]=polyfit(1:maxind-5,data(1:maxind-5),2);

if maxval<3*medval
    set(handles.txtResult,'string','Triangle');
elseif  p(3)>100
    set(handles.txtResult,'string','Square');
else
    set(handles.txtResult,'string','Round'); 
end