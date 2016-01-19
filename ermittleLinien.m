function [Linien] = ermittleLinien( Image )
% Diese Funktion ermittelt mittels Houghtransformation moegliche Linien,
% welche sich im Bild befinden und gibt diese als Struktur 'Linien'
% zurueck.


%% *************** Bild vorverarbeiten ***********************
F = 1;
% Konvertieren und binarisieren
ImageGray = rgb2gray(Image);
Bin = im2bw(ImageGray);
Bin = imcomplement(Bin);
figure(F);F=F+1;
imshow(Bin);


%% *************** Houghtransformation ***********************
% hough:
[Hough, Theta, Rho] = hough(Bin, 'RhoResolution', 1, ...
    'ThetaResolution', 0.1);

figure(F);F=F+1;
imshow(imadjust(mat2gray(Hough)), 'XData', Theta, 'YData', Rho,...
    'InitialMagnification', 'fit');
axis on, axis normal; hold on;
colormap(hot);
title('Houghtransformation');
xlabel('\theta / deg');
ylabel('\rho / pixel');
colorbar;


% houghpeaks:
Peaks = houghpeaks(Hough, 500, 'Threshold', 0.2*max(Hough(:)), ...
    'NHoodSize', [51, 51]);
plot(Theta(Peaks(:,2)),Rho(Peaks(:,1)),'s','color','green');
hold off

% houghlines:
lines = houghlines(Bin, Theta, Rho, Peaks, 'FillGap', 5, 'MinLength', 800);
figure(F); F=F+1;
image(Image)
hold on
axis equal

% gefundene Linien zeichnen
n = length(lines)
for k=1:n
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'blue');
end
hold off

Linien = lines;

end