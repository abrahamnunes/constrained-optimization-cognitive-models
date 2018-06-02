function a = action_selection(x)
%ACTION_SELECTION (Numerically stable) softmax action selection
%
%   Parameters
%   ----------
%   x : array(1, n_options) : Action values
%
%   Returns
%   -------
%   array(1, n_options) : One-hot action vector
%
%   Abraham Nunes (Last Updated November 24, 2017)
% =========================================================================

P_a = exp(x-max(x))/sum(exp(x-max(x)));
a = mnrnd(1, P_a);

end

