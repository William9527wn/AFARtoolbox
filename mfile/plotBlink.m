
load('/Users/wanqiaod/workspace/pipeline/out/zface_out/zface_fit/1080_provoc_1017_fit.mat');
frame_cnt = size(fit,2);
single_face = fit(150).pts_2d;
% single_face = single_face(20:31,:);
face_x = single_face(:,1);
face_y = single_face(:,2);

avg_dist = getAvgDist(single_face);
avg_dist = zeros(frame_cnt,1);
for frame = 1 : frame_cnt
    single_face = fit(frame).pts_2d;
    if isempty(single_face)
        continue
    end
    avg_dist(frame,1) = getAvgDist(single_face);
end
dist_x = 1:frame_cnt;
% scatter(dist_x,avg_dist,'.');
blink_frame = [];
for frame = 2 : (frame_cnt-1)
    prev_dist = avg_dist(frame-1);
    next_dist = avg_dist(frame+1);
    curr_dist = avg_dist(frame);
    if curr_dist < next_dist & curr_dist < prev_dist
        blink_frame = [blink_frame frame];
    end
end
blink_y = zeros(frame_cnt,1);
blink_y(blink_frame) = 1;
% plot_x = dist_x(1,200:500);
plot_x = dist_x;
% plot_y = blink_y(200:500,1);
plot_y = blink_y;
% scatter(plot_x,plot_y,'.');

frame_rate = 30;
blink_freq = [];
for n = 1 : (length(blink_frame)-1)
    eye_open_interval = blink_frame(n+1) - blink_frame(n);
    curr_freq = eye_open_interval/frame_rate; 
    blink_freq = [blink_freq curr_freq];
end

total_blink_freq = size(blink_freq,2);
blink_cnt = 0;
next_blink_cnt = 1;
start_cnt = 0;
blink_freq_y = [];

for frame = 1 : frame_cnt
    if blink_cnt == 0
        curr_blink_y = blink_freq(1);
    else
        curr_blink_y = blink_freq(blink_cnt);
    end

    if blink_cnt<total_blink_freq && frame == blink_frame(blink_cnt+1)
        blink_cnt = blink_cnt + 1;
    end

    blink_freq_y = [blink_freq_y curr_blink_y];
end

plot(plot_x,blink_freq_y);

