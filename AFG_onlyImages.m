function [saveFolder] = AFG_onlyImages(auto,coord,identity,gender,emotion,varargin)
%function [saveFolder] = AFG_onlyImages(auto,coord,identity,gender,emotion[,sourceFolder][,{id1,id2}][,names][,destinationFolder])
%
%this function is written to directly create bmp-images with different
%settings for identity, gender and emotional expresssion. The emotion that 
%is being manipulated is defined by the emotion coordinate in "coord", i.e. 
%if you clicked on "anger" while deriving the coordinates, anger will be
%manipulated.  
%
%auto       =   determines wether initial stuff is needed. Put 1 if you're
%               in a loop and want the program to handle everything on it's
%               own while you're out drinking.
%
%coord      =   coordinates for the mouse - is ouput from AFG_getCoord
%
%identity   =   N x 1 vector that contains settings for the identity slider
%               Expects values between -100 and 100
%
%gender     =   same for gender settings, expects values between -40 and 40
%
%emotion    =   same for settings for emotional expression
%               Expected are values between 0 and 1 or between 0 and 100.
%
%ALL vectors (identity,gender and emotion) have to be the same length. If
%you want several images that have the same settings on one or two of the
%settings, specify so explicitly in the vectors.
%
%optional argument:
%
%   sourceFolder    =   which folder contains the original identities? Has 
%                       to be chosen using GUI if not specified
%
%   {id1,id2}       =   which are the original IDs? Has to be chosen using 
%                       GUI if not specified
%
%   names           =   character cell array that contains the names under 
%                       which the images are supposed to be saved. Defaults
%                       to increasing numbers from 001 to N. This is a
%                       rational choice because pictures are going to be
%                       dedected in the same order everytime a MATLAB
%                       script or Linux or Windows lists files from a
%                       directory.
%
%   destinationFolder = state where you want to have the pictures saved.
%                       Has to be decided via GUI otherwise

%% Handle arguments

p.coord     = coord;
p.auto = auto;
if isrow(gender);gender = gender';end;p.gender    = gender;
if isrow(identity);identity= identity';end;p.identity  = identity;
if isrow(emotion);emotion = emotion';end;p.emotion  = emotion;
%handle emotion values since those can be either 0-1 or 0-100
if min(p.emotion) >= 0 
    if max(p.emotion) > 1 && max(p.emotion) < 100
        p.emotion     = p.emotion ./ 100;
    elseif max(emotion) > 100
        error('Please speficy emotion as fraction or percentages of max (i.e. 0-1 or 0-100)');     
    end
else
    error('Emotion vector must not contain negative values.');
end

%handle variable arguments
if nargin < 8 || isempty(varargin{3})
    p.names     = cell(length(p.gender),1);
    for x = 1:length(p.gender)
        p.names{x} = sprintf('%03d.bmp',x);
    end
elseif nargin == 8
    p.names     = varargin{3};
end

if ~isequal(length(p.gender),length(p.identity),length(p.names))
    error('Gender, identity and names must be of same length');
end
    
if nargin < 6 || isempty(varargin{1})
    fprintf('\nPlease specify the source directory\n');
    p.folder    = uigetdir([],'Please select the source directory');
else 
    p.folder    = varargin{1};
end

if nargin < 7 || isempty(varargin{2})
    fprintf('Please specify the two basic identities.\n');
    p.id1    = uigetfile('*.fg','Please select the first identity');
    p.id2    = uigetfile('*.fg','Please select the second identity');
else
    ids     = varargin{2};
    p.id1   = ids{1};
    p.id2   = ids{2};
end

if nargin < 9 ||isempty(varargin{4})
    fprintf('Please specify where the pictures are supposed to be saved.\n');
    p.destFolder = uigetdir([],'Please select the destination directory.');
else
    p.destFolder    = varargin{4};
    if ~exist(p.destFolder,'dir')
        mkdir(p.destFolder);
        fprintf('Created the directory: ''%s''\n',p.destFolder);
    end
end

%% Run functions
GenPrepare; %general preparations. Where to save, names, stuff like this
if ~p.auto
    Interact;
end
CreateImages;


%% Speficy functions
    function [] = GenPrepare
        p.name2set  = table(p.names,p.identity,p.gender,p.emotion,'VariableNames',{'Names','Identity','Gender','Anger'});
        if ~strcmp(p.folder(end),filesep)
            p.folder(end+1) = filesep;
        end
        if ~strcmp(p.destFolder(end),filesep)
            p.destFolder(end+1) = filesep;
        end
        p.name2setFilename = [p.destFolder,'names2settings.xlsx'];
        if exist(p.name2setFilename,'file')
            resp   = input(sprintf('%s already exists. Do you want to overwrite?\n',p.name2setFilename),'s');
            if ~strcmp(resp,'y')
                error('Script aborted, because %s already existed.\n',p.name2setFilename);
            end
        end
        writetable(p.name2set,p.name2setFilename,'WriteVariableNames',true);
        AFG_initROBOT;%initialize the robot
    end
    
    function [] = Interact
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

    function [] = CreateImages
        %bring FG window into focus
        AFG_leftMouse(p.coord.yaw);
        for x = 1:length(p.names)
            AFG_loadID(p.folder,p.id1,p.coord); %load first ID
            AFG_loadTarget(p.folder,p.id2,p.coord);%load target
            AFG_leftMouse(coord.tweenSteps);
            AFG_adjustRuler(p.identity(x),'tween');%morph that shit
            AFG_leftMouse(coord.generate);%move to the 'generate' tab
            AFG_leftMouse(coord.gender);%and to the gender thing
            AFG_adjustRuler(p.gender(x),'gender');%add gender to the mix
            AFG_setEmotion(p.emotion(x),coord,1);
            AFG_setCamera(0,-10,coord);%adjust camera settings just in case
            AFG_saveImage(p.destFolder,p.names{x},p.coord);
            WaitSecs(0.5);
            
            %control - check every round if the count of identities has changed to
            %make sure the program is not doing anything weird if out of sync
            tempDir     = dir([p.destFolder,'*.bmp']);
            if numel(tempDir) ~= x
                error('Something''s fishy...');
            end
        end
    end

end