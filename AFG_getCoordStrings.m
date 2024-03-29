function  [strings] = AFG_getCoordStrings(nEmo);
%[strings] = AFG_getCoordStrings
%
%optional argument nEmo defines if you want to get coordinates for multiple emo
%tions at once
%Generate the strings that are being used to guide users through the
%coordinate generation procedure.

if ~exist('nEmo','var')
	nEmo = 1;
end


strings.intro1      =  ['By clicking on the areas that you will need for the process\n'...
                        'you can determine the relevant locations. Just do as the program\n'...
                        'tells you to do. If you click in the wrong place at least once,\n'... 
                        'you can state this after the run through all locations.\n'...
                        'In this case you''ll have to repeat all of them.\n\n'...
                        'Only click where and when the program tells you to, otherwise this won''t work!\n\n'...
                        'Press any key to continue\n'];
                    
strings.intro2      =  ['For the following it is assumed that you have the FaceGen Modeller GUI\n'...
                        'opened on the screen that you want to use and MATLAB on another. So it''s\n'... 
                        'only working on a two display setup. Make sure these requirements are met\n'... 
                        'before starting the procedure with any key press.\n'];
                    
strings.pos.file        =  'Please click on the button ''File'' in the upper left corner of the program.\n';

strings.pos.saveImage   =  'Click on ''Save Image'' in the dropdown menu.\n'; 
                        
strings.pos.adressLine  =  ['A window should have opened. In this window, please click in the adress line on top.\n'...
                            'Do not click into the letters but on the far right of it.\n'];

strings.pos.fileLine    =  ['Now click in the lower field, where you can specify the name of a file.\n'...
                        'Afterwards you can close the pop-up window (NOT the FaceGen GUI though)\n'];  
                    
strings.pos.openFile    = ['Please press the keyboard combination ''Ctrl + O'' and wait for a window to open.\n',...
                           'Once it has opened, click in the lower text field where you specify the file name.\n',...
                           'Afterwards you can close the pop-up-window again.\n'];
                    
strings.pos.generate    =  'Next, click on the ''Generate'' tab in the top panel.\n';

strings.pos.gender      =  ['And now on the left (''S'') controller for gender.\n'...
                        'It should appear highlighted by a rectangle afterwards.\n'];
                    
strings.pos.camera      =  'Click on the button ''Camera'' in the top panel\n';

strings.pos.yaw         =  'Now click in the number field right to the control\nfor the yaw angle on the lower part of the window\n.';       

strings.pos.pitch       =  'And now click into the number field for pitch angle, just below the last fields you clicked in.\n';

strings.pos.tween       =  'Now click on the ''Tween'' tab in the top panel.\n';

strings.pos.loadTarget  =  'Now click on the ''Load Target'' button in the middle of the window.\n';

strings.pos.tweenSteps  =  'And on the ''S'' controller for Symmetry. This should again be highlighted afterwards.';

strings.pos.morph       =  'Next, click on the button ''Morph'' in the top panel.\n';

if nEmo == 1
	strings.pos.emotion     =  ['Now click on the number field behind the emotion that you want to manipulate.\n'...
				'If you want to morph more than one emotion or other aspects, you need to adapt the script'];
else
	for i = 1:nEmo
		strings.pos.(sprintf('emotion%d',i)) = [sprintf('Now click on the emotion #%d that you want to manipulate', i)];
	end
end

strings.done        =  'That''s it. All relevant locations are defined.\n';
