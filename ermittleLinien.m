function [Linien] = ermittleLinien( Image )

F = 1; % Figure number

%% *************** Bild vorverarbeiten ***********************

% Konvertiere das 'Image' in ein Graustufenbild.
ImageGray = rgb2gray(Image);
%figure(F);F=F+1
%imshow(ImageGray)
Bin = im2bw(ImageGray);
Bin = imcomplement(Bin);
figure(F);F=F+1;
imshow(Bin);



% Teste die Funktion edge:
BW = edge(ImageGray, 'Prewitt');
%figure(F);F=F+1;    % Zeige das Bild nach der Funktion edge
%imshow(BW);

%% Teste Houghtransformation:
% a) vor edge
[Hough, Theta, Rho] = hough(Bin, 'RhoResolution', 1, ...
    'ThetaResolution', 0.1);
figure(F);F=F+1;
imshow(imadjust(mat2gray(Hough)), 'XData', Theta, 'YData', Rho,...
    'InitialMagnification', 'fit');
axis on, axis normal; hold on;
colormap(hot);
title('Houghtransformation vor edge befehl');
xlabel('\theta / deg');
ylabel('\rho / ??');
colorbar;

%max = find(Hough==max(Hough(:)))
% use houghpeaks:
Peaks = houghpeaks(Hough, 500, 'Threshold', 0.2*max(Hough(:)), 'NHoodSize', [51, 51]);
plot(Theta(Peaks(:,2)),Rho(Peaks(:,1)),'s','color','green');
hold off

% use houghlines:
lines = houghlines(Bin, Theta, Rho, Peaks, 'FillGap', 5, 'MinLength', 800);
figure(F); F=F+1;
image(Image)
hold on
axis equal
n = length(lines)
for k=1:n
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'blue');

end
hold off

Linien = lines;

end