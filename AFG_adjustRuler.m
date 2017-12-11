function [] = AFG_adjustRuler(value,type)
%
%Set control for gender or tween between two identities to the new value
%defined in 'value'. 
%
%'type' is either 'gender' or 'tween';
global ROBOT;

if strcmp(type,'gender')
    maxRange        = [-40,40];
    setBackSteps    = 8;
elseif strcmp(type,'tween')
    maxRange        = [-100,100];
    setBackSteps    = 20;
else
    error('invalid type defined');
end

%define the keys 
[pageDown,pageUp,keyDown,keyUp] = deal(34,33,40,38);

%set control back to zero
for x = 1:setBackSteps 
    ROBOT.keyPress(pageUp);
    ROBOT.keyRelease(pageUp);
end

%make new value applicable and break it down into KB events
newSet      = value - min(maxRange);
bigSteps    = floor(newSet./10);
smallSteps  = mod(newSet,10);

%apply adjustments
for x = 1:bigSteps
    ROBOT.keyPress(pageDown);
    ROBOT.keyRelease(pageUp);
    WaitSecs(0.01);
end

for x = 1:smallSteps
    ROBOT.keyPress(kbDown);
    ROBOT.keyRelease(kbDown);
    WaitSecs(0.01);
end

end