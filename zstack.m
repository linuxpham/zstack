%% Z-Stack Image Analysis
%% Description : Main GUI
%% Author : Pham Thai Hoa - thaihoabo@gmail.com
%% Created date: 23/02/2014

function varargout = zstack(varargin)
% ZSTACK MATLAB code for zstack.fig
%      ZSTACK, by itself, creates a new ZSTACK or raises the existing
%      singleton*.
%
%      H = ZSTACK returns the handle to a new ZSTACK or the handle to
%      the existing singleton*.
%
%      ZSTACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZSTACK.M with the given input arguments.
%
%      ZSTACK('Property','Value',...) creates a new ZSTACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zstack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zstack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zstack

% Last Modified by GUIDE v2.5 06-Apr-2014 21:42:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zstack_OpeningFcn, ...
                   'gui_OutputFcn',  @zstack_OutputFcn, ...
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
end

% --- Executes just before zstack is made visible.
function zstack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zstack (see VARARGIN)

% Choose default command line output for zstack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

% Initialize global variables
initialize();

%% Current width of figure
global currWidthOfFigure;

% Get figure position information
arrPosition = get(handles.zstackDialog,'Position');

% Set the new position for figure
set(handles.zstackDialog,'Position', [arrPosition(1), arrPosition(2), currWidthOfFigure, arrPosition(4)]);

% Registry the old width of figure
currWidthOfFigure = arrPosition(3);

% Load all global variables
global debugMode;

% Debug information
if debugMode
    disp(strcat('currWidthOfFigure: ', num2str(currWidthOfFigure)));
end

% Get Logo image data    
[arrDimession, arrColorMap] = imread('logo.png', 'png');    

% Change current axes
cla(handles.lbLogo,'reset');
axes(handles.lbLogo);

% Show image in view
imshow(arrDimession, arrColorMap);

% Resize axes size
set(handles.lbLogo, 'Visible', 'off', 'Units', 'pixels');

% Center - Top the dialog
movegui(handles.zstackDialog,'north');

% UIWAIT makes zstack wait for user response (see UIRESUME)
% uiwait(handles.zstackDialog);
end


% --- Outputs from this function are returned to the command line.
function varargout = zstack_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% End initialization code - DO NOT EDIT
end

% --- Executes on image
function imageClickCallback(hObject , eventdata, imageName, iRatio)

% Get Plot Size
iPlotSize = get(0,'ScreenSize');

% Create a figure
%fgScreen = figure('Toolbar','none', 'Menubar','none');
fgScreen = figure('Toolbar','figure', 'Menubar','none');

% Set attributes for figure
set(fgScreen, 'Color', [1 1 1], 'Position', iPlotSize, 'Visible', 'on', 'Name', imageName);

% Create Axes
axesHandle = axes;

% Set current axes
set(fgScreen,'CurrentAxes', axesHandle);
set(axesHandle, 'Units', 'pixels');
set(fgScreen, 'Units', 'pixels');
set(0, 'Units', 'pixels');

% Get TIF image data
arrDimession = get(hObject,'CData');

% Show image in view
imshow(arrDimession);

% Set grid on
grid on;

% End initialization code - DO NOT EDIT
end

% --- Executes on button press in btChooseDirectory.
function btChooseDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to btChooseDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Get current directory data
currDirectoryPath = uigetdir('./','Z-Stack Image Analysis Directory');

% Check empty directory when click Cancel button
if length(currDirectoryPath) < 2
    currDirectoryPath = './';
end

% Load all global variables
global debugMode;

% Debug information
if debugMode
    disp(strcat('Current directory: ', currDirectoryPath));
end

%% All Stack List in Brain
global arrStackList;

%% All images in a stack (the depth images)
global arrStackListName;

%% Current width of figure
global currWidthOfFigure;

%% Height of image in axes
global iHeighImageInAxes;

%% Image Left Padding
global iLeftPaddingInAxes;

%% Image Left Padding
global iBottomPaddingInAxes;

% Get all stack list data
[arrStackList, arrStackListName] = getStackList(currDirectoryPath);

% Get all keys of stack data
arrStackListID = keys(arrStackList);
arrStackListVal = values(arrStackList);

% Get stack length
iStackLength = length(arrStackListID);

% Debug information
if debugMode
    disp(keys(arrStackList));
    disp(values(arrStackList));    
    disp(values(arrStackListName));
end

