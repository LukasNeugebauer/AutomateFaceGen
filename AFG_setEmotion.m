function [] = AFG_setEmotion(value,coord,pos,varargin)
%
%function [] = AFG_setEmotion(value,coord,pos[,nEmo])
%
%value defines to which value the emotion should be set
%coord is output from AFG_getCoord
%pos determines wether the "morph" tab must be pressed first
%
%Optional argument nEmo must be given if there is more than one emotion to be
%changed at once. Otherwise it is assumed that there exists only one or you want
%to change the first emotion as per coord structure
if isempty(varargin)
	nEmo = 1;
	if any(strcmp('emotion',fieldnames(coord)))
	       coord.emotion = coord.emotion;
	else
	       try
		       coord.emotion = coord.emotion1;
	       catch
		       error('No appropriate coordinates found.');
	       end
        end
else
	try
		coord.emotion = coord.(['emotion',num2str(varargin{1})]);
	catch
		error('No appropriate coordinates found.');
	end
end
       

if pos == 1
    AFG_leftMouse(coord.morph);
end
	WaitSecs(2);
	AFG_leftMouse(coord.emotion,2);
	AFG_leftMouse(coord.emotion,2);
	AFG_pressAndRelease('Backspace');
	AFG_pressAndRelease('Backspace');
	AFG_pressAndRelease('Backspace');
	clipboard('copy',num2str(round(value,2)));
	WaitSecs(0.2);
	AFG_ctrlPlus('v');
	AFG_pressAndRelease('Enter');

end
