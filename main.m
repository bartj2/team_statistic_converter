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


%% Daten
BildDaten = ermittleBildausschnitt('Daten', Image, Linien);
imshow(BildDaten)

% versuche alle auftretenden Texte zu identifizieren:
[Texte, textBBoxes] = ermittleTexte(BildDaten, 'Daten');

Zellen = {};
% Bestimme die Zeilen und Spalten der Texte innerhalb der Tabelle:
Zellen = ermittleZellen(Texte, Linien, Zellen);



%% Zeichen
BildZeichen = ermittleBildausschnitt('Zeichen', Image, Linien);
imshow(BildZeichen)
[Texte, textBBoxes] = ermittleTexte(BildZeichen, 'Zeichen');
Zellen = ermittleZellen(Texte, Linien, Zellen);

%% Namen
BildNamen = ermittleBildausschnitt('Namen', Image, Linien);
imshow(BildNamen)
[Texte, textBBoxes] = ermittleTexte(BildNamen, 'Namen');
Zellen = ermittleZellen(Texte, Linien, Zellen);



% Erzeuge die CSV Datei:
erstelleCSV(Zellen);