% Reset popup stack menu and label
set(handles.btListStack, 'String', ['Stack List In The Brain']);
set(handles.pnImageList, 'Title', 'Images (0)');
set(handles.lbCurrImage, 'String', 'Loading...');

% Reset popup RGB stack
set(handles.popupRedStack, 'String', ['Stack Name']);
set(handles.popupBlueStack, 'String', ['Stack Name']);
set(handles.popupGreenStack, 'String', ['Stack Name']);

% Reset MIN and MAX of slider
set(handles.btSlider,'Min', 0.01);
set(handles.btSlider,'Max', 1.0);
set(handles.btSlider,'Value', 1);
set(handles.btSlider, 'SliderStep', [0.01, 1.0]);

% Get flag to control MCT
isMCT = get(handles.btRadioYes,'Value');

% Loop to put data to popup stack menu
if iStackLength > 0
    %% -------------------------------------
    %% Resize figure and center window again
    %% -------------------------------------
    
    % Visible the axes and slider of axes
    set(handles.btGraph, 'Visible', 'on');
    
    % Get figure position information
    arrPosition = get(handles.zstackDialog,'Position');

    % Set the new position for figure
    set(handles.zstackDialog,'Position', [arrPosition(1), arrPosition(2), currWidthOfFigure, arrPosition(4)]);

    % Center - Top the dialog
    movegui(handles.zstackDialog,'north');
    
    %% -------------------------------------
    %% Handle the window interface
    %% -------------------------------------
            
    % Show combobox of Stack
    set(handles.btListStack, 'String', arrStackListID);
    
    % Show combobox of RGB Stack
    set(handles.popupRedStack, 'String', arrStackListID);
    set(handles.popupBlueStack, 'String', arrStackListID);
    set(handles.popupGreenStack, 'String', arrStackListID);
    
    % Get total images
    iTotalImage = arrStackListVal{1};
    
    % Change MIN and MAX of slider
    set(handles.btSlider,'Max', iTotalImage);
    set(handles.btSlider, 'SliderStep', [1/double(iTotalImage - 1), 1/double(iTotalImage - 1)]);
    
    % Get the first image in a stack
    arrStackImages = arrStackListName(arrStackListID{1});
    
    %% -------------------------------------
    %% Write image into axes graph
    %% -------------------------------------
    
    % Get current TIF image full path
    currImageFullPath = strcat(currDirectoryPath, currSplitPath, arrStackImages(1));
    
    % Debug information
    if debugMode
        disp(currImageFullPath);
    end
    
    % Get TIF image data    
    [arrDimession, arrColorMap] = imread(currImageFullPath, 'tif');    
    
    % Get image information
    imageInfo = imfinfo(currImageFullPath, 'tif');
    
    % Get ratio between width and height
    iRatio = imageInfo.Width / imageInfo.Height;
    
    % Create the width and the height of axes    
    iWidth = iHeighImageInAxes * iRatio;
    
    % The output image MCTimage is the thresholded image
    if isMCT
        [arrDimession] = MCT(arrDimession);
    else
        % Get all bits input data
        arrBitContents = cellstr(get(handles.txtFilterNumber,'String'));

        % Get current bit input data
        iBitSize = arrBitContents{get(handles.txtFilterNumber,'Value')};
        
        % Convert from string to number
        iBitSize = str2double(iBitSize);
        
        % Check convert bit number
        if iBitSize > 0
            [arrDimession] = MNL(arrDimession, iBitSize);
        end
    end
    
    % Change current axes
    cla(handles.btGraph,'reset');
    axes(handles.btGraph);
                
    % Show image in view
    imageHandle = imshow(arrDimession, arrColorMap);
    
    % Set image callback when click
    set(imageHandle, 'ButtonDownFcn', {@imageClickCallback, arrStackImages(1), iRatio});
    
    % Resize axes size
    set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels', 'Position', [iLeftPaddingInAxes, iBottomPaddingInAxes, iWidth, iHeighImageInAxes]);
         
    % Change total images of stack label    
    set(handles.pnImageList, 'Title', strcat('Images (', num2str(iTotalImage), ')'));
    
    % Change title of current image label    
    set(handles.lbCurrImage, 'String', arrStackImages(1));
    
    % Set grid on
    grid on;
end

% End initialization code - DO NOT EDIT
end


% --- Executes on selection change in btListStack.
function btListStack_Callback(hObject, eventdata, handles)
% hObject    handle to btListStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns btListStack contents as cell array
%        contents{get(hObject,'Value')} returns selected item from btListStack

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Load all global variables
global debugMode;

