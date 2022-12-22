%% Opacity map video - Doga 2022/12/21
% This visualization is based on consecutive fixations on a single image,
% disregarding any other metric temporally (such as saccades, unregistered
% gaze, or fixations on other images)

vidObj = VideoWriter('demo.mp4','MPEG-4'); % Create an MP4 video object
vidObj.FrameRate = 60; vidObj.Quality = 100; % Set video frame rate to 60Hz & video quality to 100%
open(vidObj); % Open the video object

p = imread("painting.jpg"); % Read the painting image

data = readtable('fixations.csv'); % Read the aggregated fixation data
x = data.fixationX_normalized_*width(p); % Get x coordinates of fixations
y = (1-data.fixationY_normalized_)*height(p); % Get y coordinates of fixations (and flip it)
t = data.duration_ms_; % Get fixation duration in ms

Nframes = zeros(1,height(t)); % Create an empty array for number of frames, equal to fixation count
for i = 1:height(t) % Loop for the number of fixations
    Nframes(i) = round(t(i)/(1000/60)); % Calculate how many frames are needed to show each fixation
end

axis equal % Equate unit-distances of x-axis & y-axis for the plot
xlim([0 width(p)]); ylim([0 height(p)]); % Limit x & y-axis lengths of plot to size of the painting
hold on % Hold the current graph

for i = 1:height(x) % Loop for the number of fixations, and draw the scatter plot
    s = scatter(x(i),y(i), 'filled','MarkerFaceColor','black','SizeData',600,'MarkerFaceAlpha',0.5);
    for j = 1:Nframes(i) % Loop for the number of frames
        s.SizeData = s.SizeData+(600/Nframes(i)); % Make data points larger in each frame
        s.MarkerFaceAlpha = s.MarkerFaceAlpha+(0.49/Nframes(i)); % Make data points more opaque
        writeVideo(vidObj,getframe(gcf)); % Write the scatter plot as one frame of the video
    end
end

hold off % Leave the current graph
close(vidObj); % Close the file

% Use other software/language to combine three layers:
% 1st layer (top): painting_blur.jpg @ 40% opacity (i.e., Gaussian-blur added version of painting)
% 2nd layer (mid): painting.jpg with screen blend-mode (i.e., unedited painting)
% 3rd layer (bottom): demo.mp4 (i.e., video-export from this script)