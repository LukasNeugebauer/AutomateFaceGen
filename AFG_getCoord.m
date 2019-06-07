function [coords] = AFG_getCoord(varargin)
%function [coords] = AFG_getCoord([screen],[checkCorr],[nEmo][,toName])
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
%Optional input "nEmo" is only necessary if you want to manipulate more than one
%emotion at one. E.g. open smile plus a hint of closed smile.
%
%Optional input "toName" is an option to give a name to the file to be saved, 
%this way you can save multiple different versions in the same folder
%
%Sometimes old coordinates won't work again, e.g. if you changed the size
%of the displayed face in FaceGen. Or for whatever reason.
%
%This function will assume that you want the ouput saved to the current
%directory you're in, so change it accordingly. 

%handle optional arguments
params = {1,2,1,'AFG_coords.mat'};
inp    = ~cellfun(@isempty,varargin);
params(inp) = varargin(inp);
[checkCorr,coords.screenNum,nEmo,toName] = deal(params{:});

%get size and positions of the screens
coords.positions                = get(0,'MonitorPositions');
[coords.width,coords.height]    = deal(coords.positions(coords.screenNum,3),coords.positions(coords.screenNum,4));

%folder and name stuff
folder      = [pwd,filesep];
savename    = [folder,toName]; 

if exist(savename)
    resp = input(sprintf('You already have some FG coordinates saved to this folder.\nAre you sure you want to overwrite them? [y,N]'),'s');
    if ~strcmp(resp,'y')
        error('Procedure aborted.');
    else
        save(savename,'coords');
    end
end

%define strings used for the procedure
strings     = AFG_getCoordStrings(nEmo);
stringNames = fieldnames(strings.pos);

%welcome messages and wait for key press
clc;fprintf(strings.intro1);
KbStrokeWait(0);
clc;fprintf(strings.intro2);
KbStrokeWait(0);

%go through the positions, display message, and save the respective
%position if correctness was confirmed. 

confirmed = 0; %variable that keeps script from continuing without confirmation

while ~confirmed
    for dummy = stringNames' %actually get the positions
        coords.pos.(dummy{1}) = AFG_getPosition(strings.pos.(dummy{1}));
        if sum(strcmp(dummy{1},{'fileLine','loadTarget','openFile'})) > 0 %let subjects close the pop-up window
            fprintf('Please close the pop-up-window before we proceed\n');
            button = 0;
            while ~button(1);[~,~,button] = GetMouse;end;
            while any(button);[~,~,button] = GetMouse;end
        end
    end
    WaitSecs(0.5);
    if checkCorr == 1
        WaitSecs(1);
        commandwindow;
        resp = input('Are you sure that you hit all the right locations? [y/n]\nYou might have to click into the command window to answer..\n','s');
        if strcmp(resp,'y')
            confirmed = 1;
        end
    elseif checkCorr == 0
        confirmed = 1;
    end
end
%save end result
save(savename,'coords');

end %end of function
