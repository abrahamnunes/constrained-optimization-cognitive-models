function [L, Leq] = neg_prior_constraint(x, model)
    % Returns negative logprior probability for parameter estimates in X

    Leq = []; % empty value to satisfy nonlinear constraint requirements

    % SET DISTRIBUTION PARAMETERS
    lr_loc = 1.1; lr_scale = 1.1; % Learning rate ~ Beta(alpha, beta)
    cr_loc = 5;   cr_scale = 1;   % Inv. softmax ~ Gamma(loc, scale)
    p_loc  = 0;   p_scale  = 0.5; % Perseveration ~ Gamma(loc, scale)

    % COMPUTE NEGATIVE-LOG-PRIORS
    switch model
        case 'lrcr'
            logp_lr = log(betapdf(x(1), lr_loc, lr_scale));
            logp_cr = log(gampdf(x(2), cr_loc, cr_scale));
            L = - logp_lr - logp_cr;
        case 'lrcrp'
            logp_lr = log(betapdf(x(1), lr_loc, lr_scale));
            logp_cr = log(gampdf(x(2), cr_loc, cr_scale));
            logp_p  = log(normpdf(x(3), p_loc, p_scale));
            L = - logp_lr - logp_cr - logp_p;
        case 'lr2cr'
            logp_lr = log(betapdf(x(1), lr_loc, lr_scale));
            logp_lr2 = log(betapdf(x(2), lr_loc, lr_scale));
            logp_cr = log(gampdf(x(3), cr_loc, cr_scale));
            L = - logp_lr - logp_lr2 - logp_cr;
        case 'lr2crp'
            logp_lr = log(betapdf(x(1), lr_loc, lr_scale));
            logp_lr2 = log(betapdf(x(2), lr_loc, lr_scale));
            logp_cr = log(gampdf(x(3), cr_loc, cr_scale));
            logp_p  = log(normpdf(x(4), p_loc, p_scale));
            L = - logp_lr - logp_lr2 - logp_cr - logp_p;
    end

    if ~isreal(L)
        L = Inf;
    end

end
