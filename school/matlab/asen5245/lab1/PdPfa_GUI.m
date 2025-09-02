function varargout = PdPfa_GUI(varargin)
% PDPFA_GUI MATLAB code for PdPfa_GUI.fig
%      PDPFA_GUI, by itself, creates a new PDPFA_GUI or raises the existing
%      singleton*.
%
%      H = PDPFA_GUI returns the handle to a new PDPFA_GUI or the handle to
%      the existing singleton*.
%
%      PDPFA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PDPFA_GUI.M with the given input arguments.
%
%      PDPFA_GUI('Property','Value',...) creates a new PDPFA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PdPfa_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PdPfa_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PdPfa_GUI

% Last Modified by GUIDE v2.5 24-Mar-2015 14:41:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PdPfa_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PdPfa_GUI_OutputFcn, ...
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


% --- Executes just before PdPfa_GUI is made visible.
function PdPfa_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PdPfa_GUI (see VARARGIN)

% Choose default command line output for PdPfa_GUI
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set intial simulation parameter values

% Monte Carlo simulation and plotting parameters
NoSamps = 500000;  % # of samples for estimating PDFs
Nhistbins = 200;  % # of bins for histograms
PlotSamps = 150;  % # of noise or target+noise samples to plot

% Noise parameters
NoisePower = 2e-3;  % noise power (variance of complex noise)

% Target parameters
SNRdB = 10;  % SNR in decibels
TgtSpacing = 20;  % samples between targets

% Detection parameters
TheorPfa = 1e-2;  % between 0.001 and 0.5
ThreshMult = -log(TheorPfa);

% Set up limits on range of Pfa allowed to keep simulation practical
PfaMax = 0.5;
PfaMin = 1e-3;
set(handles.TheorPfa_edit,'Max',PfaMax);
set(handles.TheorPfa_edit,'Min',PfaMin)

% Initialize GUI parameter elements
NoisePower_string = num2str(NoisePower);
set(handles.NoisePower_edit,'String',NoisePower_string)

NoSamps_string = num2str(NoSamps);
set(handles.NoSamps_edit,'String',NoSamps_string)

PlotSamps_string = num2str(PlotSamps);
set(handles.PlotSamps_edit,'String',PlotSamps_string)

set(handles.ThreshMult_slider,'Value',ThreshMult)
ThreshMult_string = num2str(ThreshMult);
set(handles.ThreshMult_edit,'String',ThreshMult_string)

TheorPfa_string = num2str(TheorPfa);
set(handles.TheorPfa_edit,'String',TheorPfa_string)

set(handles.SNRdB_slider,'Value',SNRdB)
SNRdB_string = num2str(SNRdB);
set(handles.SNRdB_edit,'String',SNRdB_string)

set(handles.TgtSpacing_slider,'Value',TgtSpacing)
TgtSpacing_string = num2str(TgtSpacing);
set(handles.TgtSpacing_edit,'String',TgtSpacing_string)

% Tell the PdPfa_Graphs routine to start a new ROC plot
NewROC = true;

% Create a additional handles data objects for various app-generated signls
% and variables defined in the GUI figure file, and update handles
% structure
handles.Nbins = Nhistbins;
handles.xx = [];
handles.yy = [];
handles.TgtAmp = 0;
handles.Threshold = Inf;

guidata(hObject,handles);

% Generate an initial realization of data and draw initial plots
PdPfa_Realization(hObject,handles)  % generate noise and sig+noise data
PdPfa_Threshold(hObject,handles)  % compute threshold for current noise power and design Pfa
PdPfa_TheorPd(hObject,handles)  % compute theoretical Pd
PdPfa_Detect(hObject,handles)  % threshold detect and compute observed Pd and Pfa
PdPfa_Graphs(hObject,handles,NewROC)  % update graphs

% UIWAIT makes PdPfa_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = PdPfa_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in NewData_pushbutton.
function NewData_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to NewData_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update data, apply current threshold, and update graphs
PdPfa_Realization(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)


% --- Executes on slider movement.
function SNRdB_slider_Callback(hObject, eventdata, handles)
% hObject    handle to SNRdB_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SNRdB = get(hObject,'Value');
SNRdB_string = num2str(SNRdB);
set(handles.SNRdB_edit,'String',SNRdB_string)

% Generate new data with the new SNR, then detect and update the
% graphs
PdPfa_Realization(hObject,handles)
PdPfa_TheorPd(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)


