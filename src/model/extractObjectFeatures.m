function extractObjectFeatures(params)
% extractObjectFeatures(params)
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

load(fullfile(params.path.data, 'attrs.mat'));

features = {'size', 'complexity', 'convexity', 'solidity', 'eccentricity'};
n = length(features);
outputPath = cell(n, 1);
for k = 1 : n
    outputPath{k} = fullfile(params.path.maps.feature, features{k});
    if ~exist(outputPath{k}, 'dir')
        mkdir(outputPath{k});
    end 
end

tic;
[x, y] = meshgrid(1 : params.out.width, 1 : params.out.height);

objFeats = [];
for i = 1 : params.nStimuli
    fileName = attrs{i}.img;
    im = imread(fullfile(params.path.stimuli, fileName));
    [h w ~] = size(im);
    objs = attrs{i}.objs;
    maps = zeros(params.out.width, params.out.height, length(features));
    sqrtImg = sqrt(h * w);
    
    samples = zeros(length(objs), length(features));
    centers = zeros(length(objs), 2);
    fg = zeros(params.out.height, params.out.width);
    for j = 1 : length(objs)
        bw = imresize(objs{j}.map, [params.out.height params.out.width]);
        fg(bw) = 1;
        label = im2double(bw);
        label(~bw) = 2;
        stats = regionprops(label, {'ConvexImage', 'EquivDiameter', 'Centroid', 'Solidity', 'Eccentricity'});
        r = stats(1).EquivDiameter / 2;
        centers(j,:) = stats(1).Centroid;
        s1 = sum(sum(bwperim(stats(1).ConvexImage)));
        s2 = sum(sum(bwperim(bw)));
        
        samples(j,1) = r;
        samples(j,2) = s2 / r;
        samples(j,3) = s1 / s2;
        samples(j,4) = stats(1).Solidity;
        samples(j,5) = stats(1).Eccentricity;
    end
    
    objFeats = [objFeats; samples];
end
toc;

save(fullfile(params.path.data, 'objFeat.mat'), 'objFeat');