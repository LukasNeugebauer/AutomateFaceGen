function [coords] = AFG_getCoord(varargin)
%function [coords] = AFG_getCoord(screen,checkCorr)
%
%Function to derive the necessary coordinates which allow the automatized
%mouse and keyboard program to use the GUI of FaceGen. 
%
%Optional input argument "screen" defines on which screen you will have the GUI on
%1 means primary display
%2 means secondary display, which is the default.
%
%Optional input "checkCorr" defines if one should ask for confirmation in
%for the coordinates of every position and defaults to 1
%
%Sometimes old coordinates won't work again, e.g. if you changed the size
%of the displayed face in FaceGen. Or for whatever reason.
%
%This function will assume that you want the ouput saved to the current
%directory you're in, so change it accordingly. 

%handle optional arguments
if nargin > 2
    error('wrong number of arguments');
elseif nargin == 2
    coords.screenNum = varargin{1};
    checkCorr = varargin{2};
elseif nargin == 1
    coords.screenNum = varargin{1};
    checkCorr = 1;
elseif nargin == 0
    coords.screenNum = 2;
    checkCorr = 1;
end

%get size and positions of the screens
coords.positions                = get(0,'MonitorPositions');
[coords.width,coords.height]    = deal(coords.positions(coords.screenNum,3),coords.positions(coords.screenNum,4));

%folder and name stuff
folder      = [pwd,filesep];
savename    = [folder,'AFG_coordinates.mat']; 

if exist(savename)
    resp = input(sprintf('You already have some FG coordinates saved to this folder.\nAre you sure you want to overwrite them? [y,N]'),'s');
    if ~strcmp(resp,'y')
        error('Procedure aborted.');
    else
        save(savename,'coords');
    end
end

%define strings used for the procedure
strings     = AFG_getCoordStrings;
stringNames = fieldnames(strings.pos);

%welcome messages and wait for key press
fprintf(strings.intro1);
KbStrokeWait;
fprintf(strings.intro2);
KbStrokeWait;

%go through the positions, display message, and save the respective
%position if correctness was confirmed. NOTE: eval is supposed to be an 
%incredibly evil function that is
%not ever to be used. In this case it is really convenient though, so get
%over it, will you?

for dummy = stringNames %actually get the positions
    coords.pos.(dummy) = AFG_getPosition(strings.(dummy),checkCorr);
end
    
end %end of function