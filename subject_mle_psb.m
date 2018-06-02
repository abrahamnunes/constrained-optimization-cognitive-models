function [est, M, history] = subject_mle_psb(f,model,LB,UB,modeli, narm, nctx, ntrials, sd_r, noise_r_i, i, true_params, maxiters)
    %SUBJECT_MLE_PSB optimizes parameters for a single subject
    % by restarting the provided optimizer until there is no further
    % improvement in likelihood.  Uses pattern search with bounds.

    % ------------------------------
    %   CREATE RESULTS STRUCTURE
    % ------------------------------
    M = NaN(1, 13);

    % ------------------------------
    %   CREATE OUTPUT FUNCTION
    % ------------------------------
    function [stop,options,optchanged]  = outputfx(optimvalues,options,flag)
    stop = false;
    optchanged = false;
        switch flag
            case 'iter'
                history.feval = [history.feval; optimvalues.fval];
                history.neval= [history.neval; optimvalues.funccount];
                history.stepsize= [history.stepsize; optimvalues.meshsize];
                history.x_norm = [history.x_norm; norm(optimvalues.x, 2)];
        end
    end

    % ------------------------------
    %   SET OPTIONS
    % ------------------------------
    psopt = psoptimset( ...
        'PollMethod'            , 'gpspositivebasis2n',  ...
        'CompletePoll'          , 'on',                  ...
        'PollingOrder'          , 'consecutive',         ...
        'CompleteSearch'        , 'off',                 ...
        'SearchMethod'          , [],                    ...
        'MeshAccelerator'       , 'off',                 ...
        'ScaleMesh'             , 'on',                  ...
        'MeshExpansion'         , 2,                     ...
        'MeshContraction'       , 0.5,                   ...
        'TolMesh'               , 1e-14,                 ...
        'TolX'                  , 1e-14,                 ...
        'TolFun'                , 1e-14,                 ...
        'MaxIter'               , [],                    ...
        'MaxFunEvals'           , [],                    ...
        'OutputFcn'             , @outputfx,             ...
        'Display'               , 'off'                  ...
        );

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

        x0 = make_param_array(1, model);                                       % Sample initial point
        [xmin,fmin,flg,out] = patternsearch(f,x0,[],[],[],[],LB,UB,[],psopt);  % Optimize

        if fmin >= res.f && k > 0 && flg==1  % If worsened minimum, use last values
            improved = 0;
        else                % Otherwise update results
            res.f = fmin;
            res.x = xmin;
            res.out = out;
            res.flg = flg;

            % Update function evaluation count
            res.neval = res.neval + out.funccount;

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
            M(11) = 0; %Bound = 0; Smooth = 1
            M(12) = norm(true_params - res.x);
            M(13) = 1; % Optimizer Fmincon=0; ps=1

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
