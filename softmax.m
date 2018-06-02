function P_a = softmax(x)
%SOFTMAX Numerically stable softmax
%
%   Parameters
%   ----------
%   x : array(1, n_options) : Action values
%
%   Returns
%   -------
%   array(1, n_options) : Stochastic vector
%
%   Abraham Nunes (Last Updated November 24, 2017)
% =========================================================================

P_a = exp(x-max(x))/sum(exp(x-max(x)));

end
