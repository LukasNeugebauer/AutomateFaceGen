function [saveFolder] = AFG_createFG_identity(auto,coord,identity,varargin)
%[] = AFG_createFG_identity(auto,coord,identity[,folder][,{id1,id2}][,names][,saveFolder])
%
%creates .fg-Files of different morphing steps between two identities. 
%These can be further processed using 'AFG_createImages'.
%
%Emotional expression cannot be varied this way bc it is not being saved in
%.fg-files. Create FG_files first and use AFG_createImages for that.
%
%Expected input:
%   auto:       defines whether it is the first run and accordingly if the
%               initial procedure is needed (i.e. 0 if you're using this in
%               a loop)
%   coord:      output from AFG_getCoord
%   identity:   column vector of identity values, i.e. morphing steps between two
%               identities
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
%   saveFolder: where to save the created .fg-Files. Defaults to a folder
%               called 'fg' within the sourceFolder
%
%Update 06.06.2018:
%   This is just another version of "AFG_createFG_identity_gender", because 
%   I have to produce faces that differ only on the identity dimension.
%   It's way faster though, because we only need to load source and target
%   face once each and then just adjust the ruler (without resetting it
%   every round)

%% Argument handling
    
    p.coord     = coord;
    p.identity  = asColumn(identity);

    %names of the files to be saved
    if nargin < 6 || isempty(varargin{3})
        names     = cell(numel(p.identity),1);
        for x = 1:length(p.identity)
            names{x} = sprintf('%03d.fg',x);
        end
    else
        names     = varargin{3};
    end
    p.names     = asColumn(names); %just to be sure
    
    if nargin < 4 || isempty(varargin{1})
        fprintf('\nPlease specify the source directory\n');
        p.folder    = uigetdir([],'Please select the source directory');
    else 
        p.folder    = varargin{1};
    end

    if ~strcmp(p.folder(end),filesep)
        p.folder(end+1) = filesep;
    end

    if nargin < 5 || isempty(varargin{2})
        fprintf('Please specify the two basic identities.\n');
        p.id1    = uigetfile('*.fg','Please select the first identity');
        p.id2    = uigetfile('*.fg','Please select the second identity');
    else
        ids     = varargin{2};
        p.id1   = ids{1};
        p.id2   = ids{2};
    end

    if nargin < 7 || isempty(varargin{4})
        saveFolder  = [p.folder,filesep,'fg',filesep];
    else
        saveFolder  = varargin{4};
        if ~strcmp(saveFolder(end),filesep)
            saveFolder  = [saveFolder,filesep];
        end
    end

    %% General preparations - where to save and so on

    if ~isequal(length(p.identity),length(p.names))
        error('Identity and names must be of same length');
    end

    %in case saveFolder already exists, check if you want to use names that are already used.
    if exist(saveFolder,'dir')
        D   = dir([saveFolder,filesep,'*.fg']);
        if numel(D) > 0
            oldFiles    = {D(:).name};
            problem     = any(ismember(oldFiles,p.names));
            if problem
                error(sprintf(['Some of the names for the files you want to save are already used in this folder.\n',...
                       'This will inevitably kill the process because this simple program doesn''t have feedback loops.\n',...
                       'FaceGen will ask for permission to overwrite them, which it will not get because this\n',... 
                       'program just keeps on trying to produce new files.\n\n',...
                       'Delete the files or define other names or another directory to save in and try again.']));
            end
        end
    else
        mkdir(saveFolder);
    end

    filename    = p.names;identity = p.identity;
    name2set    = table(filename,identity);
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

        KbStrokeWait(0);
        clc;

        for x = fliplr(1:5)
            fprintf('\n%d',x);
            WaitSecs(1);
            clc;
        end

    end
    %% The real stuff

    %bring Facegen window into focus
    AFG_leftMouse(p.coord.yaw);
    AFG_loadID(p.folder,p.id1,p.coord); %load first ID
    AFG_loadTarget(p.folder,p.id2,p.coord);%load second ID as target

    %reset ruler once to the lowest value that is being used
    AFG_leftMouse(coord.tweenSteps);
    oldValue    = AFG_adjustRuler(p.identity(1),'tween');

    for fg = 1:length(p.names)

        %AFG_leftMouse(coord.tweenSteps);
        oldValue    = AFG_incrementRuler(p.identity(fg),oldValue);%morph that shit
        AFG_saveFG(p.names{fg},saveFolder,coord);

        %control - check every round if the count of identities has changed to
        %make sure the program is not doing anything weird if out of sync
        %Actually a pretty good idea, now that I see it again :p
        tempDir     = dir([saveFolder,'*.fg']);
        if numel(tempDir) ~= fg
            error('Something''s fishy...');
        end

    end
    
end%end of function