% Dateiname: main.m
% Projekt: Digitalisierung von Anwesenheitslisten.
% Version: Siehe Git
% Author: Joel Baertschi [bartj2 or bcj1]
% Beschreibung:
%   Diese main-Datei liest ein Bild ein und bereitet es fuer eine
%   Weiterverarbeitung auf.
%
%
% *************************************************************************

% Säubere den Workspace:
clear all; close all;

% Konstante Variablen:
IMAGE_PATH = 'Abwesenheitsliste_Selbstgemacht_Eingescannt_rotated.jpg';
F = 1; % Figure number

%% *************** Bild einlesen und vorverarbeiten ***********************
% Lies Bild ein und speichere es in Matrix Image.
Image = imread(IMAGE_PATH);

iminfo = imfinfo(IMAGE_PATH); % Informationen zum Bild ausgeben

figure(F);F=F+1; % neues Fenster öffnen
image(Image);       % Matrix 'Image' als Bild anzeigen.
axis equal          % Achsen des Bildes fixieren, um keine Verzerrungen zu erhalten. 


% Konvertiere das 'Image' in ein Graustufenbild.
ImageGray = rgb2gray(Image);
figure(F);F=F+1
imshow(ImageGray)

% Teste die Funktion edge:
BW1 = edge(ImageGray, 'Canny');
BW2 = edge(ImageGray, 'Prewitt');
figure(F);F=F+1;    % Zeige das Bild nach der Funktion edge
imshow(BW2);


figure(F);F=F+1;
histogram(BW2, 20); % Zeige histogramm von BW2

figure(F);F=F+1;
imshowpair(BW1, BW2, 'montage'); % Vergleiche BW1 und BW2

