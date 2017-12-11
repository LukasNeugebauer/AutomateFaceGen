function [] = AFG_leftMouse(coord,numberOfClicks)
%
%simulates mouse click of the left mouse using the java class "robot"
%coord must be a 1x2 vector (x,y) and defines where to click
%numberOfClicks defines single vs. double click and must be 1 or 2

global robot;

if ~ismember(numberOfClicks,[1,2])
    error('numberOfClicks must be 1 or 2');
end

import java.awt.event.*;
leftMouseKey = java.awt.event.InputEvent.BUTTON1_MASK;%define left mouse key

robot.mouseMove(coord(1),coord(2)); %move mouse to defined position
WaitSecs(0.1); %give computer some time

for x = 1: numberofClicks %https://www.youtube.com/watch?v=oJDGcxAf9D8
    robot.mousePress(leftMouseKey);
    robot.mouseRelease(leftMouseKey);
    WaitSecs(0.05);
end

end