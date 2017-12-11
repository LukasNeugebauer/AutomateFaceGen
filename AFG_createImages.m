function [] = AFG_createImages(coords,identity,gender,emotion,varargin)
%AFG_createImages(coords,identity,gender,emotion[,folder][,{id1,id2}][,names])
%
%this function is written to create bmp-images with different combinations
%of identity morphing, gender and emotional expression. The emotion that is
%being manipulated is defined by the coordinate in "coord". Other
%combinations are not possible with this function. 
%
%coords = coordinates for the mouse - is ouput from AFG_getCoord
%
%identity, gender and emotion are expected to be vectors of the same length
%and define the respective position on each dimension. 
%
%optional arguments:
%   
%   folder defines the folder in which the basic identities lie
%       can be chosen via gui if not speficied
%
%   id defines the names of the two basic identities and can be chosen via
%       gui as well. Must be a cell array of size 2
%
%   names is a character cell array of the same length that contains the names
%       under which the images are supposed to be saved. 
%

p.coords    = coords;
p.identity  = identity;
p.gender    = gender;
p.emotion   = emotion;

%handle variable arguments
if nargin > 6 %names for saved images
    if iscell(varargin{3})
        p.names = varargin{3};
    else
        error('names must be specified as cell array');
    end
else
    for x = 1:length(gender)
        names{x} = sprintf('%04d',x);
    end
end
    
if nargin > 4 %folder in which identities are
    p.folder = varargin{1};
else
    fprintf('\nPlease select the folder in which the basic identities are via the pop-up-window\n');
    p.folder  = uigetdir([],'Please select the identity folder');
end
    
if nargin > 5 %definition of basic IDs
    ids = varargin{2};
    p.id1 = ids{1};
    p.id2 = ids{2};
    clear ids;
else
    fprintf('Please select the identities from the pop-up-window\n');
    pid1    = uigetfile('*.fg','Please select the first identity');
    pid2    = uigetfile('*.fg','Please select the second identity');
end

%import robot java class and define it as global so other functions can
%use it as well

import java.awt.Robot;
import java.awt.event.*;
robot = java.awt.Robot;

global robot
    



