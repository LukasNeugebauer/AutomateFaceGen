function [] = AFG_loadID(folder,id,coords)
%
%load first ID in FaceGen - id must be a character string that defines the
%name of the ID to be loaded
%

AFG_ctrlPlus('n'); %new face - will delete any previously changed settings
WaitSecs(0.5);
AFG_ctrlPlus('o'); %load new identity - this opens a pop-up-window, which is why we'll wait
WaitSecs(1); %this might seem overly generous but will assure that the programs is not out of sync with facegen anytime

AFG_leftMouse(coords.adressLine);
WaitSecs(0.1);
AFG_insertString(folder);
AFG_pressAndRelease('Enter');
AFG_leftMouse(coords.openFile);
WaitSecs(0.1);
AFG_insertString(id);
AFG_pressAndRelease('Enter');
WaitSecs(0.5);

end