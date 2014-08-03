function [auc, rocCurve] = normalizedAUC(params, split)
% normalizedAUC(params)
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

load(fullfile(params.path.data, 'interSubjectAUC.mat'));
idealAUC = mean(interSubjectAUC, 2);

load(fullfile(params.path.data, 'splits.mat'));
testingImgs = splits(split).files.test;
auc = zeros(1, length(testingImgs));
rocCurve = zeros(20, length(testingImgs));

for i=1:length(testingImgs)
    fileName = testingImgs{i};
    map = im2double(imread(fullfile(params.path.maps.saliency, fileName)));
    
    % get the fixation map
    load(fullfile(params.path.maps.fixation, fileName(1:end-length(params.ext))));
    [r, c] = size(fixationPts);
    
    % resize predictions for direct comparison
    predictions = imresize(map, [r, c]);
    
    % Calculate the area under the ROC curve
    S = predictions(:);
    F = fixationPts(:);
    
    [S, k] = sort(S, 'descend');
    F = F(k);
    
    % calculate precision and false alarms
    n = length(F);
    cumSumF = cumsum(F);
    sumF = sum(F);
    
    precision = cumSumF / sumF;
    for j = 1:20
        k = floor(n / 20) * j;
        rocCurve(j, i) = precision(k);
    end
    
    auc(i) = rocScoreSaliencyVsFixations(predictions, fix_x' , fix_y' , [r, c]);
    auc(i) = (auc(i) - 0.5) / (idealAUC(splits(split).ind.test(i)) - 0.5) / 2 + 0.5;
end