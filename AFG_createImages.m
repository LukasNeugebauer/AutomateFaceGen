function [] = AFG_createImages(coords,identity,gender,emotion,varargin)
%AFG_createImages(coords,identity,gender,emotion[,names])
%
%this function is written to create bmp-images with different combinations
%of identity morphing, gender and emotional expression. The emotion that is
%being manipulated is defined by the coordinate in "coord". Other
%combinations are not possible with this function. 
%
%coords = coordinates for the mouse - is ouput from AFG_getCoord
%
%identity, gender and emotion are expected to be vectors of the same length
%and define the respective position on each dimension. 
%
%names is a character cell array of the same length that contains the names
%under which the images are supposed to be saved. 
%

