function computeFixationMaps(params)
% computeFixationMaps(params)
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

outputPath = params.path.maps.fixation;
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end

for i = 1 : params.nStimuli
    filename = params.stimuli{i};
    shortname = filename(1 : end - length(params.ext));
    img = im2double(imread(fullfile(params.path.stimuli, filename)));
    [h w ~] = size(img);
    map = zeros([h w]);
    
    fix_x = [];
    fix_y = [];
    fix_duration = [];
    for j = 1:length(fixations{i}.subjects)
        sub = fixations{i}.subjects{j};
        fix_x = [fix_x max(1, min(round(sub.fix_x), w))];
        fix_y = [fix_y max(1, min(round(sub.fix_y), h))];
        fix_duration = [fix_duration sub.fix_duration];
    end
    
    fix_x = floor(fix_x);
    fix_y = floor(fix_y);
    for k = 1 : length(fix_x)
        map(fix_y(k), fix_x(k)) = 1;
    end
    
    fixationPts = map;
    save(fullfile(outputPath, [shortname '.mat']), 'fixationPts', 'fix_x', 'fix_y', 'fix_duration');
    map = imfilter(map, params.eye.gaussian, 0);
    map = normalise(map);
    imwrite(map, fullfile(outputPath, filename));
end
end