% --- Executes during object creation, after setting all properties.
function SNRdB_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRdB_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function SNRdB_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SNRdB_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNRdB_edit as text
%        str2double(get(hObject,'String')) returns contents of SNRdB_edit as a double

SNRdB_string = get(handles.SNRdB_edit,'String');
SNRdB = str2double(SNRdB_string);
set(handles.SNRdB_slider,'Value',SNRdB)

% Generate new data with the new SNR, then detect and update the
% graphs
PdPfa_Realization(hObject,handles)
PdPfa_TheorPd(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)


% --- Executes during object creation, after setting all properties.
function SNRdB_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNRdB_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TgtSpacing_slider_Callback(hObject, eventdata, handles)
% hObject    handle to TgtSpacing_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

TgtSpacing = get(hObject,'Value');
TgtSpacing = round(TgtSpacing); % force integer value
TgtSpacing_string = num2str(TgtSpacing);
set(handles.TgtSpacing_edit,'String',TgtSpacing_string)

% Generate new data with the new target spacing, then detect and update the
% graphs
PdPfa_Realization(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)


% --- Executes during object creation, after setting all properties.
function TgtSpacing_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TgtSpacing_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function TgtSpacing_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TgtSpacing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TgtSpacing_edit as text
%        str2double(get(hObject,'String')) returns contents of TgtSpacing_edit as a double

% New target spacing value does not trigger generation of a new data
% realization; save it until something else does
TgtSpacing_string = get(handles.TgtSpacing_edit,'String');
TgtSpacing = str2double(TgtSpacing_string);
TgtSpacing = round(TgtSpacing); % force integer value
set(handles.TgtSpacing_slider,'Value',TgtSpacing)
TgtSpacing_string = num2str(TgtSpacing);
set(handles.TgtSpacing_edit,'String',TgtSpacing_string)


% Generate new data with the new target spacing, then detect and update the
% graphs
PdPfa_Realization(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)


% --- Executes during object creation, after setting all properties.
function TgtSpacing_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TgtSpacing_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NoisePower_edit_Callback(hObject, eventdata, handles)
% hObject    handle to NoisePower_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoisePower_edit as text
%        str2double(get(hObject,'String')) returns contents of NoisePower_edit as a double

NoisePower_string = get(hObject,'String');
NoisePower = str2double(NoisePower_string);

% generate a new realization with the new noise power, and update the
% graphs
PdPfa_Realization(hObject,handles)
PdPfa_Threshold(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)

% --- Executes during object creation, after setting all properties.
function NoisePower_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoisePower_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NoSamps_edit_Callback(hObject, eventdata, handles)
% hObject    handle to NoSamps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoSamps_edit as text
%        str2double(get(hObject,'String')) returns contents of NoSamps_edit as a double

NoSamps_string = get(hObject,'String');
NoSamps = str2double(NoSamps_string);

% generate a new realization with the new number of samples, and update the
% threshold, do detection, and update the graphs
PdPfa_Realization(hObject,handles)
PdPfa_Threshold(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,false)

% --- Executes during object creation, after setting all properties.
function NoSamps_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoSamps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PlotSamps_edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSamps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotSamps_edit as text
%        str2double(get(hObject,'String')) returns contents of PlotSamps_edit as a double

PlotSamps_string = get(hObject,'String');
PlotSamps = str2double(PlotSamps_string);

% refresh plots to use new number of samples
PdPfa_Graphs(hObject,handles,false)

% --- Executes during object creation, after setting all properties.
function PlotSamps_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotSamps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ThreshMult_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ThreshMult_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ThreshMult = get(hObject,'Value');
ThreshMult = min(-log(1e-3),max(-log(0.5),ThreshMult)); % enforce limits
ThreshMult_string = num2str(ThreshMult);
set(handles.ThreshMult_edit,'String',ThreshMult_string)

TheorPfa = exp(-ThreshMult);
TheorPfa_string = num2str(TheorPfa);
set(handles.TheorPfa_edit,'String',TheorPfa_string);

% Apply the new threshold to the existing data, and update the graphs
PdPfa_Threshold(hObject,handles)
PdPfa_TheorPd(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,true)


% --- Executes during object creation, after setting all properties.
function ThreshMult_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreshMult_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function ThreshMult_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ThreshMult_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThreshMult_edit as text
%        str2double(get(hObject,'String')) returns contents of ThreshMult_edit as a double

