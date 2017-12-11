function [] = AFG_insertString(string)
%[] = AFG_insertString(string);
%
%inserts the string defined in 'string', a.k.a. performs ctrl-c and ctrl-v

clipboard('copy',string);
WaitSecs(0.1);%prevent CPU bottleneck
AFG_ctrlPlus('v');

end