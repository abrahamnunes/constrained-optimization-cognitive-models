function L = NAB_CV(x, S, A, R, model)
%NAB_NLL Wrapper for all the N-Armed Bandit log-likelihood computation
%
%   See any of the sim_nab_... files for parameter descriptions
%
%   The only new input here is `model`, which is a string taking either:
%       'lrcr': learning rate, choice randomness
%       'lrcrp': learning rate, choice randomness, perseveration
%       'lr2cr': learning rate (+ & -), choice randomness
%       'lr2crp': learning rate (+ & -), choice randomness, perseveration
%
% ==============================================================================

switch model
    case 'lrcr'
        L=cv_kcnab_lrcr(x, S, A, R);
    case 'lrcrp'
        L=cv_kcnab_lrcrp(x, S, A, R);
    case 'lr2cr'
        L=cv_kcnab_lr2cr(x, S, A, R);
    case 'lr2crp'
        L=cv_kcnab_lr2crp(x, S, A, R);
end

end
