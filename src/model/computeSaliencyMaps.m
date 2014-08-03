function computeSaliencyMaps(params, split)
% computeSaliencyMaps(params)
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

outputPath = params.path.maps.saliency;
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end 

load(fullfile(params.path.data, 'model.mat'));
load(fullfile(params.path.data, 'splits.mat'));
meanVec = model.whiteningParams(1, :);
stdVec = model.whiteningParams(2, :);

testingImgs = splits(split).files.test;
for i = 1 :length(testingImgs)
    fileName = testingImgs{i};

    feat = zeros(params.out.height * params.out.width, length(model.features));
    for j = 1 : length(model.features)
       map = im2double(imread(fullfile(params.path.maps.feature, model.features{j}, fileName)));
       feat(:, j) = map(:);
    end
    
    feat = bsxfun(@minus, feat, meanVec);
    feat = feat ./ repmat(stdVec, [size(feat, 1), 1]);

    predictions = feat*model.w';
    map = reshape(predictions, [params.out.height params.out.width]);
    
    map = imfilter(map, params.out.gaussian);
    map = normalise(map);
    imwrite(map, fullfile(outputPath, fileName));
end
