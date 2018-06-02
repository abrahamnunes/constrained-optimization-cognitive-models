% =========================================================================
%
%   MAIN EXPERIMENTAL SCRIPT
%
%
%   Abraham Nunes (Last updated 2017-11-24)
% =========================================================================
clear all;
rng(342, 'twister');

% =========================================================================
%   SET EXPERIMENTAL HYPERPARAMETERS
% =========================================================================

nsubj       = 30;
narms       = [2, 4, 10];
nctxs       = [1, 2, 5, 10]; % note that with 1 context this is equivalent to NAB
models      = {'lrcr'}; 
trials      = [20, 100, 200];
sd_list     = [0.01, 0.1, 0.5, 1];
noise_rlist = {'t', 'f'};

maxiters = 100; % Number of iterations allowed for subject level MLE

% GET OPTIMIZER OPTIONS
[fminopt, psopt] = make_optim_options();

% =========================================================================
%   MAIN LOOP
% =========================================================================

for modeli = 1:length(models)
    model = models{modeli};
for narmi = 1:length(narms)
    narm = narms(narmi);
for nctxi = 1:length(nctxs)
    nctx = nctxs(nctxi);
for triali = 1:length(trials)
    ntrials = trials(triali);
for sdi = 1:length(sd_list)
    sd_r = sd_list(sdi);
for noise_r_i = 1:length(noise_rlist)
    noise_r = noise_rlist(noise_r_i);

    % MAKE CONSTRAINTS
    [LB, UB, sigma, names] = get_param_info(model, 1/5);    % BOUNDS
    prior = @(x) neg_prior_constraint(x, model);            % PRIORS

    % GENERATE DATA
    [params,S,A,R,RPE] = KCNAB_SIM(model,narm,nctx,nsubj,ntrials,sd_r,noise_r);

    % GENERATE CONTAINERS FOR RESULTS
    res.est     = NaN(size(params, 1), ...
                      size(params, 2), ...
                      4); % Parameter estimate container
    res.nloglik = NaN(nsubj, 4);     % Negative log likelihood
    res.xent    = NaN(nsubj, 4);     % Cross-entropy
    res.neval   = NaN(nsubj, 4);     % Number of function evaluations
    res.xnorm   = NaN(nsubj, 4);     % l2 norm from true parameters

    for i = 1:nsubj
        % PROGRESS OUTPUT
        disp(['MODEL '     , num2str(modeli)   , ' | ', ...
              'SUBJECT '   , num2str(i)        , ' | ', ...
              'N-ARMS '    , num2str(narm)     , ' | ', ...
              'N-CONTEXTS ', num2str(nctx)     , ' | ', ...
              'N-TRIALS '  , num2str(ntrials)  , ' | ', ...
              'SD-R '      , num2str(sd_r)     , ' | ', ...
              'NOISY R '   , num2str(noise_r_i)]);

        % CREATE FUNCTIONS
        f = @(x) KCNAB_NLL(x, S(:,i), A(:,:,i), R(:,i), model); % Obj func
        J = @(x) f(x) + prior(x);                               % Lagrangian

        % DO OPTIMIZATION
        [est_fminb, M_fminb, history_fminb] = subject_mle_fminb(f,model, LB, UB, modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, params(i,:), maxiters);
        [est_psb, M_psb, history_psb]       = subject_mle_psb(f,model, LB, UB, modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, params(i,:), maxiters);
        [est_fmins, M_fmins, history_fmins] = subject_mle_fmins(J,model,modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, params(i,:), maxiters);
        [est_pss, M_pss, history_pss]       = subject_mle_pss(J, model, modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, params(i,:), maxiters);

        % ----------------------------------------------------------------------
        % SAVE SUMMARY DATA TO DISK
        % ----------------------------------------------------------------------
        D=[M_fminb; M_psb; M_fmins; M_pss];

        dlmwrite(['results/results-kcnab-', num2str(modeli), '.csv'], D,'delimiter',',','-append');

        % ----------------------------------------------------------------------
        % SAVE PARAM ESTIMATES TO DISK
        % ----------------------------------------------------------------------
        nparams = size(params, 2);
        z = ones(nparams, 1); pidx = [1:nparams];
        D2=[modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, 0*z, pidx', 9999*z, params(i, :)'; ...
            modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, 1*z, pidx', M_fminb(8)*z, est_fminb'; ...
            modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, 2*z, pidx', M_psb(8)*z, est_psb'; ...
            modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, 3*z, pidx', M_fmins(8)*z, est_fmins'; ...
            modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, 4*z, pidx', M_pss(8)*z, est_pss'];

        dlmwrite(['results/paramest-kcnab-', num2str(modeli), '.csv'], D2,'delimiter',',','-append');

        % ----------------------------------------------------------------------
        % SAVE HISTORY
        % ----------------------------------------------------------------------
        % fmin_bounds
        df = [];
        z = ones(length(history_fminb.stepsize), 1); iterid = [1:length(history_fminb.stepsize)];
        df = [modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, iterid', history_fminb.stepsize, history_fminb.feval, history_fminb.neval, history_fminb.x_norm, 0*z, 0*z];
        dlmwrite(['results/kcnab-history-fminb-', num2str(modeli), '.csv'], df,'delimiter',',','-append');

        % ps_bounds
        df = [];
        z = ones(length(history_psb.stepsize), 1); iterid = [1:length(history_psb.stepsize)];
        df = [modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, iterid', history_psb.stepsize, history_psb.feval, history_psb.neval, history_psb.x_norm, 0*z, 1*z];
        dlmwrite(['results/kcnab-history-psb-', num2str(modeli), '.csv'], df,'delimiter',',','-append');

        % fmin_smooth
        df = [];
        z = ones(length(history_fmins.stepsize), 1); iterid = [1:length(history_fmins.stepsize)];
        df = [modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, iterid', history_fmins.stepsize, history_fmins.feval, history_fmins.neval, history_fmins.x_norm, 1*z, 0*z];
        dlmwrite(['results/kcnab-history-fmins-', num2str(modeli), '.csv'], df,'delimiter',',','-append');

        % ps_smooth
        df = [];
        z = ones(length(history_pss.stepsize), 1); iterid = [1:length(history_pss.stepsize)];
        df = [modeli*z, narm*z, nctx*z, ntrials*z, sd_r*z, noise_r_i*z, i*z, iterid', history_pss.stepsize, history_pss.feval, history_pss.neval, history_pss.x_norm, 1*z, 1*z];
        dlmwrite(['results/kcnab-history-pss-', num2str(modeli), '.csv'], df,'delimiter',',','-append');

    end
end
end
end
end
end
end
