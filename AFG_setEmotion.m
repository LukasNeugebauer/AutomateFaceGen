function [] = AFG_setEmotion(value,coord,pos)
%
%function [] = AFG_setEmotion(value,coord)
%
%value defines to which value the emotion should be set
%coord is output from AFG_getCoord
%pos determines wether the "morph" tab must be pressed first

if pos == 1
    AFG_leftMouse(coord.morph);
end

AFG_leftMouse(coord.emotion,2);
clipboard('copy',num2str(value));
AFG_ctrlPlus('v');
AFG_pressAndRelease('Enter');

end