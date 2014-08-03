function computeObjectMaps(params)
% computeObjectMaps(params)
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
load(fullfile(params.path.data, 'objFeat.mat'));

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
id=0;
for i = 1 : params.nStimuli
    filename = attrs{i}.img;
    objs = attrs{i}.objs;
    maps = zeros(params.out.height, params.out.width, n);
    for j = 1 : length(objs)
        id=id+1;
        bw = imresize(objs{j}.map, [params.out.height params.out.width]);
        label = im2double(bw);
        label(~bw) = 2;
        ss = regionprops(label, {'Centroid'});

        center = ss(1).Centroid;
        sigma_x = params.out.sigma * 2;
        sigma_y = params.out.sigma * 2;
        im = exp(-((x - center(1)) .^ 2) / (2 * sigma_x ^ 2) - ((y - center(2)) .^ 2) / (2 * sigma_y ^ 2));

        for k = 1 : n
            v = objFeat(id, k);
            if v ~= 0 && ~isnan(center(2)) && ~isnan(center(1))
                maps(:,:,k) = maps(:,:,k) + im*v;
            end
        end
    end
    for k = 1 : n
        map = maps(:, :, k);
        map = normalise(map);
        imwrite(map, fullfile(outputPath{k}, filename));
    end
end
toc;
