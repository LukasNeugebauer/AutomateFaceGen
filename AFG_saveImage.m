function [] = AFG_saveImage(folder,name,coord,varargin)
%
%function [] = AFG_saveImage(folder,name,coord[,filetype])
%
%folder = where to save
%name   = under which name
%coord  = output from AFG_getCoord
%filetype = which filetype(defaults to .bmp);

if numel(varargin) == 0
    filetype = '.bmp';
elseif numel(varargin) == 1
    filetype = varargin{1};
else
    error('wrong number of arguments');
end

AFG_leftMouse(coord.file);
WaitSecs(0.4);
AFG_leftMouse(coord.saveImage);

WaitSecs(1);

AFG_leftMouse(coord.adressLine);
AFG_insertString(folder);
AFG_pressAndRelease('Enter');
WaitSecs(0.5);
AFG_leftMouse(coord.fileLine);
AFG_insertString(name);
AFG_pressAndRelease('Enter');

end %end of function