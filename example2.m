%% 26
% assuming that the current directory is example_RL_task
cd(fullfile('..','example_2step_task'));

% load data from all_data.mat file
fdata = load('all_data.mat');
data  = fdata.data;

subj1 = data{1};
subj1

%% 27
prior_mb = struct('mean',zeros(4,1),'variance',6.25);
fname_mb = 'lap_mb.mat';
cbm_lap(data, @model_mb, prior_mb, fname_mb);
% Running this command, prints a report on your matlab output 
% (e.g. on the command window)

% create a directory for individual output files:
mkdir('lap_subjects');

% 1st input: data
% now the input data should be the data of subject 1
data_subj = data(1);

% 2nd input: function handle of model (i.e. @model_mf)

% 3rd input: a prior struct. The size of mean should 
% be equal to the number of parameters
prior_mf = struct('mean',zeros(6,1),'variance',6.25);

% 4th input: output file
% note that here the output is associated with subject 1
% we save all output files in the lap_subjects directory
fname_mf_subj = fullfile('lap_subjects','lap_mf_1.mat');

cbm_lap(data_subj, @model_mf, prior_mf, fname_mf_subj);

% first make a list of lap_mf_* files:
fname_subjs = cell(20,1);
for n=1:length(fname_subjs)
    fname_subjs{n} = fullfile('lap_subjects',['lap_mf_' num2str(n) '.mat']);
end
fname_subjs



fname_mf = 'lap_mf.mat';
cbm_lap_aggregate(fname_subjs,fname_mf);
% Running this command prints a report on your matlab output
% (e.g. on the command window)

% 1st input: data for all subjects
fdata = load('all_data.mat');
data  = fdata.data;

% 2nd input: a cell input containing function handle to models
models = {@model_hybrid, @model_mb, @model_mf};
% note that by handle, I mean @ before the name of the function

% 3rd input: another cell input containing file-address to files saved by cbm_lap
fcbm_maps = {'lap_hybrid.mat','lap_mb.mat','lap_mf.mat'};
% note that they corresponds to models (so pay attention to the order)

% 4th input: a file address for saving the output
fname_hbi = 'hbi_2step.mat';

cbm_hbi(data,models,fcbm_maps,fname_hbi);
% Running this command prints a report on your matlab output
% (e.g. on the command window)



fname_hbi = load('hbi_2step.mat');
cbm   = fname_hbi.cbm;

cbm.output.model_frequency

cbm.output.exceedance_prob

cd(fullfile('..','example_2step_task'))

% 1st input is the file-address of the file saved by cbm_hbi
fname_hbi = 'hbi_2step.mat';

% 2nd input: a cell input containing model names
model_names = {'Hybrid', 'MB', 'MF'};
% note that they corresponds to models (so pay attention to the order)

% 3rd input: another cell input containing parameter names of the winning model
param_names = {'\alpha_1','\alpha_2','\lambda','\beta_1','w','p','\beta_2'};

% 4th input: another cell input containing transformation function associated with each parameter of the winning model
transform = {'sigmoid','sigmoid','sigmoid','exp','sigmoid','none','exp'};
% note that no transformation applied to parameter p (i.e perserveration) in the hybrid model, so we just pass 'none'.

cbm_hbi_plot(fname_hbi, model_names, param_names, transform)
% this function creates a model comparison plot (exceednace probability and model frequency) as well as 
% a plot of transformed parameters of the most frequent model.

% 1st input: the fitted cbm by cbm_hbi
fname_hbi = 'hbi_2step';

% 2nd input: the index of the model of interest in the cbm file
k = 1; % as the hybrid is the first model fed to cbm_hbi

% 3rd input: the test will be done compared with this value (i.e. this value indicates the null hypothesis)
m = 0; % here the weight parameter should be tested against m=0

% 4th input: the index of the parameter of interest 
i = 5; % here the weight parameter is the 5th parameter of the hybrid model

[p,stats] = cbm_hbi_ttest(cbm,k,m,i)

% 1st input: the fitted cbm by cbm_hbi
fname_hbi = 'hbi_2step';

% 2nd input: the index of the model of interest in the cbm file
k = 1; % as the hybrid is the first model fed to cbm_hbi

% 3rd input: the test will be done compared with this value (i.e. this value indicates the null hypothesis)
m = 0; % here the perseveration parameter should be tested against m=0

% 4th input: the index of the parameter of interest 
d = 6; % here the perseveration parameter is the 6th parameter of the hybrid model

[p,stats] = cbm_hbi_ttest(cbm,k,m,d)

% 1st input is the file-address of the file saved by cbm_hbi
fname_hbi = 'hbi_2step.mat';

% 2nd input: a cell input containing model names
model_names = {'Hybrid', 'MB', 'MF'};
% note that they corresponds to models (so pay attention to the order)

% 3rd input: another cell input containing parameter names of the winning model
param_names = {'\alpha_1','\alpha_2','\lambda','\beta_1','p','\beta_2'};

% 4th input: another cell input containing transformation function associated with each parameter of the winning model
transform = {'sigmoid','sigmoid','sigmoid','exp','none','exp'};
% note that no transformation applied to parameter p (i.e perserveration) in the hybrid model, so we just pass 'none'.

cbm_hbi_plot(fname_hbi, model_names, param_names, transform, 3)
% this function creates a model comparison plot (exceednace probability and model frequency) as well as 
% a plot of transformed parameters of the most frequent model.
