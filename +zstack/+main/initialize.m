%% Z-Stack Image Analysis
%% Description : Initialize
%% Author : Pham Thai Hoa - thaihoabo@gmail.com
%% Created date: 23/02/2014

function initialize()
%% Global debug flag
global debugMode;

%% All Stack List in Brain
global arrStackList;

%% All images in a stack (the depth images)
global arrStackListName;

%% Current directory which contains the brain data
global currDirectoryPath;

%% Current Split Path for platform
global currSplitPath;

%% Current width of figure
global currWidthOfFigure;

%% Height of image in axes
global iHeighImageInAxes;

%% Paused timer
global iTimePaused;

%% Image Left Padding
global iLeftPaddingInAxes;

%% Image Left Padding
global iBottomPaddingInAxes;

%% Set debug mode is TRUE
debugMode = false;

% Create empty map data
arrStackList = containers.Map('KeyType','char','ValueType','int32');    
arrStackListName = containers.Map('KeyType','char','ValueType','any');

% Set current directory default
currDirectoryPath = './';

% Check platform to setup seperate path
if ispc
    currSplitPath = '\';
elseif isunix
    currSplitPath = '/';
elseif ismac
    currSplitPath = '/';    
else
    currSplitPath = '/';
end

% Set current width of figure
currWidthOfFigure = 46;

% Set height of image in axes
iHeighImageInAxes = 560;

%% Set Paused timer
iTimePaused = 1/60;

%% Set Image Left Padding
iLeftPaddingInAxes = 270;

%% Set Image Left Padding
iBottomPaddingInAxes = 0;

end