%% Height of image in axes
global iHeighImageInAxes;

%% Image Left Padding
global iLeftPaddingInAxes;

%% Image Left Padding
global iBottomPaddingInAxes;

% Get all stack contents data
arrStackContents = cellstr(get(handles.btListStack,'String'));

% Get current stack in menu
keyName = arrStackContents{get(handles.btListStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current stack: ', keyName));
end

% Reset popup stack menu and label
set(handles.pnImageList, 'Title', 'Images (0)');
set(handles.lbCurrImage, 'String', 'Loading...');

% Reset MIN and MAX of slider
set(handles.btSlider,'Min', 1);
set(handles.btSlider,'Max', 1);
set(handles.btSlider,'Value', 1);
set(handles.btSlider, 'SliderStep', [0.01, 1.0]);

%% All Stack List in Brain
global arrStackList;

%% All images in a stack (the depth images)
global arrStackListName;

% Get all keys of stack data
arrStackListID = keys(arrStackList);

% Get stack length
iStackLength = length(arrStackListID);

% Get flag to control MCT
isMCT = get(handles.btRadioYes,'Value');

% Loop to put data to popup stack menu
if iStackLength > 0
    %% -------------------------------------
    %% Handle the window interface
    %% -------------------------------------
    
    % Get total images
    iTotalImage = arrStackList(keyName);
    
    % Change MIN and MAX of slider
    set(handles.btSlider,'Max', iTotalImage);
    set(handles.btSlider, 'SliderStep', [1/double(iTotalImage - 1), 1/double(iTotalImage - 1)]);
    
    % Get the first image in a stack
    arrStackImages = arrStackListName(keyName);
    
    % Get current TIF image full path
    currImageFullPath = strcat(currDirectoryPath, currSplitPath, arrStackImages(1));
    
    % Debug information
    if debugMode
        disp(currImageFullPath);
    end
    
    % Get TIF image data    
    [arrDimession, arrColorMap] = imread(currImageFullPath, 'tif');    
    
    % Get image information
    imageInfo = imfinfo(currImageFullPath, 'tif');
    
    % Get ratio between width and height
    iRatio = imageInfo.Width / imageInfo.Height;
    
    % Create the width and the height of axes    
    iWidth = iHeighImageInAxes * iRatio;
    
    % The output image MCTimage is the thresholded image
    if isMCT
        [arrDimession] = MCT(arrDimession);
    else
        % Get all bits input data
        arrBitContents = cellstr(get(handles.txtFilterNumber,'String'));

        % Get current bit input data
        iBitSize = arrBitContents{get(handles.txtFilterNumber,'Value')};
        
        % Convert from string to number
        iBitSize = str2double(iBitSize);
        
        % Check convert bit number
        if iBitSize > 0
            [arrDimession] = MNL(arrDimession, iBitSize);
        end
    end
    
    % Change current axes
    cla(handles.btGraph,'reset');
    axes(handles.btGraph);
                
    % Show image in view
    imageHandle = imshow(arrDimession, arrColorMap);
    
    % Set image callback when click
    set(imageHandle, 'ButtonDownFcn', {@imageClickCallback, arrStackImages(1), iRatio});
    
    % Resize axes size
    set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels', 'Position', [iLeftPaddingInAxes, iBottomPaddingInAxes, iWidth, iHeighImageInAxes]);
    
    % Change total images of stack label
    set(handles.pnImageList, 'Title', strcat('Images (', num2str(iTotalImage), ')'));
    
    % Change title of current image label    
    set(handles.lbCurrImage, 'String', arrStackImages(1));
    
    % Set grid on
    grid on;
end

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function btListStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btListStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end


% --- Executes on slider movement.
function btSlider_Callback(hObject, eventdata, handles)
% hObject    handle to btSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

% Get current position of slider
iCurrPosition = int32(get(hObject,'Value'));

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Load all global variables
global debugMode;

%% Height of image in axes
global iHeighImageInAxes;

% Debug information
if debugMode
    disp(strcat('Current position of slider: ', num2str(iCurrPosition)));
end

%% All images in a stack (the depth images)
global arrStackListName;

%% Image Left Padding
global iLeftPaddingInAxes;

%% Image Left Padding
global iBottomPaddingInAxes;

% Change title of current image label
set(handles.lbCurrImage, 'String', 'Loading...');

% Get all stack contents data
arrStackContents = cellstr(get(handles.btListStack,'String'));

% Get current stack in menu
keyName = arrStackContents{get(handles.btListStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current stack: ', keyName));
end

% Get the first image in a stack
arrStackImages = arrStackListName(keyName);

% Get total images of a stack
iTotalLength = length(arrStackImages);

% Check current position
if iCurrPosition < 1
    % Go to the first element
    iCurrPosition = iTotalLength;
    
    % Reset value of slider
    set(hObject,'Value', iTotalLength);
end

% Check current position
if iCurrPosition > iTotalLength
    % Go to the first element
    iCurrPosition = 1;
    
    % Reset value of slider
    set(hObject,'Value', 1);
end

% Get current TIF image full path
currImageFullPath = strcat(currDirectoryPath, currSplitPath, arrStackImages(iCurrPosition));

% Debug information
if debugMode
    disp(currImageFullPath);
end

% Get flag to control MCT
isMCT = get(handles.btRadioYes,'Value');

% Get TIF image data    
[arrDimession, arrColorMap] = imread(currImageFullPath, 'tif');    

% Get image information
imageInfo = imfinfo(currImageFullPath, 'tif');

% Get ratio between width and height
iRatio = imageInfo.Width / imageInfo.Height;

% Create the width and the height of axes    
iWidth = iHeighImageInAxes * iRatio;

% The output image MCTimage is the thresholded image
if isMCT
    [arrDimession] = MCT(arrDimession);
else
    % Get all bits input data
    arrBitContents = cellstr(get(handles.txtFilterNumber,'String'));

    % Get current bit input data
    iBitSize = arrBitContents{get(handles.txtFilterNumber,'Value')};

    % Convert from string to number
    iBitSize = str2double(iBitSize);

    % Check convert bit number
    if iBitSize > 0
        [arrDimession] = MNL(arrDimession, iBitSize);
    end
end

% Change current axes
cla(handles.btGraph,'reset');
axes(handles.btGraph);

% Show image in view
imageHandle = imshow(arrDimession, arrColorMap);

% Set image callback when click
set(imageHandle, 'ButtonDownFcn', {@imageClickCallback, arrStackImages(iCurrPosition), iRatio});

% Resize axes size
set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels', 'Position', [iLeftPaddingInAxes, iBottomPaddingInAxes, iWidth, iHeighImageInAxes]);

% Change title of current image label    
set(handles.lbCurrImage, 'String', arrStackImages(iCurrPosition));

% Set grid on
grid on;

% End initialization code - DO NOT EDIT
end


% --- Executes during object creation, after setting all properties.
function btSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% End initialization code - DO NOT EDIT
end


% --- Executes on button press in btShowStackAuto.
function btShowStackAuto_Callback(hObject, eventdata, handles)
% hObject    handle to btShowStackAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import initialize
import zstack.main.*;
import zstack.util.*;

% Load all global variables
global debugMode;

%% All images in a stack (the depth images)
global arrStackListName;

%% Paused timer
global iTimePaused;

% Change title of current image label
set(handles.lbCurrImage, 'String', 'Loading...');

% Get all stack contents data
arrStackContents = cellstr(get(handles.btListStack,'String'));

% Get current stack in menu
keyName = arrStackContents{get(handles.btListStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current stack: ', keyName));
end

% Get the first image in a stack
arrStackImages = arrStackListName(keyName);

% Loop to show images
for iCurrPosition = 1:length(arrStackImages)
    % Set value for slider data
    set(handles.btSlider, 'Value', iCurrPosition);
    
    % Call slider execution
    btSlider_Callback(handles.btSlider, eventdata, handles);
       
    % Pause some microseconds    
    pause(iTimePaused);
end

% End initialization code - DO NOT EDIT
end


% --- Executes on button press in btShowAll.
function btShowAll_Callback(hObject, eventdata, handles)
% hObject    handle to btShowAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import initialize
import zstack.main.*;

% Load all global variables
global debugMode;

%% All images in a stack (the depth images)
global arrStackListName;

%% Paused timer
global iTimePaused;

% Change title of current image label
set(handles.lbCurrImage, 'String', 'Loading...');

% Get all stack contents data
arrStackContents = cellstr(get(handles.btListStack,'String'));

% Loop to show images
for iLoop = 1:length(arrStackContents)
    % Get current stack in menu
    keyName = arrStackContents{iLoop};
    
    % Set current stack position
    set(handles.btListStack, 'Value', iLoop);
    
    % Debug information
    if debugMode
        disp(strcat('Current stack: ', keyName));
    end

    % Get the first image in a stack
    arrStackImages = arrStackListName(keyName);
    
    % Loop to show images
    for iCurrPosition = 1:length(arrStackImages)
        % Set value for slider data
        set(handles.btSlider, 'Value', iCurrPosition);

        % Call slider execution
        btSlider_Callback(handles.btSlider, eventdata, handles);

        % Pause some microseconds    
        pause(iTimePaused);
    end
end

% End initialization code - DO NOT EDIT
end


% --- Executes on slider movement.
function btSliderAxes_Callback(hObject, eventdata, handles)
% hObject    handle to btSliderAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function btSliderAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btSliderAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% End initialization code - DO NOT EDIT
end


% --- Executes on button press in btRadioYes.
function btRadioYes_Callback(hObject, eventdata, handles)
% hObject    handle to btRadioYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btRadioYes
set(hObject, 'Value', 1);
set(handles.btRadioNo, 'Value', 0);
% End initialization code - DO NOT EDIT
end


% --- Executes on button press in btRadioNo.
function btRadioNo_Callback(hObject, eventdata, handles)
% hObject    handle to btRadioNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of btRadioNo
set(hObject, 'Value', 1);
set(handles.btRadioYes, 'Value', 0);
% End initialization code - DO NOT EDIT
end


% --- Executes on mouse press over axes background.
function lbLogo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lbLogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('https://etool.me/');

% End initialization code - DO NOT EDIT
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lbWebsiteValue.
function lbWebsiteValue_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lbWebsiteValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('https://etool.me/~thpham/');

% End initialization code - DO NOT EDIT
end

function txtFilterNumber_Callback(hObject, eventdata, handles)
% hObject    handle to txtFilterNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFilterNumber as text
%        str2double(get(hObject,'String')) returns contents of txtFilterNumber as a double
set(handles.btRadioNo, 'Value', 1);
set(handles.btRadioYes, 'Value', 0);
% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function txtFilterNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFilterNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on image
function imageRGBClickCallback(hObject , eventdata, imageName)

% Get Plot Size
iPlotSize = get(0,'ScreenSize');

% Create a figure
fgScreen = figure('Toolbar','figure', 'Menubar','none');

% Set attributes for figure
set(fgScreen, 'Color', [1 1 1], 'Position', iPlotSize, 'Visible', 'on', 'Name', imageName);

% Create Axes
axesHandle = axes;

% Set current axes
set(fgScreen,'CurrentAxes', axesHandle);
set(axesHandle, 'Units', 'pixels');
set(fgScreen, 'Units', 'pixels');
set(0, 'Units', 'pixels');

% Get TIF image data
arrDimession = get(hObject,'CData');

% Show image in view
imshow(arrDimession);

% Set grid on
grid on;

% End initialization code - DO NOT EDIT
end

% --- Executes on selection change in popupRedStack.
function popupRedStack_Callback(hObject, eventdata, handles)
% hObject    handle to popupRedStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupRedStack contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupRedStack

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Load all global variables
global debugMode;

% Get all stack contents red data
arrRedStackContents = cellstr(get(handles.popupRedStack,'String'));

% Get current red stack in menu
keyRedStackName = arrRedStackContents{get(handles.popupRedStack,'Value')};

% Get all stack contents blue data
arrBlueStackContents = cellstr(get(handles.popupBlueStack,'String'));

% Get current blue stack in menu
keyBlueStackName = arrBlueStackContents{get(handles.popupBlueStack,'Value')};

% Get all stack contents green data
arrGreenStackContents = cellstr(get(handles.popupGreenStack,'String'));

% Get current green stack in menu
keyGreenStackName = arrGreenStackContents{get(handles.popupGreenStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current red stack: ', keyRedStackName));
    disp(strcat('Current blue stack: ', keyBlueStackName));
    disp(strcat('Current green stack: ', keyGreenStackName));
end

% Check current three stack name
if ((strcmp(keyRedStackName, keyBlueStackName) == true) || (strcmp(keyRedStackName, keyGreenStackName) == true) || (strcmp(keyBlueStackName, keyGreenStackName) == true))
    return;
end

% Reset popup stack menu and label
set(handles.lbImageNumber, 'String', 'Loading...');

% Reset MIN and MAX of slider
set(handles.sliderRGBStack,'Min', 1);
set(handles.sliderRGBStack,'Max', 1);
set(handles.sliderRGBStack,'Value', 1);
set(handles.sliderRGBStack, 'SliderStep', [0.01, 1.0]);

%% All Stack List in Brain
global arrStackList;

%% All images in a stack (the depth images)
global arrStackListName;

% Get all keys of stack data
arrStackListID = keys(arrStackList);

% Get stack length
iStackLength = length(arrStackListID);

% Loop to put data to popup stack menu
if iStackLength > 0
    %% -------------------------------------
    %% Handle the window interface
    %% -------------------------------------
    
    % Get total images
    iTotalImage = arrStackList(keyRedStackName);
    
    % Change MIN and MAX of slider
    set(handles.sliderRGBStack,'Max', iTotalImage);
    set(handles.sliderRGBStack, 'SliderStep', [1/double(iTotalImage - 1), 1/double(iTotalImage - 1)]);
    
    % Get the first image in a red stack
    arrRedStackImages = arrStackListName(keyRedStackName);
    
    % Get current TIF image full path
    currRedImageFullPath = strcat(currDirectoryPath, currSplitPath, arrRedStackImages(1));
    
    % Get the first image in a blue stack
    arrBlueStackImages = arrStackListName(keyBlueStackName);
    
    % Get current TIF image full path
    currBlueImageFullPath = strcat(currDirectoryPath, currSplitPath, arrBlueStackImages(1));
    
    % Get the first image in a green stack
    arrGreenStackImages = arrStackListName(keyGreenStackName);
    
    % Get current TIF image full path
    currGreenImageFullPath = strcat(currDirectoryPath, currSplitPath, arrGreenStackImages(1));
    
    % Debug information
    if debugMode
        disp(currRedImageFullPath);
        disp(currBlueImageFullPath);
        disp(currGreenImageFullPath);
    end
    
    % Plit string to array
    arrStringData = strsplit(currRedImageFullPath, char(keyRedStackName));
    
    % Set image label in stack
    set(handles.lbImageNumber, 'String', arrStringData{2}(2:end));
    
    % Debug information
    if debugMode
        disp(arrStringData);
    end
    
    % Get TIF image data
    [arrDimession] = showRGB(currRedImageFullPath, currBlueImageFullPath, currGreenImageFullPath);
    disp(size(arrDimession));
    
    % Change current axes
    cla(handles.btGraph,'reset');
    axes(handles.btGraph);
                
    % Show image in view
    imageHandle = imagesc(arrDimession);
        
    % Set image callback when click
    set(imageHandle, 'ButtonDownFcn', {@imageRGBClickCallback, arrStringData{2}(2:end)});
    
    % Resize axes size
    set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels');
        
    % Set grid on
    grid on;    
end

% End initialization code - DO NOT EDIT
end


% --- Executes during object creation, after setting all properties.
function popupRedStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupRedStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on selection change in popupRedImage.
function popupRedImage_Callback(hObject, eventdata, handles)
% hObject    handle to popupRedImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupRedImage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupRedImage

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function popupRedImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupRedImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end


% --- Executes on selection change in popupBlueStack.
function popupBlueStack_Callback(hObject, eventdata, handles)
% hObject    handle to popupBlueStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupBlueStack contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupBlueStack

popupRedStack_Callback(hObject, eventdata, handles);

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function popupBlueStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupBlueStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on selection change in popupBlueImage.
function popupBlueImage_Callback(hObject, eventdata, handles)
% hObject    handle to popupBlueImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupBlueImage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupBlueImage

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function popupBlueImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupBlueImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on selection change in popupGreenStack.
function popupGreenStack_Callback(hObject, eventdata, handles)
% hObject    handle to popupGreenStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupGreenStack contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupGreenStack

popupRedStack_Callback(hObject, eventdata, handles);

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function popupGreenStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupGreenStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on selection change in popupGreenImage.
function popupGreenImage_Callback(hObject, eventdata, handles)
% hObject    handle to popupGreenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupGreenImage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupGreenImage

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function popupGreenImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupGreenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% End initialization code - DO NOT EDIT
end

% --- Executes on button press in btShowRBG.
function btShowRBG_Callback(hObject, eventdata, handles)
% hObject    handle to btShowRBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% End initialization code - DO NOT EDIT
end

% --- Executes on button press in btShowRBGAuto.
function btShowRBGAuto_Callback(hObject, eventdata, handles)
% hObject    handle to btShowRBGAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import initialize
import zstack.main.*;
import zstack.util.*;

% Load all global variables
global debugMode;

%% All images in a stack (the depth images)
global arrStackListName;

%% Paused timer
global iTimePaused;

% Change title of current image label
set(handles.lbImageNumber, 'String', 'Loading...');

% Get all stack contents data
arrStackContents = cellstr(get(handles.popupRedStack,'String'));

% Get current stack in menu
keyName = arrStackContents{get(handles.popupRedStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current red stack: ', keyName));
end

% Get the first image in a stack
arrStackImages = arrStackListName(keyName);

% Loop to show images
for iCurrPosition = 1:length(arrStackImages)
    % Set value for slider RGB data
    set(handles.sliderRGBStack, 'Value', iCurrPosition);
    
    % Call slider execution
    sliderRGBStack_Callback(handles.sliderRGBStack, eventdata, handles);
       
    % Pause some microseconds    
    pause(iTimePaused);
end

% End initialization code - DO NOT EDIT
end

% --- Executes on slider movement.
function sliderRGBStack_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRGBStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

% Get current position of slider
iCurrPosition = int32(get(hObject,'Value'));

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Load all global variables
global debugMode;

% Debug information
if debugMode
    disp(strcat('Current position of slider: ', num2str(iCurrPosition)));
end

% Get all stack contents red data
arrRedStackContents = cellstr(get(handles.popupRedStack,'String'));

% Get current red stack in menu
keyRedStackName = arrRedStackContents{get(handles.popupRedStack,'Value')};

% Get all stack contents blue data
arrBlueStackContents = cellstr(get(handles.popupBlueStack,'String'));

% Get current blue stack in menu
keyBlueStackName = arrBlueStackContents{get(handles.popupBlueStack,'Value')};

% Get all stack contents green data
arrGreenStackContents = cellstr(get(handles.popupGreenStack,'String'));

% Get current green stack in menu
keyGreenStackName = arrGreenStackContents{get(handles.popupGreenStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current red stack: ', keyRedStackName));
    disp(strcat('Current blue stack: ', keyBlueStackName));
    disp(strcat('Current green stack: ', keyGreenStackName));
end

% Check current three stack name
if ((strcmp(keyRedStackName, keyBlueStackName) == true) || (strcmp(keyRedStackName, keyGreenStackName) == true) || (strcmp(keyBlueStackName, keyGreenStackName) == true))
    return
end

% Reset popup stack menu and label
set(handles.lbImageNumber, 'String', 'Loading...');

%% All Stack List in Brain
global arrStackList;

%% All images in a stack (the depth images)
global arrStackListName;

% Get all keys of stack data
arrStackListID = keys(arrStackList);

% Get stack length
iStackLength = length(arrStackListID);

% Loop to put data to popup stack menu
if iStackLength > 0
    %% -------------------------------------
    %% Handle the window interface
    %% -------------------------------------
        
    % Get the first image in a red stack
    arrRedStackImages = arrStackListName(keyRedStackName);
    
    % Get current TIF image full path
    currRedImageFullPath = strcat(currDirectoryPath, currSplitPath, arrRedStackImages(iCurrPosition));
    
    % Get the first image in a blue stack
    arrBlueStackImages = arrStackListName(keyBlueStackName);
    
    % Get current TIF image full path
    currBlueImageFullPath = strcat(currDirectoryPath, currSplitPath, arrBlueStackImages(iCurrPosition));
    
    % Get the first image in a green stack
    arrGreenStackImages = arrStackListName(keyGreenStackName);
    
    % Get current TIF image full path
    currGreenImageFullPath = strcat(currDirectoryPath, currSplitPath, arrGreenStackImages(iCurrPosition));
    
    % Debug information
    if debugMode
        disp(currRedImageFullPath);
        disp(currBlueImageFullPath);
        disp(currGreenImageFullPath);
    end
    
    % Plit string to array
    arrStringData = strsplit(currRedImageFullPath, char(keyRedStackName));
    
    % Set image label in stack
    set(handles.lbImageNumber, 'String', arrStringData{2}(2:end));
    
    % Debug information
    if debugMode
        disp(arrStringData);
    end
    
    % Get TIF image data
    [arrDimession] = showRGB(currRedImageFullPath, currBlueImageFullPath, currGreenImageFullPath);
        
    % Change current axes
    cla(handles.btGraph,'reset');
    axes(handles.btGraph);
                
    % Show image in view
    imageHandle = imagesc(arrDimession);
        
    % Set image callback when click
    set(imageHandle, 'ButtonDownFcn', {@imageRGBClickCallback, arrStringData{2}(2:end)});
    
    % Resize axes size
    set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels');
        
    % Set grid on
    grid on;    
end

% End initialization code - DO NOT EDIT
end

% --- Executes during object creation, after setting all properties.
function sliderRGBStack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRGBStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% End initialization code - DO NOT EDIT
end


% --- Executes on button press in btShowCurrFullStack.
function btShowCurrFullStack_Callback(hObject, eventdata, handles)
% hObject    handle to btShowCurrFullStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Import initialize
import zstack.main.*;
import zstack.l3rd.*;
import zstack.util.*;

%% Current Split Path for platform
global currSplitPath;

%% Current directory which contains the brain data
global currDirectoryPath;

% Load all global variables
global debugMode;

%% All images in a stack (the depth images)
global arrStackListName;

%% Height of image in axes
global iHeighImageInAxes;

%% Image Left Padding
global iLeftPaddingInAxes;

%% Image Left Padding
global iBottomPaddingInAxes;

%% Paused timer
global iTimePaused;

% Change title of current image label
set(handles.lbCurrImage, 'String', 'Loading...');

% Pause some microseconds    
pause(iTimePaused);

% Get all stack contents data
arrStackContents = cellstr(get(handles.btListStack,'String'));

% Get current stack in menu
keyName = arrStackContents{get(handles.btListStack,'Value')};

% Debug information
if debugMode
    disp(strcat('Current stack: ', keyName));
end

% Get the first image in a stack
arrStackImages = arrStackListName(keyName);

% Get flag to control MCT
isMCT = get(handles.btRadioYes,'Value');

% Get current TIF image full path
currImageFullPath = strcat(currDirectoryPath, currSplitPath, arrStackImages(1));

% Debug information
if debugMode
    disp(currImageFullPath);
end

% Create bit size
iBitSize = 0;

% Get TIF image data    
[arrDimession] = imread(currImageFullPath, 'tif');

% The output image MCTimage is the thresholded image
if isMCT
    [arrDimession] = MCT(arrDimession);
else
    % Get all bits input data
    arrBitContents = cellstr(get(handles.txtFilterNumber,'String'));

    % Get current bit input data
    iBitSize = arrBitContents{get(handles.txtFilterNumber,'Value')};

    % Convert from string to number
    iBitSize = str2double(iBitSize);

    % Check convert bit number
    if iBitSize > 0
        [arrDimession] = MNL(arrDimession, iBitSize);
    end
end

% Get image information
imageInfo = imfinfo(currImageFullPath, 'tif');

% Get ratio between width and height
iRatio = imageInfo.Width / imageInfo.Height;

% Create the width and the height of axes    
iWidth = iHeighImageInAxes * iRatio;

% Loop to show images
for iCurrPosition = 2:length(arrStackImages)
    % Get current TIF image full path
    currImageFullPath = strcat(currDirectoryPath, currSplitPath, arrStackImages(iCurrPosition));

    % Debug information
    if debugMode
        disp(currImageFullPath);
    end
    
    % Get TIF image data    
    [arrDimessionNext] = imread(currImageFullPath, 'tif');
    
    % The output image MCTimage is the thresholded image    
    if isMCT
        [arrDimessionNext] = MCT(arrDimessionNext);
    else        
        % Check convert bit number
        if iBitSize > 0
            [arrDimessionNext] = MNL(arrDimessionNext, iBitSize);
        end
    end
    
    % Add these matrix
    arrDimession = arrDimession + arrDimessionNext;
end

% Change current axes
cla(handles.btGraph,'reset');
axes(handles.btGraph);

% Convert to RBG
arrDimession = arrDimession./max(max(arrDimession));

% Show image in view
imageHandle = imshow(arrDimession);

% Set image callback when click
set(imageHandle, 'ButtonDownFcn', {@imageClickCallback, keyName, 0});

% Resize axes size
set(handles.btGraph, 'Visible', 'off', 'Units', 'pixels', 'Position', [iLeftPaddingInAxes, iBottomPaddingInAxes, iWidth, iHeighImageInAxes]);

% Change title of current image label    
set(handles.lbCurrImage, 'String', strcat('Current stack:', keyName));

% Set grid on
grid on;

% End initialization code - DO NOT EDIT
end
