function [] = AFG_setCamera(yaw,pitch,coord)
%
%Define camera settings to the values specified in 'yaw' and 'pitch'
%coord is output from AFG_getCoord;
%fprintf('Set camera to yaw: %s, pitch: %s', num2str(yaw),num2str(pitch))
AFG_leftMouse(coord.camera);
WaitSecs(0.50);
AFG_leftMouse(coord.yaw,2);
WaitSecs(0.3);
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_insertString(num2str(yaw));
WaitSecs(0.3);
AFG_pressAndRelease('Enter');
AFG_leftMouse(coord.pitch,2);
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_pressAndRelease('Backspace');
AFG_insertString(num2str(pitch));
WaitSecs(0.1);
AFG_pressAndRelease('Enter');

WaitSecs(0.5);

end
