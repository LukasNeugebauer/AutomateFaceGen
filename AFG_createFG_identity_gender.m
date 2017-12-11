function [saveFolder] = AFG_createFG_identity_gender(coord,identity,gender,varargin)
%[] = AFG_createFG_identity_gender(coord,gender,identity[,folder][,{id1,id2}][,names])
%
%creates .fg-Files of different morphing steps between two identities and
%gender steps. These can be further processed using 'AFG_createImages'.
%
%Emotional expression cannot be varied this way bc it is not being saved in
%.fg-files.
%
%Expected input:
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
p.gender    = gender;
p.identity  = identity;

%handle variable arguments
if nargin < 6
    for x = 1:length(p.coord)
        p.names{x} = sprintf('%03d.fg',x);
    end
elseif nargin == 6
    p.names     = names;
end

if ~isequal(length(p.gender,p.identity,p.names))
    error('Gender, identity and names must be of same length');
end
    
if nargin < 4
    fprintf('Please specify the source directory');
    p.folder    = uigetdir([],'Please select the source directory');
else 
    p.folder    = folder;
end

if nargin < 5
    fprintf('Please specify the two basic identities.');
    p.id1    = uigetfile('*.fg','Please select the first identity');
    p.id2    = uigetfile('*.fg','Please select the second identity');
else
    ids     = varargin{2};
    p.id1   = ids{1};
    p.id2   = ids{2};
end

%% General preparations - where to save and so on
%define where files should be saved and save mapping of names to settings
if ~strcmp(folder(end),filesep)
    folder(end+1) = filesep;
end

saveFolder  = [folder,sprintf('newFaces_fg%s',date),filesep,'fg',filesep];
if ~exist(saveFolder,'dir')
    mkdir(saveFolder);
end

filename    = p.names';identity = p.identity';gender = p.gender';
name2set    = table(filename,identity,gender);
name2setFilename = [saveFolder,'names2settings.xlsx'];

if exist(name2setFilename,'file')
    resp   = input(sprintf('%s already exists. Do you want to overwrite?\n',name2setFilename),'s');
    if ~strcmp(resp,'y')
        error('Script aborted, because %s already existed.\n',name2setFilename);
    end
end

writetable(name2set,name2setFilename,'WriteVariableNames',true);

%% Countdown preparation
fprintf(['Please make sure that FaceGen is opened on the same screen where you defined the coordinates.\n',...
         'MATLAB is supposed to be opened on the other screen.\n',...
         'IMPORTANT: Before you start, make sure that the ''Sync Lock'' boxes under the controls for gender\n',...
         'and tween are unticked.\n\n',... 
         'If that is the case, you can start the procedure by pressing any key.\n',...
         'Then, you have 5 seconds to move the mouse to the screen, in which FaceGen is running.']);
     
KbStrokeWait;

for x = fliplr(1:5)
    fprintf('%d\n',x);
    WaitSecs(1);
end

%% The real stuff
for fg = 1:length(names)
    
    AFG_loadID(p.folder,p.id1,p.coords); %load first ID
    AFG_loadTarget(p.folder,p.id2,p.coords);%load target
    AFG_adjustRuler(p.identity(fg),'tween');%morph that shit
    AFG_leftMouse(coords.generate);%move to the 'generate' tab
    AFG_leftMouse(coords.gender);%and to the gender thing
    AFG_adjustRuler(p.gender(fg),'gender');%add gender to the mix
    AFG_saveFG(p.names(fg),saveFolder,coords);
    
end
