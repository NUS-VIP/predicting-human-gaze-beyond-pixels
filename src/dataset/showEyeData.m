function showEyeData(params, subject)
% showEyeData(params, subject)
%
% ----------------------------------------------------------------------
% Matlab tools for "Predicting human gaze beyond pixels," Journal of Vision, 2014
% Juan Xu, Ming Jiang, Shuo Wang, Mohan Kankanhalli, Qi Zhao
%
% Copyright (c) 2014 NUS VIP - Visual Information Processing Lab
%
% Distributed under the MIT License
% See LICENSE file in the distribution folder.
% -----------------------------------------------------------------------

load(fullfile(params.path.eye, 'fixations.mat'));

for i = 1 : length(fixations)
    fileName = fixations{i}.img;
    if ~exist(fullfile(params.path.stimuli, fileName), 'file')
        continue;
    end
    
    img = imread(fullfile(params.path.stimuli, fileName));
    [h w c] = size(img);
    if (subject < 1 || subject > length(fixations{i}.subjects))
        error('Invalid subject ID!');
    end
    sub = fixations{i}.subjects{subject};
    fix_x = max(1, min(round(sub.fix_x), w));
    fix_y = max(1, min(round(sub.fix_y), h));
    
    % show eye data with image
    figure(1);
    imshow(img); hold on;
    n = length(fix_x);
    
    fix_x = floor(fix_x);
    fix_y = floor(fix_y);
    fix_duration = ceil(sub.fix_duration / 10);
    plot(fix_x, fix_y, '-', 'LineWidth', 2);
    for k=1:length(fix_x)
        if (k==1)
            color = 'r';
        else
            color = 'y';
        end
        plot(fix_x(k), fix_y(k), 'o', 'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor', color, 'MarkerSize', fix_duration(k));
    end
    hold off;
    pause
end
