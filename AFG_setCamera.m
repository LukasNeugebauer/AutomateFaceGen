function [] = AFG_setCamera(yaw,pitch,coord)
%
%Define camera settings to the values specified in 'yaw' and 'pitch'
%coord is output from AFG_getCoord;

AFG_leftMouse(coord.camera);
AFG_leftMouse(coord.yaw,2);
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_insertString(num2str(yaw));
AFG_pressAndRelease('Enter');
AFG_leftMouse(coord.pitch,2);
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_insertString(num2str(pitch));
AFG_pressAndRelease('Enter');

WaitSecs(0.5);

end