function [] = AFG_loadTarget(folder,id,coords)
%
%load target id to morph with the previously loaded ID. 
%
%folder defines the directory where the second ID can be found
%id defines which ID is to be loaded from this folder;
%coords is a structure that contains all relevant coordinates for FaceGen
%buttons. MUST contain fields: 'tween', 'loadTarget', 'adressLine' and
%'fileLine';

%set mouse to the "tween" tab
AFG_leftMouse(coords.tween);
WaitSecs(0.2);
%to 'load Target'
AFG_leftMouse(coords.loadTarget);
WaitSecs(1);%wait for window to open, this is deliberately set to a more generous value because if the robot
            %is faster than FaceGen even once, everything is out of sync
            %and nothing will work. 
AFG_leftMouse(coords.adressLine);
WaitSecs(0.1);
AFG_insertString(folder); %copy folder into adress line
AFG_pressAndRelease('Enter');
WaitSecs(0.1);
AFG_leftMouse(coords.openFile);
AFG_insertString(id); %copy name of second id
AFG_pressAndRelease('Enter');
WaitSecs(1);

end
