function [params, ... 
          S,      ...
          A,      ...
          R,      ...
          RPE] = sim_kcnab_lrcr(n_arms,     ... % (int>0)   # Arms
                              n_contexts,  ... % (int>0) # Contexts
                              n_subjects, ... % (int>0)   # Subjects
                              n_trials,   ... % (int>0)   # Trials
                              sd_r,       ... % (float>0) # SD of P(reward)
                              noise_r)    ... % ('t','f') # Reward sampled?
%SIM_NAB Simulates an N-Armed Bandit with 
%   Learning rate 
%   Choice randomness
%
% Returns 
%   1. structural array of results for subjects
%   2. n_subjects x 2 array of model parameters [lr, cr]
%
%   Abraham Nunes (Last Updated Nov 24, 2017)
% =========================================================================

% Generate parameters
params = make_param_array(n_subjects, 'lrcr');

% Create output structures
S = NaN(n_trials, n_subjects);
A = NaN(n_trials, n_arms, n_subjects);
R = NaN(n_trials, n_subjects);
RPE = NaN(n_trials, n_subjects);

for i = 1:n_subjects
    lr = params(i, 1); 
    cr = params(i, 2);
    
    Q = zeros(n_contexts, n_arms);
    rprob = make_rewardpaths2(n_trials, n_contexts, n_arms, 0.2, 0.8, sd_r);
    for t = 1:n_trials
        % Take action
        s = randsample(n_contexts,1);
        a = action_selection(cr*Q(s,:));
        
        % Sample reward
        a_size = size(rprob,3);
        rprob_t = reshape(rprob(t, s, :),[1,a_size])*a';
        if strcmp(noise_r, 't')
            r = binornd(1, rprob_t);
        elseif strcmp(noise_r, 'f')
            r = rprob_t;
        end
        
        % Learn
        rpe = (r - Q(s,:)*a');
        Q(s,:) = Q(s,:) + lr*rpe*a;
            
        % Store data
        S(t, i) = s;
        A(t, :, i) = a;
        R(t, i) = r;
        RPE(t, i) = rpe;
    end
end


end

