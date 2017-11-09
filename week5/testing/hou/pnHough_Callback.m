% --- Executes on button press in pnHough.
function pnHough_Callback(hObject, eventdata, handles)
% hObject    handle to pnHough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.S;
[H, theta,rho]=hough(S);
axes(handles.axes2);
imshow(H,[],'xdata',theta,'ydata',rho);
xlabel('\theta'),ylabel('\rho')
axis on, axis normal;
title('Hough Matrix');

clear data;
for cnt = 1:max(max(H))
    data(cnt) = sum(sum(H == cnt));
end
axes(handles.axes3);
%data(data==0)=NaN;
plot(data,'--x');
xlabel('Hough Matrix Intensity'),ylabel('Counts')
handles.data = data;
guidata(hObject, handles);