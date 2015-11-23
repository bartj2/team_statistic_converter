function Bildausschnitt = ermittleBildausschnitt(Kategorie, Image, Linien)

[Hor Vert] = ermittleLinien(Linien);

if strcmp(Kategorie, 'Namen')
    Idx = ermittleIndexe(Hor, Vert, 1, 3, 2, length(Vert));
end

dim = size(Image);
Bildausschnitt = uint8(zeros(dim(1),dim(2),dim(3)));
Bildausschnitt(Idx(1):Idx(2),Idx(3):Idx(4),:) = Image(Idx(1):Idx(2),Idx(3):Idx(4),:);
end



function Indexe = ermittleIndexe(Hor, Vert, HorStart, HorEnd, VertStart, VertEnd)

Indexe = [338,1243,210,739];
    
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