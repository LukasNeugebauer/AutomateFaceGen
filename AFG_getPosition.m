function [coord] = AFG_getPosition(varargin)
%[x,y] = AFG_GetPosition(string,checkCorr)
%
%Get position on a screen by waiting for mouse click on this location.
%Optional argument "string" displays a string with instructions

if nargin == 0
    string = 'Define a location on the screen by clicking the mouse on it.\n';
elseif nargin == 1 
    string = varargin{1};
else 
    error('wrong number of arguments. Please check the .m-File');
end

clc;
fprintf(string); %display instruction
[x,y,buttons] = GetMouse; %initial mousetracking

while ~buttons(1) %keep on tracking until the left button is pressed
    [x,y,buttons]   = GetMouse;
end

while any(buttons)%wait for release of all buttons
    [~, ~, buttons] = GetMouse;
end 

clc;%clear instruction after press
coord   = [x,y]; %define x and y coordinate as output

end