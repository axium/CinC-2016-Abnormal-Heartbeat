function varargout = Demo_GUI(varargin)
% DEMO_GUI MATLAB code for Demo_GUI.fig
%      DEMO_GUI, by itself, creates a new DEMO_GUI or raises the existing
%      singleton*.
%
%      H = DEMO_GUI returns the handle to a new DEMO_GUI or the handle to
%      the existing singleton*.
%
%      DEMO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO_GUI.M with the given input arguments.
%
%      DEMO_GUI('Property','Value',...) creates a new DEMO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Demo_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Demo_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Demo_GUI

% Last Modified by GUIDE v2.5 18-May-2017 14:31:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Demo_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Demo_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Demo_GUI is made visible.
function Demo_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Demo_GUI (see VARARGIN)

% Choose default command line output for Demo_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Demo_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Demo_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

i = handles.listbox1.Value;
Trunc = 0.1;
AudioFiles = dir('*.wav');

[y,Fs] = audioread(AudioFiles(i).name);
L = length(y);
Ts = 1/Fs;
t = (0:L-1)*Ts;

y_trunc = y(Trunc*Fs : length(y)-Trunc*Fs);
y_smooth =  HeartBeatSmooth(y_trunc,Fs);    
t_smooth = (0:length(y_smooth)-1)*Ts;

[Loc, S1_Loc, S2_Loc, y_envelope] = S1_S2_SegmentLoc(y_smooth , Fs);

handles.y = y;
guidata(hObject,handles);
handles.y_smooth = y_smooth;
guidata(hObject,handles);
handles.Fs = Fs;
guidata(hObject,handles);

axes(handles.axes1)
plot(t,y);

axes(handles.axes2)
plot(t_smooth, handles.y_smooth)
hold on
scatter(S1_Loc*Ts, y_envelope(S1_Loc) ,'rx', 'LineWidth',2);
scatter(S2_Loc*Ts, y_envelope(S2_Loc) ,'bx', 'LineWidth',2);
hold off

axes(handles.axes3)
plot(fftshift(abs(fft(handles.y))))
axes(handles.axes4)
plot(fftshift(abs(fft(handles.y_smooth))))

set(handles.Output , 'String', '');


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PlaySound.
function PlaySound_Callback(hObject, eventdata, handles)
% hObject    handle to PlaySound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.y,handles.Fs)


function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Output as text
%        str2double(get(hObject,'String')) returns contents of Output as a double


% --- Executes during object creation, after setting all properties.
function Output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlaySmooth.
function PlaySmooth_Callback(hObject, eventdata, handles)
% hObject    handle to PlaySmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.y_smooth, handles.Fs)


% --- Executes on button press in Predict.
function Predict_Callback(hObject, eventdata, handles)
% hObject    handle to Predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('SVMModel.mat');

[Perc, CepsL] = FeatureExtract(handles.y_smooth, handles.Fs);
Perc_Normalized = bsxfun(@minus, Perc, mean_Perc);
Perc_Normalized = bsxfun(@rdivide, Perc_Normalized, std_Perc);

CepsL_Normalized = bsxfun(@minus, CepsL, mean_CepsL);
CepsL_Normalized = bsxfun(@rdivide, CepsL_Normalized, std_CepsL);

Predict_Sample = [Perc_Normalized; CepsL_Normalized];

Target_Predicted  = EnsembleSVM_PREDICT( Predict_Sample, SVMModel_1, SVMModel_2, SVMModel_3);
if( Target_Predicted == 1)
    set(handles.Output , 'String', 'Abnormal');
else
    set(handles.Output , 'String', 'Normal');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Output.
function Output_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PLOT.
function PLOT_Callback(hObject, eventdata, handles)
% hObject    handle to PLOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
plot(handles.y);
axes(handles.axes2)
plot(handles.y_smooth)
axes(handles.axes3)
plot(fftshift(abs(fft(handles.y))))
axes(handles.axes4)
plot(fftshift(abs(fft(handles.y_smooth))))
