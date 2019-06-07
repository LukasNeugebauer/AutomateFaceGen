function [] = AFG_ctrlPlus(key)
%
%performs the keyboard combination ctrl + 'key'
%

if ~ischar(key) || numel(key) ~= 1
    error('key must be character of length 1');
end

global ROBOT

ctrl    = 17;
events  = {'0','1','2','3','4','5','6','7','8','9','.',':','/','-','_','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
codes   = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 46, 46, 47, 45, 523, 65, 66, 67, 68, 69, 70,71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]; 

if sum(strcmp(events,key)) == 0
    error('invalid key');
else
    thisCode    = codes(strcmp(events,key));
end

ROBOT.keyPress(ctrl);
ROBOT.keyPress(thisCode);
ROBOT.keyRelease(ctrl);
ROBOT.keyRelease(thisCode);

WaitSecs(0.5);

end