function [Texte, textBBoxes] = ermittleTexte( Y, Datentyp )

% Vorverarbeitung
Y = rgb2gray(Y);
H = fspecial('gaussian',10,0.5);
I = imfilter(Y,H,'replicate');

imshow(I);
[mserRegions] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[10 500],'ThresholdDelta',8);
% 'ThresholdDelta' is a numeric value in the range (0,100]. 
%This value is expressed as a percentage of the input data type range used
%in selecting extremal regions while testing for their stability. 
%Decrease this value to return more regions. Typical values range from 0.8 to 4.

figure
imshow(I)
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('MSER regions')
hold off

sz = size(I);
%cellfun: fuehrt eine Funktion bei allen Elementen durch. sub2ind:subscript(tiefstellung)
pixelIdxList = cellfun(@(xy)sub2ind(sz, xy(:,2), xy(:,1)), ...
    mserRegions.PixelList, 'UniformOutput', false);             


mserConnComp.Connectivity = 8;
mserConnComp.ImageSize = sz;
mserConnComp.NumObjects = mserRegions.Count;
mserConnComp.PixelIdxList = pixelIdxList;


mserStats = regionprops(mserConnComp, 'BoundingBox');



%% Step 4: Merge Text Regions For Final Detection Result
% At this point, all the detection results are composed of individual text
% characters. To use these results for recognition tasks, such as OCR, the
% individual text characters must be merged into words or text lines. This
% enables recognition of the actual words in an image, which carry more
% meaningful information than just the individual characters. For example,
% recognizing the string 'EXIT' vs. the set of individual characters
% {'X','E','T','I'}, where the meaning of the word is lost without the
% correct ordering.
%
% One approach for merging individual text regions into words or text lines
% is to first find neighboring text regions and then form a bounding box
% around these regions. To find neighboring regions, expand the bounding
% boxes computed earlier with |regionprops|. This makes the bounding boxes
% of neighboring text regions overlap such that text regions that are part
% of the same word or text line form a chain of overlapping bounding boxes.

% Get bounding boxes for all the regions
bboxes = vertcat(mserStats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Expand the bounding boxes by a small amount.
% expansionAmount_in_x = 0.014;
% expansionAmount_in_y = 0.0045;
% xmin = (1-expansionAmount_in_x) * xmin;%erweitert nach links
% ymin = (1-expansionAmount_in_y) * ymin;
% xmax = (1+expansionAmount_in_x) * xmax;%erweitert nach rechts
% ymax = (1+expansionAmount_in_y) * ymax;

if (strcmp(Datentyp, 'Daten') == 1 )
    xmin = xmin - 22;
    xmax = xmax + 4;
    ymin = ymin - 5;
    ymax = ymax + 2;
else
    xmin = xmin - 3;
    xmax = xmax + 16;
    ymin = ymin - 5;
    ymax = ymax + 3;
end


% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1); %ersetzt alle mit 1, die kleiner als 1 sind. Um Pixelanzahl zu einer ganzen Zahl zu verrunden!!!
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
IExpandedBBoxes = insertShape(I,'Rectangle',expandedBBoxes,'LineWidth',1);

figure
imshow(IExpandedBBoxes)
title('Expanded Bounding Boxes Text')

%%
% Now, the overlapping bounding boxes can be merged together to form a
% single bounding box around individual words or text lines. To do this,
% compute the overlap ratio between all bounding box pairs. This quantifies
% the distance between all pairs of text regions so that it is possible to
% find groups of neighboring text regions by looking for non-zero overlap
% ratios. Once the pair-wise overlap ratios are computed, use a |graph| to
% find all the text regions "connected" by a non-zero overlap ratio.
%
% Use the |bboxOverlapRatio| function to compute the pair-wise overlap
% ratios for all the expanded bounding boxes, then use |graph| to find all
% the connected regions.

% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

% Set the overlap ratio between a bounding box and itself to zero to
% simplify the graph representation.
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);

%%
% The output of |conncomp| are indices to the connected text regions to
% which each bounding box belongs. Use these indices to merge multiple
% neighboring bounding boxes into a single bounding box by computing the
% minimum and maximum of the individual bounding boxes that make up each
% connected component.

% Merge the boxes based on the minimum and maximum dimensions.
%Die überlappte Rechtecke werden zu einem Rechteck zusammengefügt. 
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];

%%
% Finally, before showing the final detection results, suppress false text
% detections by removing bounding boxes made up of just one text region.
% This removes isolated regions that are unlikely to be actual text given
% that text is usually found in groups (words and sentences).

% Remove bounding boxes that only contain one text region
numRegionsInGroup = histcounts(componentIndices);
textBBoxes(numRegionsInGroup == 1, :) = [];

% Show the final text detection result.
ITextRegion = insertShape(I, 'Rectangle', textBBoxes,'LineWidth',3);

figure
imshow(ITextRegion)
title('Detected Text')

%% Step 5: Recognize Detected Text Using OCR
% After detecting the text regions, use the |ocr| function to recognize the
% text within each bounding box. Note that without first finding the text
% regions, the output of the |ocr| function would be considerably more
% noisy.

if strcmp(Datentyp, 'Zeichen')
    results = ocr(I, textBBoxes,'TextLayout','Word','Language','German',...
        'CharacterSet', 'xoXO0');
else
    results = ocr(I, textBBoxes,'TextLayout','Word','Language','German');
end

%[results.Text]

Texte = results;

end