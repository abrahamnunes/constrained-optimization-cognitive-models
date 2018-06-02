function L = nll_kcnab_lrcr(x, ... % (2 x 1 vector) of parameters [lr, cr]
                          S, ... % (n_trials x n_states one-hot vector) of states
                          A, ... % (n_trials x n_arms one hot vector) of actions
                          R)     % (n_trials x 1 vector) of rewards
%LL_NAB_LRCR
%   Loglikelihood function for n-armed bandit with learning rate and choice
%   randomness parameters 
%
%   Abraham Nunes (Last updated Nov 24, 2017)
% =========================================================================

n_arms = size(A, 2);
n_trials = size(A, 1);
n_states = max(S);
L = 0;
lr = x(1);
cr = x(2);
Q = zeros(n_states, n_arms);

for t = 1:n_trials
    a = A(t,:);
    s = S(t);
    dL = cr*Q(s,:)*a' - logsumexp(cr*Q(s,:));
    L = L - dL;
    
    % Learn
    rpe = (R(t) - Q(s,:)*a');
    Q(s,:) = Q(s,:) + lr*rpe*a;
end

end

