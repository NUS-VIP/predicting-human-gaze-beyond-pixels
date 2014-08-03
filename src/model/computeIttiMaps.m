function computeIttiMaps(params)
% computeIttiMaps(params)
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

features = {'color', 'intensity', 'orientation'};
n = length(features);
outputPath = cell(n, 1);
for k = 1 : n
    outputPath{k} = fullfile(params.path.maps.feature, features{k});
    if ~exist(outputPath{k}, 'dir')
        mkdir(outputPath{k});
    end 
end

for i = 1 : params.nStimuli
    fileName = params.stimuli{i};
    img = imread(fullfile(params.path.stimuli, fileName));
    out = ittikochmap(img);
    for k = 1 : n
        map = imresize(out.top_level_feat_maps{k}, [params.out.height params.out.width]);
        map = imfilter(map, params.out.gaussian);
        map = normalise(map);
        imwrite(map, fullfile(outputPath{k}, fileName));
    end
end

end

function out = ittikochmap( img )
params = makeGBVSParams;
params.ittiblurfrac = 0; 
params.channels = 'CIO';
params.useIttiKochInsteadOfGBVS = 1;
params.verbose = 0;
params.salmapmaxsize = round( max(size(img))/8 );
out = gbvs(img, params);
end