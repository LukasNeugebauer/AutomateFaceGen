function [] = AFG_leftMouse(coord,numberOfClicks)
%
%simulates mouse click of the left mouse using the java class "ROBOT"
%coord must be a 1x2 vector (x,y) and defines where to click
%numberOfClicks defines single vs. double click and must be 1 or 2

global ROBOT;

if ~ismember(numberOfClicks,[1,2])
    error('numberOfClicks must be 1 or 2');
end

if nargin >2
    numberOfClicks = 1;
end

import java.awt.event.*;
leftMouseKey = java.awt.event.InputEvent.BUTTON1_MASK;%define left mouse key

ROBOT.mouseMove(coord(1),coord(2)); %move mouse to defined position
WaitSecs(0.1); %give computer some time

for x = 1: numberOfClicks %https://www.youtube.com/watch?v=oJDGcxAf9D8
    ROBOT.mousePress(leftMouseKey);
    ROBOT.mouseRelease(leftMouseKey);
    WaitSecs(0.05);
end

end