ThreshMult_string = get(hObject,'String');
ThreshMult = str2double(ThreshMult_string);
ThreshMult = min(-log(1e-3),max(-log(0.5),ThreshMult)); % enforce limits
set(handles.ThreshMult_slider,'Value',ThreshMult)

TheorPfa = exp(-ThreshMult);
TheorPfa_string = num2str(TheorPfa);
set(handles.TheorPfa_edit,'String',TheorPfa_string);

% Apply the new threshold to the existing data, and update the graphs
PdPfa_Threshold(hObject,handles)
PdPfa_TheorPd(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,true)


% --- Executes during object creation, after setting all properties.
function ThreshMult_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreshMult_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TheorPfa_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TheorPfa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TheorPfa_edit as text
%        str2double(get(hObject,'String')) returns contents of TheorPfa_edit as a double

TheorPfa_string = get(handles.TheorPfa_edit,'String');
TheorPfa = str2double(TheorPfa_string);
TheorPfa = min(0.5,max(TheorPfa,0.001));  % enforce Pfa limits
TheorPfa_string = num2str(TheorPfa);
set(handles.TheorPfa_edit,'String',TheorPfa_string);

ThreshMult = -log(TheorPfa);
ThreshMult_string = num2str(ThreshMult);
set(handles.ThreshMult_edit,'String',ThreshMult_string)
set(handles.ThreshMult_slider,'Value',ThreshMult)

% update graphs to show new threshold, but do not update data
PdPfa_Threshold(hObject,handles)
PdPfa_TheorPd(hObject,handles)
PdPfa_Detect(hObject,handles)
PdPfa_Graphs(hObject,handles,true)

% --- Executes during object creation, after setting all properties.
function TheorPfa_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TheorPfa_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PdPfa_Realization(hObject,handles)
% Function to generate square-law-detected noise-only and signal+noise
% signals

handles = guidata(gcf);

% Collect the variables needed
NoisePower_string = get(handles.NoisePower_edit,'String');
NoisePower = str2double(NoisePower_string);

SNRdB_string = get(handles.SNRdB_edit,'String');
SNRdB = str2double(SNRdB_string);
SNR = 10^(SNRdB/10);

NoSamps_string = get(handles.NoSamps_edit,'String');
NoSamps = str2double(NoSamps_string);

TgtSpacing_string = get(handles.TgtSpacing_edit,'String');
TgtSpacing = str2double(TgtSpacing_string);

%  Generate the complex WGN and from it,an exponential noise sequence
x = sqrt(NoisePower/2)*(randn(1,NoSamps) + 1i*randn(1,NoSamps));
xx = x.*conj(x);

% Generate the target + noise signal
TgtAmp = sqrt(NoisePower*SNR);  % Target-only amplitude (not power)

y = x;
y(1:TgtSpacing:end) = y(1:TgtSpacing:end) + TgtAmp;
yy = y.*conj(y);

% update the GUI data
handles.xx = xx;
handles.yy = yy;
handles.TgtAmp = TgtAmp;

guidata(hObject,handles)


function PdPfa_Threshold(hObject,handles)

handles = guidata(gcf);

ThreshMult_string = get(handles.ThreshMult_edit,'String');
ThreshMult = str2double(ThreshMult_string);

NoisePower_string = get(handles.NoisePower_edit,'String');
NoisePower = str2double(NoisePower_string);

Threshold = ThreshMult*NoisePower;
handles.Threshold = Threshold;

guidata(hObject,handles)


function PdPfa_TheorPd(hObject,handles)
handles = guidata(gcf);

% Compute theoretical Pd for current SNR and Pfa using MATLAB's Marcum Q
% function
ThreshMult_string = get(handles.ThreshMult_edit,'String');
ThreshMult = str2double(ThreshMult_string);
SNRdB_string = get(handles.SNRdB_edit,'String');
SNRdB = str2double(SNRdB_string);
SNR = 10^(SNRdB/10);

TheorPd = marcumq(sqrt(2*SNR),sqrt(2*ThreshMult));
TheorPd_string = num2str(TheorPd);
set(handles.TheorPd_value,'String',TheorPd_string)

guidata(hObject,handles)



function PdPfa_Detect(hObject,handles)

handles = guidata(gcf);

% read needed variables form GUI first
Threshold = handles.Threshold;
TgtSpacing_string = get(handles.TgtSpacing_edit,'String');
TgtSpacing = str2double(TgtSpacing_string);
xx = handles.xx;
yy = handles.yy;

% apply threshold and calculate probabilities
ObsPfa = sum(xx > Threshold)/length(xx);

