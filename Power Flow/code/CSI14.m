% this code uses contingency sensitivity index (CSI) in Naidji 2019 paper
% on IEEE 14 bus case in Matpower
% Yaze Li
clear all; close all; clc;
%% pre-contingency result
mpopt = mpoption('verbose',0,'out.all',0);
results = runopf('case14',mpopt);
define_constants;
lc = results.branch(:,PF);  % Line current (MW)
po = results.gen(:,PG);      % Power output (MW)
bv = results.bus(:,VM);      % Bus voltage (pu)
%% define contigency
% 4 generator outage + 20 line outage + 14 load peak
post_lc = zeros(38,20);
post_po = zeros(38,5);
post_bv = zeros(38,14);
%% powerflow after contigency
for ctgc = 1:38
    if ctgc <= 4                % generator outage
        mpc = loadcase('case14');
        mpc.gen(ctgc+1,8) = 0;
    end
    
    if ctgc > 4 && ctgc <= 24    % line outage
        mpc = loadcase('case14');
        mpc.branch(ctgc-4,11) = 0;
    end
    
    if ctgc > 24                 % load peak
        mpc = loadcase('case14');
        pd = mean(mpc.bus(:,PD));
        mpc.bus(ctgc-24,PD) = 200;
    end
    post_results = runopf(mpc,mpopt);
    post_lc(ctgc,:) = post_results.branch(:,PF)';
    post_po(ctgc,:) = post_results.gen(:,PG)';
    post_bv(ctgc,:) = post_results.bus(:,VM)';
end
%% compare results
diff_lc = abs(post_lc-lc');
diff_po = abs(post_po-po');
diff_bv = abs(post_bv-bv');
%% plot figures
figure;
surf(1:20,1:38,diff_lc)
colorbar
xlabel('Transmission lines')
ylabel('Contingencies')
zlabel('Line current flow variation (MW)')

figure;
surf(1:5,1:38,diff_po)
colorbar
xlabel('Generators')
ylabel('Contingencies')
zlabel('Power output variation (MW)')

figure;
surf(1:14,1:38,diff_bv)
colorbar
xlabel('Buses')
ylabel('Contingencies')
zlabel('Voltage deviation (pu)')
%% thresholds
% tb = median(median(diff_bv));
% tl = median(median(diff_lc));
% tg = median(median(diff_po));
tb = mean(mean(diff_bv));
tl = mean(mean(diff_lc));
tg = mean(mean(diff_po));
%% I
IVD = diff_bv > tb;
ILF = diff_lc > tl;
IPG = diff_po > tg;
%% CSM
mpc = loadcase('case14');
CSM = zeros(38,14);
for nc = 1:38
    for j = 1:14
        if IVD(nc,j) == 1
            CSM(nc,j) = 1;
        end
    end
    
    for l = 1:20
        if ILF(nc,l) == 1
            m = mpc.branch(l,F_BUS);
            n = mpc.branch(l,T_BUS);
            CSM(nc,m) = 1;
            CSM(nc,n) = 1;
        end
    end
    
    for g = 1:5
        if IPG(nc,g) == 1
            CSM(nc,g) = 1;
            
        end
    end
end
%% CSI
CSI = sum(CSM);

figure;
bar(1:14,CSI);
grid on;
xlabel('Buses');
ylabel('CSI');
% title('CSI with medianan as threshold')
title('CSI with mean as threshold')