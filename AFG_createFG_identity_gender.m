function [saveFolder] = AFG_createFG_identity_gender(auto,coord,identity,gender,varargin)
%[] = AFG_createFG_identity_gender(coord,gender,identity[,folder][,{id1,id2}][,names])
%
%creates .fg-Files of different morphing steps between two identities and
%gender steps. These can be further processed using 'AFG_createImages'.
%
%Emotional expression cannot be varied this way bc it is not being saved in
%.fg-files.
%
%Expected input:
%   auto:       defines whether it is the first run and accordingly if the
%               initial procedure is needed (i.e. 0 if you're using this in
%               a loop)
%   coord:      output from AFG_getCoord
%   identity:   column vector of identity values, i.e. morphing steps between two
%               identities
%   gender:     values for the gender control in FaceGen 
%   rows of identity and gender belong together.
%
%Optional arguments
%   folder:     specifies directory in which basic identities are saved.
%               Will be specified via GUI if not given. 
%   {id1,id2}:  specifies the names of the two basic identities  - must be
%               cell of size 2. Will also be done per GUI if not given
%   names:      must be cell array of same size as identity and gender and 
%               contains names under which the new identities are being 
%               saved. Is consecutive numbers if not specified. An 
%               excel-file will be saved that contains the mapping of names 
%               to FG settings%   


%% Argument handling

p.coord     = coord;
if isrow(gender);gender = gender';end;p.gender    = gender;
if isrow(identity);identity= identity';end;p.identity  = identity;

%handle variable arguments
if nargin < 7
    for x = 1:length(p.gender)
        p.names{x} = sprintf('%03d.fg',x);
    end
elseif nargin == 6
    p.names     = varargin{3};
end

if ~isequal(length(p.gender),length(p.identity),length(p.names))
    error('Gender, identity and names must be of same length');
end
    
if nargin < 5
    fprintf('\nPlease specify the source directory\n');
    p.folder    = uigetdir([],'Please select the source directory');
else 
    p.folder    = varargin{1};
end

if nargin < 6
    fprintf('Please specify the two basic identities.\n');
    p.id1    = uigetfile('*.fg','Please select the first identity');
    p.id2    = uigetfile('*.fg','Please select the second identity');
else
    ids     = varargin{2};
    p.id1   = ids{1};
    p.id2   = ids{2};
end

%% General preparations - where to save and so on
%define where files should be saved and save mapping of names to settings
if ~strcmp(p.folder(end),filesep)
    p.folder(end+1) = filesep;
end

saveFolder  = [p.folder,sprintf('bmp',p.id1,p.id2),filesep,'fg',filesep];
if exist(saveFolder,'dir')
   rmdir(saveFolder,'s');
end

mkdir(saveFolder);

if isrow(p.names);p.names = p.names';end;

filename    = p.names;identity = p.identity;gender = p.gender;
name2set    = table(filename,identity,gender);
name2setFilename = [saveFolder,'names2settings.xlsx'];

if exist(name2setFilename,'file')
    resp   = input(sprintf('%s already exists. Do you want to overwrite?\n',name2setFilename),'s');
    if ~strcmp(resp,'y')
        error('Script aborted, because %s already existed.\n',name2setFilename);
    end
end

writetable(name2set,name2setFilename,'WriteVariableNames',true);

%% JAVA preparations - create our ROBOT
AFG_initROBOT;

%% Countdown preparation
if ~auto
    
    clc;
    fprintf(['Please make sure that FaceGen is opened on the same screen\n',... 
             'where you defined the coordinates. MATLAB is supposed to be\n',... 
             'opened on the other screen.\n\n',...
             'IMPORTANT: Before you start, make sure that the ''Sync Lock''\n',... 
             'boxes under the controls for gender and tween are unticked.\n\n',... 
             'If that is the case, you can start the procedure by pressing any key.\n',...
             'Then, you have 5 seconds to move the mouse to the screen,\n',... 
             'in which FaceGen is running.']);

    KbStrokeWait;

    for x = fliplr(1:5)
        fprintf('\n%d',x);
        WaitSecs(1);
    end

end
%% The real stuff

%bring Facegen window into focus
AFG_leftMouse(p.coord.yaw);

for fg = 1:length(p.names)
  
    AFG_loadID(p.folder,p.id1,p.coord); %load first ID
    AFG_loadTarget(p.folder,p.id2,p.coord);%load target
    AFG_leftMouse(coord.tweenSteps);
    AFG_adjustRuler(p.identity(fg),'tween');%morph that shit
    AFG_leftMouse(coord.generate);%move to the 'generate' tab
    AFG_leftMouse(coord.gender);%and to the gender thing
    AFG_adjustRuler(p.gender(fg),'gender');%add gender to the mix
    AFG_saveFG(p.names{fg},saveFolder,coord);
    
    %control - check every round if the count of identities has changed to
    %make sure the program is not doing anything weird if out of sync
    tempDir     = dir([saveFolder,'*.fg']);
    if numel(tempDir) ~= fg
        error('Something''s fishy...');
    end
    
end
end%end of function