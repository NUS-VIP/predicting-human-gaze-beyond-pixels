function trainModel(params, split)
% trainModel(params)
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

feature_names = {'color', 'intensity', 'orientation', 'size', 'complexity', 'convexity', 'solidity', 'eccentricity', 'face', 'emotion', 'touched', 'gazed', 'motion', 'sound', 'smell', 'taste', 'touch', 'text', 'watchability', 'operability'};
load(fullfile(params.path.data, 'splits.mat'));

posPtsPerImg=20; % number of positive samples per image
negPtsPerImg=60; % number of negative samples
nPts = posPtsPerImg + negPtsPerImg;

p=20; % pos samples are taken from the top p percent salient pixels of the fixation map
q=60; % neg samples are taken from below the top q percent
c=1; % parameter for the liblinear machine learning

svm_params = '-s 2 -c 1 -B -1';

trainingImgs = splits(split).files.train;

nTrain = length(trainingImgs);

allFeatures = cell(nTrain, 1);
allLabels = cell(nTrain, 1);

nTotal = params.out.height * params.out.width;
for i = 1 : length(trainingImgs)
    fileName = trainingImgs{i};
    map = im2double(imread(fullfile(params.path.maps.fixation, fileName)));
    map = imresize(map, [params.out.height, params.out.width]);
    
    imageLabels=map(:);
    [~, ind] = sort(imageLabels, 'descend');
    
    % Find the positive examples in the top p percent
    posIndices = ind(randperm(ceil(p/100*nTotal), posPtsPerImg));
    
    % Find the negative examples from below top q percent
    beginIx = ceil(q/100*nTotal);
    negIndices = ind(beginIx + randperm(nTotal - beginIx, negPtsPerImg));
    
    feat = zeros(nPts, length(feature_names));
    for j = 1 : length(feature_names)
       map = im2double(imread(fullfile(params.path.maps.feature, feature_names{j}, fileName)));
       map = imresize(map, [params.out.height params.out.width]);
       feat(:, j) = map([posIndices; negIndices]);
    end
    allFeatures{i} = feat;
    allLabels{i} = [ones(posPtsPerImg, 1); -1 * ones(negPtsPerImg, 1)];
end

X = [cell2mat(allFeatures)];
Y = [cell2mat(allLabels)];

% normalise the training data
meanVec=mean(X, 1);
X=X-repmat(meanVec, [size(X, 1), 1]);

stdVec=std(X);
stdVec(stdVec==0) = 1;
X=X./repmat(stdVec, [size(X, 1), 1]);

% train the SVM model
model = train(Y, sparse(X), svm_params);
model.features = feature_names;
model.whiteningParams = [meanVec; stdVec];

save(fullfile(params.path.data, 'model.mat'), 'model');