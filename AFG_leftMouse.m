function [] = AFG_leftMouse(coord,varargin)
%[] = AFG_leftMouse(coord[,numberOfClicks])
%simulates mouse click of the left mouse using the java class "ROBOT"
%coord must be a 1x2 vector (x,y) and defines where to click
%numberOfClicks defines single vs. double click and must be 1 or 2
%default is 1

global ROBOT;

if nargin == 1
    numberOfClicks = 1;
elseif nargin == 2
    numberOfClicks = varargin{1};
else
    error(['numberOfClicks must be 1 or 2. This is assuming that you actually meant one of these options\n.',...
           'Otherwise change the code. Hint: It''s only one character that needs to be changed.']);
end

import java.awt.event.*;
leftMouseKey = java.awt.event.InputEvent.BUTTON1_MASK;%define left mouse key 

ROBOT.mouseMove(coord(1),coord(2)); %move mouse to defined position
WaitSecs(0.05); %give computer some time

for x = 1: numberOfClicks %https://www.youtube.com/watch?v=oJDGcxAf9D8
    ROBOT.mousePress(leftMouseKey);
    ROBOT.mouseRelease(leftMouseKey);
    WaitSecs(0.05);
end

WaitSecs(0.1);

end