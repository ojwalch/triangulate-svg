function triangulate(filename,p)
close all;

% Read image
img = imread(filename);
if(size(img,3) > 1)
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% Create output SVG header
fid = fopen([filename(1:end-4) '.svg'],'w');
fprintf(fid,'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n');
fprintf(fid,['<svg xmlns="http://www.w3.org/2000/svg" version="1.200000" width="100%%" height="100%%" viewBox="0 0 ' int2str(size(img_gray,2) + 1) ' ' int2str(size(img_gray,1) + 1) '" xmlns:xlink="http://www.w3.org/1999/xlink">']);
fprintf(fid,'<g stroke="none" stroke-width="0" shape-rendering="crispEdges">\n');

% Perfom corner detection; another option: corners = corner(img_gray,'MinimumEigenvalue',p);
corners = corner(img_gray,'Harris',p,'SensitivityFactor',5e-2, 'QualityLevel',1e-3);

% Add image corners to corner list; 
corners = [corners; 
            0 0; 
            0 size(img_gray,1);
            size(img_gray,2) size(img_gray,1); 
            size(img_gray,2) 0];

        
% Optionally add random points to pad out points
numRand = 100; 
randomPoints = [rand(numRand,1)*size(img_gray,2) rand(numRand,1)*size(img_gray,1)];
corners = [corners; randomPoints];

% Show baseline gray image
imshow(img_gray); hold on;


% Get triangulation
dt = delaunayTriangulation(corners);

for i = 1:length(dt.ConnectivityList)
    
    % Get indices of each triangle's centroid 
    ind1 = floor(mean(dt.Points(dt.ConnectivityList(i,:),1))) + 1;
    ind2 = floor(mean(dt.Points(dt.ConnectivityList(i,:),2))) + 1;
    
    % Fill in triangulation with mean value from color image
    fillColor = double(img(ind2,ind1,:));
    if(length(fillColor) == 1)
        fillColor = [fillColor fillColor fillColor];
    end
    
    f = fill(dt.Points(dt.ConnectivityList(i,:),1),dt.Points(dt.ConnectivityList(i,:),2),fillColor/256);
    set(f,'edgecolor','none');
    
    % Triangle corners
    x1 = dt.Points(dt.ConnectivityList(i,1),1);
    y1 = dt.Points(dt.ConnectivityList(i,1),2);
    x2 = dt.Points(dt.ConnectivityList(i,2),1);
    y2 = dt.Points(dt.ConnectivityList(i,2),2);
    x3 = dt.Points(dt.ConnectivityList(i,3),1);
    y3 = dt.Points(dt.ConnectivityList(i,3),2);

    % Print to SVG
    fprintf(fid,'<path d="M %f %f L %f,%f %f,%f Z" fill="rgb(%d,%d,%d)" fill-opacity="1" />\n',x1,y1,x2,y2,x3,y3,fillColor(1),fillColor(2),fillColor(3));

end

% End SVG
fprintf(fid,'</g>\n');
fprintf(fid,'</svg>');

fclose(fid);

end

