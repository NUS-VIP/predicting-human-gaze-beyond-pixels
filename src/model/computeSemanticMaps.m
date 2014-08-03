function computeSemanticMaps(params)
% computeSemanticMaps(params)
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
%features = {'face', 'emotion', 'touched', 'gazed', 'motion', 'sound', 'smell', 'taste', 'touch', 'text', 'watchability', 'operability'};
n = length(attrNames);
outputPath = cell(n, 1);
for k = 1 : n
    outputPath{k} = fullfile(params.path.maps.feature, attrNames{k});
    if ~exist(outputPath{k}, 'dir')
        mkdir(outputPath{k});
    end 
end

[x, y] = meshgrid(1 : params.out.width, 1 : params.out.height);
tic;
for i = 1 : params.nStimuli
    fileName = attrs{i}.img;
    objs = attrs{i}.objs;
    attrMaps = zeros(params.out.height, params.out.width, length(attrNames));
    for j = 1 : length(objs)

        bw = imresize(objs{j}.map, [params.out.height params.out.width]);
        label = im2double(bw);
        label(~bw) = 2;
        st = regionprops(label, {'Centroid'});
        center = st.Centroid;
        
        sigma_x = params.out.sigma * 2;
        sigma_y = params.out.sigma * 2;
        im = exp(-((x - center(1)) .^ 2) / (2 * sigma_x ^ 2) - ((y - center(2)) .^ 2) / (2 * sigma_y ^ 2));
  
        for k = 1 : n
            v = (objs{j}.features(k)>0);
            if v ~= 0 && ~isnan(center(2)) && ~isnan(center(1))
                 attrMaps(:,:,k) = attrMaps(:,:,k) + im * v;
            end
        end
    end
    
    for k = 1 : n
        map = attrMaps(:, :, k);
        map = normalise(map);
        imwrite(map, fullfile(outputPath{k}, fileName));
    end
end
toc;
