%   a = imaqhwinfo;
%     [camera_name, camera_id, format] = getCameraInfo(a);
%   figure;
% 
% % Capture the video frames using the videoinput function
% % You have to replace the resolution & your installed adaptor name.
%  vid = videoinput(camera_name, camera_id, format);
vid = videoinput('winvideo',1);
% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;

%start the video aquisition here
start(vid)

% Set a loop that stop after 100 frames of aquisition
 while(vid.FramesAcquired<=150)
     
     % Get the snapshot of the current frame
     data = getsnapshot(vid);
 %%%%%%%%%%%%%%
    
 boxImage = imread('base3.JPG');
 sceneImage = data;
% %%%%%%%% Center Of video

 %%%%%%%%
 boxImage=rgb2gray(boxImage);
 sceneImage=rgb2gray(sceneImage);
 
 boxPoints = detectMSERFeatures(boxImage);
 scenePoints = detectMSERFeatures(sceneImage);
 
 [boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
 [sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
% if (boxFeatures>10 & sceneFeatures>10)
 boxPairs = matchFeatures(boxFeatures, sceneFeatures);

  matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
  matchedScenePoints = scenePoints(boxPairs(:, 2), :); 

 
 %figure;   
if size(boxPairs, 1) >= 3
    [tform,~,~,status] = estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
 %box Polygon
 boxPolygon = [1, 1;...                           % top-left
         size(boxImage, 2), 1;...                 % top-right
         size(boxImage, 2), size(boxImage, 1);... % bottom-right
         1, size(boxImage, 1);...                 % bottom-left
         1, 1]; 
 newBoxPolygon = transformPointsForward(tform, boxPolygon);
 % Display the image
%Calculation of x y z
x1=newBoxPolygon(1,1);
y1=newBoxPolygon(1,2);
x2=newBoxPolygon(2,1);
y2=newBoxPolygon(2,2);
x3=newBoxPolygon(3,1);
y3=newBoxPolygon(3,2);
x4=newBoxPolygon(4,1);
y4=newBoxPolygon(4,2);
x5=newBoxPolygon(5,1);
y5=newBoxPolygon(5,2);

%Centroid of Polygon
fram_x=(x1+x2+x3+x4)/4;
fram_y=(y1+y2+y3+y4)/4;



%Centroid of Figure
[height width]=size(boxImage);
fig_x=width/2;
fig_y=height/2;

%Difference between centroid
a=fig_x-fram_x;
b=fig_y-fram_y;
x=(a/100)+5;
y=(b/100)+5;
z= x * y;
% 6 DOF
abc=tform.T;

%disp= sprintf(' Object Detected  \n Error X: %f , Y: %f , Z: %f  ',x,y,z);
disp=sprintf('Object Detected  \n Error X: %3f , Y: %3f , Z: %3f \n 6 Degrees OF Freedom\n %3f \t %3f\t %3f\n %3f\t %3f\t %3f ',x,y,z,abc(1,1),abc(1,2),abc(2,1),abc(2,2),abc(3,1),abc(3,2));
 imshow(data)
 hold on;
 line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'r');
 title(disp);


    refreshdata;
 hold off

else
    
   imshow(data);
end
 
 end

% Both the loops end here.

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);

% Clear all variables
%clear all
sprintf('%s','This our final project :) ')
