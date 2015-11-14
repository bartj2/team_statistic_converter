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

%% *************** Bild einlesen und vorverarbeiten ***********************
% Lies Bild ein und speichere es in Matrix Image.
Image = imread(IMAGE_PATH);

iminfo = imfinfo(IMAGE_PATH); % Informationen zum Bild ausgeben
Linien = ermittleLinien(Image);
[Texte, textBBoxes] = ermittleTexte(Image);
Zellen = ermittleZellen(Texte, Linien);
erstelleCSV(Zellen);
