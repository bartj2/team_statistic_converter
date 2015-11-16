% Dateiname: main.m
% Projekt: Digitalisierung von Anwesenheitslisten.
% Version: Siehe Git
% Author: Joel Baertschi [bartj2 oder bcj1]
% Beschreibung:
%   Diese main-Datei liest ein Bild ein und erstellt daraus eine CSV Datei.
%   Das Bild sollte Tabellenfoermig sein und keine perspektivische
%   Verzerrungen aufweisen.
%
% *************************************************************************

% Saeubere den Workspace:
clear all; close all;

% Bild Einlesen
IMAGE_PATH = 'Abwesenheitsliste_Selbstgemacht_Eingescannt_rotated.jpg';
Image = imread(IMAGE_PATH);
iminfo = imfinfo(IMAGE_PATH); % Informationen zum Bild ausgeben

% versuche Linien der Tabelle zu erkennen:
Linien = ermittleLinien(Image);

% versuche alle auftretenden Texte zu identifizieren:
[Texte, textBBoxes] = ermittleTexte(Image);

% Bestimme die Zeilen und Spalten der Texte innerhalb der Tabelle:
Zellen = ermittleZellen(Texte, Linien);

% Erzeuge die CSV Datei:
erstelleCSV(Zellen);
