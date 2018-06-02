function [est, M, history] = subject_mle_fmins(f, model, modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, true_params, maxiters)
    %SUBJECT_MLE_FMINS optimizes parameters for a single subject
    % by restarting the provided optimizer until there is no further
    % improvement in likelihood.  Uses fmincon with smooth constraints.

    % ------------------------------
    %   CREATE RESULTS STRUCTURE
    % ------------------------------
    M = NaN(1, 13);

    % ------------------------------
    %   CREATE OUTPUT FUNCTION
    % ------------------------------
    function stop  = outputfx(x,optimValues,state)
        stop = false;
        switch state
            case 'iter'
                history.feval = [history.feval; optimValues.fval];
                history.neval= [history.neval; optimValues.funccount];
                history.stepsize= [history.stepsize; optimValues.stepsize];
                history.x_norm = [history.x_norm; norm(x, 2)];
        end
    end

    % ------------------------------
    %   SET OPTIONS
    % ------------------------------
    fminopt = optimset('TolFun'      , 1e-14,       ...
                       'TolX'        , 1e-14,       ...
                       'Display'     , 'off',       ...
                       'MaxFunEvals' ,   [],        ...
                       'OutputFcn'   , @outputfx,   ...
                       'MaxIter'     ,   []);

    % ------------------------------
    %   RUN
    % ------------------------------

    % Initialize results
    res.f = Inf; res.x = [];
    res.neval = 0; res.flg = 0;
    res.fseries = [];
    res.xseries = [];

    improved = 1; k = 0;
    while improved == 1 && k < maxiters
        history.feval    = [];
        history.neval    = [];
        history.stepsize = [];
        history.x_norm   = [];

        x0 = make_param_array(1, model);  % Sample initial point
        [xmin,fmin,flg,out] = fmincon(f,x0,[],[],[],[],[],[],[],fminopt); % Optimize

        if fmin >= res.f && k > 0 && flg==1  % If worsened minimum, use last values
            improved = 0;
        else                % Otherwise update results
            res.f = fmin;
            res.x = xmin;
            res.out = out;
            res.flg = flg;

            % Update function evaluation count
            res.neval = res.neval + out.funcCount;

            % Update output array
            M(1)  = modeli;
            M(2)  = narm;
            M(3)  = nctx;
            M(4)  = ntrials;
            M(5)  = sd_r;
            M(6)  = noise_r_i;
            M(7)  = i;
            M(8)  = res.flg;
            M(9)  = res.neval;
            M(10) = res.f;
            M(11) = 1; %Bound = 0; Smooth = 1
            M(12) = norm(true_params - res.x);
            M(13) = 0; % Optimizer Fmincon=0; ps=1

            % Update estimates
            est = res.x;

        end

        k = k+1;
        if k > 0 && improved == 1
            res.fseries(k)   = fmin;
            res.xseries(k,:) = xmin;
        end
    end

end
