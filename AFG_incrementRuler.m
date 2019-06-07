function [newValue,increment] = AFG_incrementRuler(newValue,oldValue)
%
%simpler version of 'AFG_adjustRuler'. This one will not reset the ruler
%but just go from the old to the new setting.
%
%'oldValue' is the setting that is is in before changing it
%'newValue' is the setting that is aimed for
%
%For now, this works just for identity morphing, but it can easily be
%adjusted to gender. I'm just too lazy today and need to get this running.
%
%06.06.2018 - Lukas Neugebauer

    global ROBOT;

    KbName('UnifyKeyNames');

    %check if both are applicable and make them if not.
    if sum(mod([newValue,oldValue],1))
        fprintf('Will change values to natural numbers.\n');
        [newValue,oldValue]     = deal(round(newValue),round(oldValue));
    end

    increment   = newValue - oldValue; %we don't take non-integers

    if increment > 0
        bigStepKey      = KbName('pageDown');
        smallStepKey    = KbName('DownArrow');
    elseif increment < 0
        bigStepKey      = KbName('pageUp');
        smallStepKey    = KbName('UpArrow');
    end

    bigSteps    = floor(increment/10);
    smallSteps  = mod(increment,10);

    %apply adjustments
    for x = 1:bigSteps
        ROBOT.keyPress(bigStepKey);
        ROBOT.keyRelease(bigStepKey);
        WaitSecs(0.01);
    end
    for x = 1:smallSteps
        ROBOT.keyPress(smallStepKey);
        ROBOT.keyRelease(smallStepKey);
        WaitSecs(0.01);
    end

    WaitSecs(0.5);

end