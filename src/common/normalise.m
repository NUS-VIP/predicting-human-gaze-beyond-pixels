function [ normalised ] = normalise( map )
% [ normalised ] = normalise( map )
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

map = map - min(min(map));
s = max(max(map));
if s > 0
    normalised = map / s;
else
    normalised = map;
end

end
