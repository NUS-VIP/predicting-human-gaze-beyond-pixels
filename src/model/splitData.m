function splitData(params)
% splitData(params)
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

splits = [];
ind = randperm(params.nStimuli);
nSample = params.nStimuli / params.ml.nSplit;
for iSplit = 1:params.ml.nSplit
    if (iSplit < params.ml.nSplit)
        splits(iSplit).ind.train = [ind(1:(iSplit-1)*nSample) ind(iSplit*nSample+1:end)];
        splits(iSplit).ind.test = ind(((iSplit-1)*nSample+1):(iSplit*nSample));
    else
        splits(iSplit).ind.train = [ind(1:(iSplit-1)*nSample)];
        splits(iSplit).ind.test = ind(((iSplit-1)*nSample+1):end);
    end
    splits(iSplit).files.train = params.stimuli(splits(iSplit).ind.train);
    splits(iSplit).files.test = params.stimuli(splits(iSplit).ind.test);
end

outdir = params.path.data;
if ~exist(outdir, 'dir')
    mkdir(outdir);
end
save(fullfile(params.path.data, 'splits.mat'), 'splits');