function  computeInterSubjectAUC(params)
% computeInterSubjectAUC(params)
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

load(params.file.fixations);

nSub=0;
for i=1:length(fixations)
    nSub = max(nSub, length(fixations{i}.subjects));
end

interSubjectAUC = nan(length(fixations), nSub);
for i = 1 : length(fixations)
   fileName = fixations{i}.img;
   n = length(fixations{i}.subjects);
   im = imread(fullfile(params.path.stimuli, fileName));
   [H W ~] = size(im);
   for sbj = 1:n
        fix_x = [];
        fix_y = [];
        for j = 1:n
            sub = fixations{i}.subjects{j};
            if (j == sbj)
                subFix_x = max(1, min(round(sub.fix_x), W));
                subFix_y = max(1, min(round(sub.fix_y), H));
            else
                fix_x = [fix_x max(1, min(round(sub.fix_x), W))];
                fix_y = [fix_y max(1, min(round(sub.fix_y), H))];
            end
        end

        map = zeros([H W]);
        for k = 1 : length(fix_x)
            map(fix_y(k), fix_x(k)) = 1;
        end
        
        fixationPts = zeros([H W]);
        for k = 1 : length(subFix_x)
            fixationPts(subFix_y(k), subFix_x(k)) = 1;
        end
        
        map = imfilter(map, params.eye.gaussian);
        map = normalise(map);
        
        interSubjectAUC(i, sbj) = rocScoreSaliencyVsFixations(map, subFix_x' , subFix_y' , [H W]);
   end
end
save(fullfile(params.path.data, 'interSubjectAUC.mat'), 'interSubjectAUC');
