function [coord] = AFG_getPosition(varargin)
%[x,y] = AFG_GetPosition(string,checkCorr)
%
%Get position on a screen by waiting for mouse click on this location.
%Optional argument "string" displays a string with instructions
%Optional argument "checkCorr" asks for a confirmation of correct behaviour
%and defaults to 0 - no checking

if nargin == 2
    string      = varargin{1};
    checkCorr   = varargin{2};
    checkStr    = 'Are you sure that you hit the right location? [y/N]\n';
elseif nargin == 1
    string = varargin{1};
    checkCorr = 0;
elseif nargin == 0
    string = 'Define a location on the screen by clicking the mouse on it.\n';
else
    error('Wrong number of arguments. Check the .m-File please.');
end

confirmed = 0; %repeat everything if click was not confirmed

while ~confirmed
    [x,y,buttons] = GetMouse; %initial mousetracking
    fprintf(string); %display instruction

    while ~buttons(1) %keep on tracking until the left button is pressed
        [x,y,buttons]   = GetMouse;
    end

    clc;%clear instruction after press
    
    if checkCorr == 1 %ask for confirmation - if not given, repeat loop
        WaitSecs(0.2);commandwindow;
        resp = input(checkStr,'s');
        if strcmp(resp,'y')
            confirmed = 1;
        end
        clc;
    elseif checkCorr == 0 
        confirmed = 1; %default confirmation if none is demanded
    end
end
    
coord   = [x,y]; %define x and y coordinate as output

end