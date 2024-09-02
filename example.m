%% 1
% enter the example_RL_task folder, 
% which contains data and models for this example
% (assuming that you are in the directory of the manual)
cd(fullfile('example_RL_task'));

%% 2
fdata = load('all_data.mat');
data = fdata.data;

subj1 = data{1};
subj2 = data{2};

%% 3
addpath(fullfile('..','codes'));

% load data from all_data.mat file
fdata = load('all_data.mat');
data  = fdata.data;

%% 4
% data of subject 1
subj1 = data{1};

parameters = randn(1,2);
F1 = model_RL(parameters,subj1)

parameters = randn(1,3);
F2 = model_dualRL(parameters,subj1)

%% 5
parameters = [-10 10];
F1 = model_RL(parameters,subj1)

parameters = [-10 10 10];
F2 = model_dualRL(parameters,subj1)

%% 6
v     = 6.25;
prior_RL = struct('mean',zeros(2,1),'variance',v); % note dimension of 'mean'
prior_dualRL = struct('mean',zeros(3,1),'variance',v); % note dimension of 'mean'

%% 7
fname_RL = 'lap_RL.mat'; 
fname_dualRL = 'lap_dualRL.mat';

%% 8
cbm_lap(data, @model_RL, prior_RL, fname_RL);
% Running this command, prints a report on your matlab output 
% (e.g. on the command window)

%% 9
cbm_lap(data, @model_dualRL, prior_dualRL, fname_dualRL);
% Running this command, prints a report on your matlab output 
% (e.g. on the command window)

%% 10
fname = load('lap_RL.mat');
cbm   = fname.cbm;
% look at fitted parameters
cbm.output.parameters

%% 11
% 1st input: data for all subjects
fdata = load('all_data.mat');
data  = fdata.data;

% 2nd input: a cell input containing function handle to models
models = {@model_RL, @model_dualRL};
% note that by handle, I mean @ before the name of the function

% 3rd input: another cell input containing file-address to files saved by cbm_lap
fcbm_maps = {'lap_RL.mat','lap_dualRL.mat'};
% note that they corresponds to models (so pay attention to the order)

% 4th input: a file address for saving the output
fname_hbi = 'hbi_RL_dualRL.mat';


%% 12
out = cbm_hbi(data,models,fcbm_maps,fname_hbi);
% Running this command, prints a report on your matlab output 
% (e.g. on the command window)

%% 13
fname_hbi = load('hbi_RL_dualRL.mat');
cbm   = fname_hbi.cbm;
cbm.output

%% 14
model_frequency = cbm.output.model_frequency

%% 15
group_mean_RL = cbm.output.group_mean{1}
% group mean for parameters of model_RL

group_mean_dualRL = cbm.output.group_mean{2}
% group mean for parameters of model_dualRL

%TEST: 
% 
% group_mean_RL =
% 
%    -1.8854   -0.0098
% 
% 
% group_mean_dualRL =
% 
%     1.0678   -0.2944    1.1510



%% 16
x = -5:.1:5;
y = 1./(1+exp(-x));
plot(x,y);
title('y = sigmoid(x)'); xlabel('x'); ylabel('y');

%% 17
group_errorbar_RL = cbm.output.group_hierarchical_errorbar{1};
group_errorbar_dualRL = cbm.output.group_hierarchical_errorbar{2};

%% 18
% 1st input is the file-address of the file saved by cbm_hbi
fname_hbi = 'hbi_RL_dualRL.mat';

% 2nd input: a cell input containing model names
model_names = {'RL', 'Dual RL'};
% note that they corresponds to models (so pay attention to the order)

% 3rd input: another cell input containing parameter names of the winning model
param_names = {'\alpha^+','\alpha^-','\beta'};
% note that '\alpha^+' is in the latex format, which generates a latin alpha

% 4th input: another cell input containing transformation function associated with each parameter of the winning model
transform = {'sigmoid','sigmoid','exp'};
% note that if you use a less usual transformation function, you should pass the handle here (instead of a string)

cbm_hbi_plot(fname_hbi, model_names, param_names, transform)
% this function creates a model comparison plot (exceednace probability and model frequency) as well as 
% a plot of transformed parameters of the most frequent model.
%% 19
parameters_RL = cbm.output.parameters{1};
parameters_dualRL = cbm.output.parameters{2};

%% 20
responsibility = cbm.output.responsibility

%% 21
figure();
plot(responsibility(:,2)); ylim([-.1 1.1])

%% 22
xp = cbm.output.exceedance_prob

%TEST: xp = [0.0041    0.9959]

%% 23
pxp = cbm.output.protected_exceedance_prob

%TEST: pxp = [NaN  NaN]

%% 24
fdata = load('all_data.mat');
data  = fdata.data;

fname_hbi = 'hbi_RL_dualRL';

% 1st input is data, 
% 2nd input is the file-address of the file saved by cbm_hbi
cbm_hbi_null(data,fname_hbi);
% Running this command, prints a report on your matlab output 
% (e.g. on the command window)

%% 25
fname_hbi = load('hbi_RL_dualRL.mat');
cbm   = fname_hbi.cbm;
pxp   = cbm.output.protected_exceedance_prob

%TEST: pxp = [0.0041    0.9959]
