% this code tests the MOST toolbox
% runs the tutorial example 5  in MOST manual section 7.2.1
% Yaze Li
clear all; close all; clc;
%%
mpc = loadcase('ex_case3b');
xgd = loadxgendata('ex_xgd_ramp', mpc);
%%
profiles = getprofiles('ex_load_profile');
%%
mpopt = mpoption('verbose',1);

nt = size(profiles(1).values, 1); % number of periods
%% solve
mdi = loadmd(mpc, nt, xgd, [], [], profiles);
%%
mdo = most(mdi, mpopt);
EPg = mdo.results.ExpectedDispatch; % active generation
Elam = mdo.results.GenPrices; % nodal energy price
most_summary(mdo); % print results, depending on verbose option
%% Analyze the price
p_gen = sum(sum(mdo.results.GenPrices));
p_pp = sum(sum(mdo.results.RppPrices));
p_pm = sum(sum(mdo.results.RpmPrices));
p_rp = sum(sum(mdo.results.RrpPrices));
p_rm = sum(sum(mdo.results.RrmPrices));
sum([p_gen,p_pp,p_pm,p_rp,p_rm])