function paths = make_rewardpaths(n_trials, n_paths, lb, ub, sd_r)
%MAKE_REWARDPATHS Generates random walk with Gaussian steps within bounds
%lb and ub
%
%   Parameters
%   ----------
%   n_trials : int > 0 : Number of trials
%   n_paths : int > 0 : Number of paths
%   lb : 0 < float < ub : lower bound
%   ub : lb < float < 1 : upper bound
%   sd_r: float > 0 : standard deviation of the Gaussian steps
%
%   Returns
%   -------
%   [n_trials by n_paths] array of reward probabilities
%
%   Abraham Nunes (Last updated Nov 24, 2017)
% =========================================================================

sdt = sqrt(1/n_trials);
paths = NaN(n_trials, n_paths);
paths(1, :) = rand(1, n_paths)*(ub-lb) + lb;
for i = 2:n_trials
    paths(i, :) = max(min(paths(i-1, :) + sd_r*sdt*randn(1, n_paths), ub), lb);
end

end

