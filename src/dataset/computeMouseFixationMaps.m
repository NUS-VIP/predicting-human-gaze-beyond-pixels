function computeMouseFixationMaps(params, dataset)
% computeMouseFixationMaps(params, dataset)
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

inputPath = fullfile(params.path.data, dataset);
if ~exist(inputPath, 'dir')
    error('Please specify the dataset: ''mouse_amt'' for crowdsourced data, or ''mouse_lab'' for lab data.');
end

outputPath = fullfile(params.path.maps.mouse, dataset);
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end

for i = 1 : params.nStimuli
    filename = params.stimuli{i};
    img = im2double(imread(fullfile(params.path.stimuli, filename)));
    [h w ~] = size(img);
    map = zeros([h w]);
    
    load(fullfile(inputPath, filename(1:end-4)));
    
    ptInd = sub2ind([h w], fixations.coord(:,1), fixations.coord(:,2));
    map(unique(ptInd)) = 1;
    
    map = imfilter(map, params.eye.gaussian, 0);
    map = normalise(map);
    imwrite(map, fullfile(outputPath, filename));
end
end