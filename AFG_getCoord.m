function [coords] = AFG_getCoord(varargin)
%function [coords] = AFG_getCoord(screen)
%
%Function to derive the necessary coordinates which allow the automatized
%mouse and keyboard program to use the GUI of FaceGen. 
%
%Input argument "screen" defines on which screen you will have the GUI on
%1 means primary display
%2 means secondary display, which is the default.
%
%Might be optional if these have already been derived earlier.
%
%Sometimes old coordinates won't work again, e.g. if you changed the size
%of the displayed face in FaceGen. Or for whatever reason.
%
%This function will assume that you want the ouput saved to the current
%directory you're in. 

%if no screen argument is given, default to 2
if nargin == 0
    coords.screenNum = 2;
else
    coords.screenNum = varargin{1};
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















