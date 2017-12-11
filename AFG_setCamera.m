function [] = AFG_setCamera(yaw,pitch,coord)
%
%Define camera settings to the values specified in 'yaw' and 'pitch'
%coord is output from AFG_getCoord;

AFG_leftMouse(coord.camera);
AFG_leftMouse(coord.yaw);
AFG_insertString(num2str(yaw));
AFG_pressAndRelease('Enter');
AFG_leftMouse(coord.pitch);
AFG_insertString(num2str(pitch));
AFG_pressAndRelease('Enter');

WaitSecs(0.5);

end