function  [strings] = AFG_getCoordStrings
%[strings] = AFG_getCoordStrings
%
%Generate the strings that are being used to guide users through the
%coordinate generation procedure.

strings.intro1      =  ['By clicking on the areas that you will need for the process\n'...
                        'you can determine the relevant locations. Just do as the program\n'...
                        'tells you to do. If you click in the wrong place, you can state this\n'...
                        'after each block and you''ll have to repeat it then.\n\n'...
                        'Only click where and when the program tells you to, otherwise this won''t work!\n\n'...
                        'Press any key to continue\n'];
                    
strings.intro2      =  ['For the following it is assumed that you have the FaceGen Modeller GUI\n'...
                        'opened on the screen that you want to use and MATLAB on another. So it''s\n'... 
                        'only working on a two display setup. Make sure these requirements are met\n'... 
                        'before starting the procedure with any key press.\n'];

strings.pos.repeatFalse =  'No problem, hit any key to repeat the last block and follow the instructions!\n';
                    
strings.pos.file        =  'Please click on the button ''File'' in the upper left corner of the program.\n';

strings.pos.saveImage   =  'Wait a second or two and click on ''Save Image'' in the dropdown menu.\n'; 
                        
strings.pos.adressLine  =  ['A window should have opened. In this window, please click in the adress line on top.\n'...
                        'Do not click into the letters but somewhere in the whitespace on the right of it.\n'];

strings.pos.fileLine    =  ['Now click in the lower field, where you can specify the name of a file.\n'...
                        'Afterwards you can close the pop-up window (NOT the FaceGen GUI though)\n'];  
                    
strings.pos.generate    =  'Next, click on the ''Generate'' tab in the top panel.\n';

strings.pos.gender      =  ['And now on the left (''S'') controller for gender.\n'...
                        'It should appear highlighted by a rectangle afterwards.\n'];
                    
strings.pos.camera      =  'Click on the button ''Camera'' in the top panel\n';

strings.pos.yaw         =  'Now click in the number field right to the control\nfor the yaw angle on the lower part of the window\n.';       

strings.pos.pitch       =  'And now click into the number field for pitch angle, just below the last fields you clicked in.\n';

strings.pos.tween       =  'Now click on the ''Tween'' tab in the top panel.\n';

strings.pos.tweenSteps  =  'And on the ''S'' controller for Symmetry. This should again be highlighted afterwards.';

strings.pos.morph       =  'Next, click on the button ''Morph'' in the top panel.\n';

strings.pos.emotion     =  ['Now click on the number field behind the emotion that you want to manipulate.\n'...
                        'If you want to morph more than one emotion or other aspects, you need to adapt the script'];

strings.done        =  'That''s it. All relevant locations are defined.\n';