function [Zellen] = ermittleZellen(Texte, Linien, Zellen)
% Diese Funktion ordnet jeden Text in seine korrekte Zelle anhand der
% Linien (Tabellenraster).

N = length(Texte);
z = 1;

[Hor Vert] = sortiereLinien(Linien);



for i = 1:N
    
    if strcmp(Texte(i).Text, '') == 0 
        % Falls Text nicht leer ist:
        sp = berechneSchwerpunkt(Texte(i).WordBoundingBoxes);
        z = ermittleZeile(Hor, sp);
        s = ermittleSpalte(Vert, sp);
        Zellen{z,s} = Texte(i).Words; % text in Zellen abspeichern.
    end
end

end


function Schwerpunkt = berechneSchwerpunkt(BoundingBox)
% uebergabe: Texte.WordBoundingBoxes!
    Schwerpunkt.x = BoundingBox(1) + 0.5 * BoundingBox(3);
    Schwerpunkt.y = BoundingBox(2) + 0.5 * BoundingBox(4);
end



function [Hor Vert] = sortiereLinien(Linien)
% Diese Funkiton klassifiziert die Linien in horizontale und vertikale 
% Linien und sortiert sie nach Ort im Bild.   
    v = 1;
    h = 1;
    N = length(Linien);
    for i = 1:N
       if Linien(i).theta > 85 || Linien(i).theta < -85
           Hor(h) = Linien(i);
           h = h+1;
       end
       
       
       if Linien(i).theta < 5 && Linien(i).theta > -5
           Vert(v) = Linien(i);
           v = v+1;
       end
    end
    
    %sortieren:
    entries = arrayfun(@(x) x.point1(2), Hor);
    [dummy, idx] = sort(entries);
    Hor = Hor(idx);

    entries = arrayfun(@(x) x.point1(1), Vert);
    [dummy, idx] = sort(entries);
    Vert = Vert(idx);
end





function Zeile = ermittleZeile(LinienHorizontal, Schwerpunkt)
% Diese Funktion berechnet die Zeilennummer des Schwerpunktes eines Textes.
    Zeile = 1;
    N = length(LinienHorizontal);
    i = 1;
    while( Schwerpunkt.y > LinienHorizontal(i).point1(2) && i <N )
        Zeile = i;
        i = i+1;
    end
    
end



function Spalte = ermittleSpalte(LinienVertikal, Schwerpunkt)
% Diese Funktion berechnet die Spaltennummer des Schwerpunktes eines
% Textes.
    Spalte = 1;
    i = 1;
    N = length(LinienVertikal);
    while( Schwerpunkt.x > LinienVertikal(i).point1(1) && i<N ) 
        Spalte = i;
        i = i+1;
    end
end

function VerifizierteZelle = verifiziereZelle(ZelleIn)
% Diese Funktion koennte eine Zelle ueberpruefen, ob deren Inhalt ueberhaupt
% sinnvoll ist.
    VerifizierteZelle = '1';

end

function Zelle = verschmeltzeTexte(Anfang, Ende)
% Falls mehrere Texte einer einzigen Zelle zugeordnet werden, muessten
% diese verschmeltzt/aneinandergehaengt werden.

    Zelle = '1';
end
