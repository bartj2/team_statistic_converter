% Dateiname: main.m
% Projekt: Digitalisierung von Anwesenheitslisten.
% Author: Joel Baertschi und Halil Tuerkkol
% Beschreibung:
%   Diese main-Datei liest ein Bild ein und erstellt daraus eine CSV Datei.
%   Das Bild muss eine Tabelle beinhalten.
%
% *************************************************************************

% Saeubere den Workspace:
clear all; close all;

% Bild Einlesen
IMAGE_PATH = 'Anwesenheitsliste_V4.jpg';
Image = imread(IMAGE_PATH);

%% Linien bestimmen
% bestimmen der Linien im Bild zwecks Erkennung des Tabellenrasters.
Linien = ermittleLinien(Image);


%% OCR fuer den Bereich der Datumsangaben
% Bildausschnitt fuer Datumsangaben ausschneiden:
BildDaten = ermittleBildausschnitt('Daten', Image, Linien);
% imshow(BildDaten)

% versuche alle auftretenden Texte zu identifizieren:
[Texte, textBBoxes] = ermittleTexte(BildDaten, 'Daten');

Zellen = {};
% Zuordnung der gefundenen Texte in Zeilen und Spalten (=Zellen)
Zellen = ermittleZellen(Texte, Linien, Zellen);



%% OCR fuer den Bereich der Zeichen/Symbole (anwesend/nicht anwesend)
% Bildausschnitt fuer Zeichen/Symbole ausschneiden:
BildZeichen = ermittleBildausschnitt('Zeichen', Image, Linien);
% imshow(BildZeichen)

% versuche alle auftretenden Texte zu identifizieren:
[Texte, textBBoxes] = ermittleTexte(BildZeichen, 'Zeichen');

% Zuordnung der gefundenen Texte in Zeilen und Spalten (=Zellen)
Zellen = ermittleZellen(Texte, Linien, Zellen);

%% OCR fuer den Bereich der Spielernamen
% Bildausschnitt fuer Spielernamen ausschneiden:
BildNamen = ermittleBildausschnitt('Namen', Image, Linien);
% imshow(BildNamen)

% versuche alle auftretenden Texte zu identifizieren:
[Texte, textBBoxes] = ermittleTexte(BildNamen, 'Namen');

% Zuordnung der gefundenen Texte in Zeilen und Spalten (=Zellen)
Zellen = ermittleZellen(Texte, Linien, Zellen);


%% Erzeugen der CSV Datei
erstelleCSV(Zellen);
