function [] = AFG_saveFG(name,folder,coords)
%
%save the new identity to a .fg-File. 

AFG_ctrlPlus('s');
AFG_leftMouse(coords.adressLine);
AFG_insertString(folder);
AFG_pressAndRelease('Enter');
AFG_leftMouse(coords.fileLine);
AFG_insertString(name);
AFG_pressAndRelease('Enter');

WaitSecs(0.5);

end