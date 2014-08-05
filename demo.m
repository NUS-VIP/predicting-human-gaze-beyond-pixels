% This Matlab script demonstrates the usage of this package.
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

fprintf('Setting up the environment.\n');
tic;
addpath(genpath('src'));

% initialize GBVS
cd lib/gbvs
gbvs_install
cd ../..

% initialize liblinear
addpath('lib/liblinear');
cd lib/liblinear
make
cd ../..

toc;

% load parameters
p = config;

fprintf('Computing fixation maps.\n');
tic;
computeFixationMaps(p);
toc;

fprintf('Computing Itti & Koch saliency maps.\n');
tic;
computeIttiMaps(p);
toc;

fprintf('Computing object-level feature maps.\n');
tic;
extractObjectFeatures(p);
computeObjectMaps(p);
toc;

fprintf('Computing semantic-level feature maps.\n');
tic;
computeSemanticMaps(p);
toc;

fprintf('Computing ideal (inter-subject) AUC scores.\n');
tic;
computeInterSubjectAUC(p);
toc;

% train and evaluate the saliency model with an n-fold cross validation
fprintf('Training and testing linear SVM model.\n');
tic;
splitData(p);
auc = cell(1, p.ml.nSplit);
curves = cell(1, p.ml.nSplit);
for split = 1:p.ml.nSplit
    trainModel(p, split);
    computeSaliencyMaps(p, split);
    [auc{split}, curves{split}] = normalizedAUC(p, split);
end
toc;