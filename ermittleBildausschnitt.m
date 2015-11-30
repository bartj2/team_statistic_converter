function Bildausschnitt = ermittleBildausschnitt(Kategorie, Image, Linien)

[Hor Vert] = ermittleLinien(Linien);

if strcmp(Kategorie, 'Namen')
    Idx = ermittleIdx(Hor, Vert, 2, length(Hor), 1, 3);
elseif strcmp(Kategorie, 'Zeichen')
    Idx = ermittleIdx(Hor, Vert, 2, length(Hor), 3, length(Vert));
elseif strcmp(Kategorie, 'Daten')
    Idx = ermittleIdx(Hor, Vert, 1, 2, 3, length(Vert));
end

dim = size(Image);
Bildausschnitt = uint8(ones(dim(1),dim(2),dim(3))).*255;
Bildausschnitt(Idx(1):Idx(2),Idx(3):Idx(4),:) = Image(Idx(1):Idx(2),Idx(3):Idx(4),:);
end


% HorStart = Liniennummer aus der Menge der Horizonalen Linien, bei welcher 
% der Bildausschnitt beginnen soll.
function Idx = ermittleIdx(Hor, Vert, HorStart, HorEnd, VertStart, VertEnd);
xstart = max([Vert(VertStart).point1(1), Vert(VertStart).point2(1)]);
xend = min([Vert(VertEnd).point1(1),Vert(VertEnd).point2(1)]);
ystart = max([Hor(HorStart).point1(2), Hor(HorStart).point2(2)]);
yend = min([Hor(HorEnd).point1(2), Hor(HorEnd).point2(2)]);
% pause
Idx = [ystart,yend,xstart,xend];
    
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