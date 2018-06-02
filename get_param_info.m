function [LB, UB, sigma, names] = get_param_info(paramid, stepratio)
%GET_PARAM_INFO gets the boundaries, names and step size for chosen model
%
%   Abraham Nunes (Last updated 2017-11-24)
% =========================================================================
% Set bounds
lr_lb = 0;                  lr_ub = 1;                    % learning rate
cr_lb = gaminv(0.01,5,1);   cr_ub = gaminv(0.99,5,1);     % choice randomness
p_lb  = norminv(0.01,0,0.5); p_ub = norminv(0.99,0,0.5);  % perseveration


% Specify for each task
if strcmp(paramid, 'lrcr')
    LB = [lr_lb, cr_lb]';
    UB = [lr_ub, cr_ub]';
    sigma = [(lr_ub-lr_lb)*stepratio, ...
             (cr_ub-cr_lb)*stepratio]';

    names = {'Learning Rate', 'Choice Randomness'};

elseif strcmp(paramid, 'lrcrp')
    LB = [lr_lb, cr_lb, p_lb]';
    UB = [lr_ub, cr_ub, p_ub]';
    sigma = [(lr_ub-lr_lb)*stepratio, ...
             (cr_ub-cr_lb)*stepratio, ...
             (p_ub-p_lb)*stepratio]';

    names = {'Learning Rate', 'Choice Randomness', 'Perseveration'};

elseif strcmp(paramid, 'lr2cr')
    LB = [lr_lb, lr_lb, cr_lb]';
    UB = [lr_ub, lr_ub, cr_ub]';
    sigma = [(lr_ub-lr_lb)*stepratio, ...
             (lr_ub-lr_lb)*stepratio, ...
             (cr_ub-cr_lb)*stepratio]';

    names = {'Positive Learning Rate',
             'Negative Learning Rate',
             'Choice Randomness'};

elseif strcmp(paramid, 'lr2crp')
    LB = [lr_lb, lr_lb, cr_lb, p_lb]';
    UB = [lr_ub, lr_ub, cr_ub, p_ub]';
    sigma = [(lr_ub-lr_lb)*stepratio, ...
             (lr_ub-lr_lb)*stepratio, ...
             (cr_ub-cr_lb)*stepratio, ...
             (p_ub-p_lb)*stepratio]';

     names = {'Positive Learning Rate',
              'Negative Learning Rate',
              'Choice Randomness',
              'Perseveration'};
end
