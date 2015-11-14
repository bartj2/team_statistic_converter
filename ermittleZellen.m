function [Zellen] = ermittleZellen(Texte, Linien)

N = length(Texte);
Zellen = {};
z = 1;

[Hor Vert] = ermittleLinien(Linien);



for i = 1:N
    
if strcmp(Texte(i).Text, '') == 0
    Texte(i)
    sp = berechneSchwerpunkt(Texte(i).WordBoundingBoxes);
    z = ermittleZeile(Hor, sp);
    s = ermittleSpalte(Vert, sp);
    
    
    Zellen{z,s} = Texte(i).Words;
    
end



end
end


function Schwerpunkt = berechneSchwerpunkt(BoundingBox)
% uebergabe: Texte.WordBoundingBoxes!
    Schwerpunkt.x = BoundingBox(1) + 0.5 * BoundingBox(3);
    Schwerpunkt.y = BoundingBox(2) + 0.5 * BoundingBox(4);
end



function [Hor Vert] = ermittleLinien(Linien)
    
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

    Zeile = 1;
    N = length(LinienHorizontal);
    i = 1;
    while( Schwerpunkt.y > LinienHorizontal(i).point1(2) && i <N )
        Zeile = i;
        i = i+1;
    end
    
end



function Spalte = ermittleSpalte(LinienVertikal, Schwerpunkt)
    Spalte = 1;
    i = 1;
    N = length(LinienVertikal);
    while( Schwerpunkt.x > LinienVertikal(i).point1(1) && i<N ) 
        Spalte = i;
        i = i+1;
    end
end

function VerifizierteZelle = verifiziereZelle(ZelleIn)
    VerifizierteZelle = '1';

end

function Zelle = verschmeltzeTexte(Anfang, Ende)
    Zelle = '1';
end
