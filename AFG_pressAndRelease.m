function [] = AFG_pressAndRelease(key,type)
%
%simulates key press of one key. Key must be speficied as character, even
%when its something like 'Enter' or 'Alt'
%
%type can be 0,1 or 2. 
%   0 means press and release and is default
%   1 means only press
%   2 means only release

if nargin > 1
    type = varargin{1};
elseif nargin == 1 
    type = 0;
end

global ROBOT

keys    = {'Shift','Enter','Ctrl','Alt','Escape','Backspace','0','1','2','3','4','5','6','7','8','9','.',':','/','-','_','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
codes    = [16,10,17,18,27,8,48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 46, 46, 47, 45, 523, 65, 66, 67, 68, 69, 70,71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]; 

if sum(strcmp(keys,key)) == 0
    error('invalid key selected');
else
    code = codes(strcmp(keys,key));
end

if type ~= 2
    ROBOT.keyPress(code);
end
if type ~= 1
    ROBOT.keyRelease(code);
end

end