sn = yy(1:TgtSpacing:end);  % signal + noise samples only
ObsPd = sum(sn > Threshold)/length(sn);

% display results in GUI
ObsPd_string = num2str(ObsPd);
set(handles.ObsPd_value,'String',ObsPd_string);
ObsPfa_string = num2str(ObsPfa);
set(handles.ObsPfa_value,'String',ObsPfa_string);

guidata(hObject,handles)


function PdPfa_Graphs(hObject,handles,NewROC)

handles = guidata(gcf);

% retrieve needed variables
PlotSamps_string = get(handles.PlotSamps_edit,'String');
PlotSamps = str2double(PlotSamps_string);
Nhistbins = handles.Nbins;
TgtSpacing_string = get(handles.TgtSpacing_edit,'String');
TgtSpacing = str2double(TgtSpacing_string);
xx = handles.xx;
yy = handles.yy;
SNRdB_string = get(handles.SNRdB_edit,'String');
SNRdB = str2double(SNRdB_string);
TheorPfa_string = get(handles.TheorPfa_edit,'String');
TheorPfa = str2double(TheorPfa_string);
TheorPd_string = get(handles.TheorPd_value,'String');
TheorPd = str2double(TheorPd_string);
ObsPd_string = get(handles.ObsPd_value,'String');
ObsPd = str2double(ObsPd_string);
Threshold = handles.Threshold;
TgtAmp = handles.TgtAmp;

% Updates the Noise, Signal+Noise, PDF, and ROC graphs
axes(handles.Noise_axes);
plot(1:PlotSamps,xx(1:PlotSamps))
% add a horizontal line at the threshold level
xrange=get(gca,'xlim');
hold on
plot(xrange,[Threshold,Threshold],'g','LineWidth',2)
text('Units','normalized','Position',[0.05, 0.95, 0],'String','\color{green}threshold')
hold off
xlabel('sample')
ylabel('power')
grid

axes(handles.SigNoise_axes);
plot(1:PlotSamps,yy(1:PlotSamps))
% add a horizontal line at the threshold level
xrange=get(gca,'xlim');
hold on
plot(xrange,[Threshold,Threshold],'g','LineWidth',2)
text('Units','normalized','Position',[0.05, 0.95, 0],'String','\color{green}threshold')
hold off
xlabel('sample')
ylabel('power')
grid

axes(handles.PDF_axes);
% For signal+noise, want to use only those samples that have a signal
% present for this histogram.
[count,centers] = hist(yy(1:TgtSpacing:end),round(Nhistbins/2));
% The normalization in the next 2 lines converts the hist to a PDF, i.e.
% the sum of the bar areas = 1
dcent = centers(2) - centers(1);
area = sum(count)*dcent;
bar(centers,count/area)
hold on
[count,centers] = hist(xx,Nhistbins);
dcent = centers(2) - centers(1);
area = sum(count)*dcent;
bar(centers,count/area,'FaceColor','r','EdgeColor','r')
% add a vertical line at the target power value
yrange=get(gca,'ylim');
plot([TgtAmp^2,TgtAmp^2],yrange,'g','LineWidth',2)
text('Units','normalized','Position',[0.65, 0.95, 0],'String','\color{green}Target Power')
hold off
xlabel('power')
ylabel('probability density')
grid

axes(handles.ROC_axes);
% add new markers at the theoretical and observed Pd's for this SNR.  This
% only makes sense if the threshold (and therefore Pfa) is held constant,
% so if either of those changes, clear the plot and start over. Otherwise,
% hold the current data points and add the new ones. The NewROC variable is
% used to tell us which of these two sitations applies.
if (NewROC)
    % new plot needed because theoretical Pfa wil have changed, so we start
    % a new ROC curve
    plot(SNRdB,TheorPd,'o','MarkerEdgeColor','b','MarkerSize',8)
    axis([-10 30 0 1])
    hold on
    plot(SNRdB,ObsPd,'*r')
    xlabel('SNR (dB)')
    ylabel('Pd')
    grid
    text(-8,0.9,{'\color{blue}Theoretical Pd','\color{red}Observed Pd'})
    text(-8,0.7,{'Theoretical',['Pfa = ',num2str(TheorPfa)]})
    hold off
else
    % Pfa didn't change, so hold all of the ROC curve generated so far
    hold on
    plot(SNRdB,TheorPd,'o','MarkerEdgeColor','b','MarkerSize',8)
    plot(SNRdB,ObsPd,'*r')
    hold off
end
