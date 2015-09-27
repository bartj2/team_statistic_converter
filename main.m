% file: main.m
% 
% version: see git
% author: Joel Baertschi [bartj2 or bcj1]
% description:
%   This main-file reads in a .jpg image
%
%
% *************************************************************************

% clean workspace
clear all; close all;

% Constants:
IMAGE_PATH = 'Abwesenheitsliste_Selbstgemacht_Eingescannt_rotated.jpg';
F = 1; % Figure number

%% *************** read in the image and preprocess it ********************
% read a .jpg image to the matrix 'Image'
Image = imread(IMAGE_PATH);

iminfo = imfinfo(IMAGE_PATH);

%figure(F);F=F+1;
%image(Image);
%axis equal


% convert image to grayscale
ImageGray = rgb2gray(Image);
%figure(F);F=F+1;
%imshow(ImageGray);


BW1 = edge(ImageGray, 'Canny');
BW2 = edge(ImageGray, 'Prewitt');
figure(F);F=F+1;
imshow(BW2);


%imshowpair(BW1, BW2, 'montage');