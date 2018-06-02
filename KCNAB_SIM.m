function [P,S,A,R,RPE] = KCNAB_SIM(model,n_arms,n_contexts,n_subjects,n_trials,sd_r,noise_r)
%NAB_SIM Wrapper for all the N-Armed Bandit simulators
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
        [P,S,A,R,RPE]=sim_kcnab_lrcr(n_arms,n_contexts,n_subjects,n_trials,sd_r,noise_r);
    case 'lrcrp'
        [P,S,A,R,RPE]=sim_kcnab_lrcrp(n_arms,n_contexts,n_subjects,n_trials,sd_r,noise_r);
    case 'lr2cr'
        [P,S,A,R,RPE]=sim_kcnab_lr2cr(n_arms,n_contexts,n_subjects,n_trials,sd_r,noise_r);
    case 'lr2crp'
        [P,S,A,R,RPE]=sim_kcnab_lr2crp(n_arms,n_contexts,n_subjects,n_trials,sd_r,noise_r);
end

end
