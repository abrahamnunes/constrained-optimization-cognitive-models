function [ params ] = make_param_array(n_subjects, paramid)
%MAKE_PARAM_ARRAY Generates array of parameters for reinforcement learning
%task simulations
%
%   Abraham Nunes (Last updated 2017-11-24)
% =========================================================================
% Set bounds
lr_lb = 0.1;                lr_ub = 0.9;   % learning rate
cr_lb = gaminv(0.01,5,1);   cr_ub = gaminv(0.99,5,1);    % choice randomness
p_lb  = norminv(0.01,0,0.5); p_ub = norminv(0.99,0,0.5);   % perseveration

% Specify for each task
if strcmp(paramid, 'lrcr')
    params = NaN(n_subjects, 2);
    params(:, 1) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % LEARNING RATE
    params(:, 2) = unifrnd(cr_lb, cr_ub, [n_subjects, 1]);  % INV SOFTMAX TEMP

elseif strcmp(paramid, 'lrcrp')
    params = NaN(n_subjects, 3);
    params(:, 1) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % LEARNING RATE
    params(:, 2) = unifrnd(cr_lb, cr_ub, [n_subjects, 1]);  % INV SOFTMAX TEMP
    params(:, 3) = unifrnd(p_lb, p_ub, [n_subjects, 1]); % PERSEVERATION

elseif strcmp(paramid, 'lr2cr')
    params = NaN(n_subjects, 3);
    params(:, 1) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % POSITIVE LEARNING RATE
    params(:, 2) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % NEGATIVE LEARNING RATE
    params(:, 3) = unifrnd(cr_lb, cr_ub, [n_subjects, 1]);  % INV SOFTMAX TEMP

elseif strcmp(paramid, 'lr2crp')
    params = NaN(n_subjects, 4);
    params(:, 1) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % POSITIVE LEARNING RATE
    params(:, 2) = unifrnd(lr_lb, lr_ub, [n_subjects, 1]); % NEGATIVE LEARNING RATE
    params(:, 3) = unifrnd(cr_lb, cr_ub, [n_subjects, 1]);  % INV SOFTMAX TEMP
    params(:, 4) = unifrnd(p_lb, p_ub, [n_subjects, 1]); % PERSEVERATION
end
