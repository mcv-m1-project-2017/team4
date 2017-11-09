% --- Executes just before HoughObject is made visible.
function HoughObject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HoughObject (see VARARGIN)

% Choose default command line output for HoughObject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HoughObject wait for user response (see UIRESUME)
% uiwait(handles.figure1);