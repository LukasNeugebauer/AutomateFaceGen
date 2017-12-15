function [saveFolder] = AFG_createImages(auto,coord,emotion,varargin)
%AFG_createImages(auto,coord,emotion[,sourceFolder][,names])
%
%this function is written to create bmp-images with different amounts
%of emotional expression as speficied in . The emotion that is being 
%manipulated is defined by the emotion coordinate in "coord", i.e. if you 
%clicked on "anger" while deriving the coordinates, anger will be manipulated.  
%
%auto       =   determines wether initial stuff is needed. Put 1 if you're
%               in a loop and want the program to handle everything on it's
%               own while you're out drinking.
%
%coord      =   coordinates for the mouse - is ouput from AFG_getCoord
%
%emotion    =   vector that contains settings for the emotion control. 
%               Expected are values between 0 and 1 or between 0 and 100.
%
%optional argument:
%   
%   names           =   character cell array that contains the names under 
%                       which the images are supposed to be saved.
%
%   sourceFolder    =   directory in which .fg-files are that are supposed 
%                       to be used. This folder is also expected to contain 
%                       an excel-file that contains the mapping of filenames 
%                       on the settings of identity and gender in FaceGen. 
%                       Otherwise the function will throw back an error 
%                       message and not work. If the directory as not
%                       specified as argument, it has to be set per GUI.

%% Handle arguments, check sanity and general preparations

p.coord    = coord;
p.emotion   = emotion;
    
if nargin >= 4 %folder in which identities are
    if ischar(varargin{1})
        p.folder = varargin{1};
    else
       error('SourceFolder must be speficied as string'); 
    end
else
    fprintf('\nPlease select the folder in which the basic identities are via the pop-up-window\n');
    p.folder  = uigetdir([],'Please select the folder for the .fg-files');
end

%make sure folder has a filesep at the end
if ~strcmp(p.folder(end),filesep)
    p.folder(end+1) = filesep;
end

%check if an excel file is present, load into workspace and sanity check
%stuff
p.excel     = dir([p.folder,'*.xlsx']);
if numel(p.excel) ~= 1
    error('Please make sure there is one (and only one) excel file in the folder.');
end

p.name2set  = readtable([p.folder,p.excel.name]);

%handle emotion values
if min(p.emotion) >= 0 
    if max(p.emotion) > 1 && max(p.emotion) < 100
        p.emotion     = p.emotion ./ 100;
    elseif max(emotion) > 100
        error('Please speficy emotion as fraction or percentages of max (i.e. 0-1 or 0-100)');     
    end
else
    error('Emotion vector must not contain negative values.');
end

if isrow(p.emotion) %check if column vector - if not, transpose
    p.emotion = p.emotion';
end

%Create list of present identities and check consistency with table
p.fgList    = dir([p.folder,'*.fg']);
if ~numel(p.fgList) == numel(p.name2set(:,1))
    error('Number of .fg-files does not fit settings in excel file.');
end

%define names
if nargin >=5 %names for saved images
    if iscell(varargin{2})
        names = varargin{2};
    else
        error('names must be specified as cell array');
    end
else
    for x = 1: ( numel(p.emotion) * numel(p.fgList) )
        names{x} = sprintf('%04d.bmp',x);
    end
end
if isrow(names)
    names = names';
end
namesTab = table(names);
p.names   = names;

%expand setting table to emotionality
name2set    = repelem(p.name2set(:,2:end),numel(p.emotion),1);
emo         = table(repmat(p.emotion,numel(p.fgList),1),'VariableNames',{'Emotion'}); 
p.name2set  = [namesTab,name2set,emo];
clear emo namesTab name2set;

%define savefolder, create if necessary, save table
saveFolder = [p.folder,'bmp_emotions',filesep];
if ~exist(saveFolder,'dir')
    mkdir(saveFolder);
end
writetable(p.name2set,[saveFolder,'name2set.xlsx'],'WriteVariableNames',true);

%import ROBOT java class and define it as global so other functions can
%use it as well
AFG_initROBOT;

%% Interaction with user
if ~auto
    clc;
    fprintf(['We''re ready to start.\nPlease make sure that FaceGen is opened',... 
             'in the screen for which you defined the coordinates.\n\n',...
             'DO. NOT. MOVE. THE. MOUSE. during the procedure.\n',... 
             'Consider disconnecting any external mouse - you won''t need it.\n\n.',...
             'Start the procedure with any key and move the cursor to the FaceGen-Screen during the countdown.']);

    %wait for input     
    KbStrokeWait;

    %countdown
    for count = fliplr(1:5)
        clc;
        disp(count);
        WaitSecs(1);
    end
end
%% Actual procedure

%click in the window so that keyboard shortcuts will apply to it
AFG_leftMouse(coord.yaw);

for fg = 1:numel(p.fgList) %loop identities
    
    AFG_loadID(p.folder,p.fgList(fg).name,coord);%load .fg-file
    AFG_setCamera(0,-10,coord);%adjust camera settings just in case
    
    for em = 1:numel(p.emotion) %apply 
        
        runNum  = (fg-1)*numel(p.emotion)+em;
        
        AFG_setEmotion(p.emotion(em),coord,em);
        AFG_saveImage(saveFolder,p.names{runNum},p.coord);
        
        %control loop so the program doesn't accidentally hack into the
        %pentagon while it runs over night and something is out of sync
        WaitSecs(0.5);
        counter     = dir([saveFolder,'*.bmp']);
        if numel(counter) ~= runNum
            error('Something''s fishy...');
        end
        
    end
    
end %end of loop over identities
    
fprintf('Everything done, results are saved in %s\n',saveFolder);

end %end of function