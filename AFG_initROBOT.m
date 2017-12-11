function [] = AFG_initROBOT
%
%Import robot class from java and declare it as global. Functions that call
%this function just have to declare ROBOT a global variable and then can
%use all its magic
%

global ROBOT; %declare it as global

import java.awt.Robot;
import java.awt.event.*;
ROBOT = java.awt.Robot;

end