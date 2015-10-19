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

%figure(F);F=F+1; % neues Fenster öffnen
%image(Image);       % Matrix 'Image' als Bild anzeigen.
%axis equal          % Achsen des Bildes fixieren, um keine Verzerrungen zu erhalten. 


% Konvertiere das 'Image' in ein Graustufenbild.
ImageGray = rgb2gray(Image);
%figure(F);F=F+1
%imshow(ImageGray)
Bin = im2bw(ImageGray);
Bin = imcomplement(Bin);
%figure(F);F=F+1;
%imshow(Bin);

% Teste die Funktion edge:
BW = edge(ImageGray, 'Prewitt');
%figure(F);F=F+1;    % Zeige das Bild nach der Funktion edge
%imshow(BW);

%% Teste Houghtransformation:
% a) vor edge
[Hough, Theta, Rho] = hough(Bin, 'RhoResolution', 1, ...
    'ThetaResolution', 1);
figure(F);F=F+1;
imshow(imadjust(mat2gray(Hough)), 'XData', Theta, 'YData', Rho,...
    'InitialMagnification', 'fit');
axis on, axis normal; hold on;
colormap(hot);
title('Houghtransformation vor edge befehl');
xlabel('\theta / deg');
ylabel('\rho / ??');
colorbar;

% use houghpeaks:
Peaks = houghpeaks(Hough, 50);
plot(Theta(Peaks(:,2)),Rho(Peaks(:,1)),'s','color','black');
hold off

% use houghlines:
lines = houghlines(Bin, Theta, Rho, Peaks, 'FillGap', 0.5, 'MinLength', 7);
figure(F); F=F+1;
image(Image), hold on, axis equal
n = length(lines)
for k=1:n
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 1, 'Color', 'blue');

end

% **************************************************************
% b) nach edge
[Hough, Theta, Rho] = hough(BW, 'RhoResolution', 0.5, ...
    'ThetaResolution', 0.5);
figure(F);F=F+1;
imshow(imadjust(mat2gray(Hough)), 'XData', Theta, 'YData', Rho,...
    'InitialMagnification', 'fit');
axis on, axis normal; 
colormap(hot);
title('Houghtransformation nach edge befehl');
xlabel('\theta / deg');
ylabel('\rho / ??');
colorbar;

