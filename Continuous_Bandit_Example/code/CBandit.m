%this file simulates the continuous bandit problem in the DPG paper
clear all; close all; clc;
%% prepare the variables
m = [10,25,50]; %the dimension of the action space
n = 1; %the dimension of the parameter vector
coef = [1e-2,1e-1,1];
var_beta = 1;   %off-policy variance
gamma = 1;  %reward discount
learn_rate = [5e-3,8e-4,3e-5];

%% COPDAC
for i=1:3
    a_star = 4*ones(m(i),1);   %best action
    s = RandStream('mlfg6331_64');  %keep the simulation result the same
    eigen = datasample(s,[0.1,1],m(i),'Replace',true); %random picked eigen value
    %eigen = 0.5*ones(m(i),1);
    C = diag(eigen);    %matrix C
    re = @(x) coef(i)*(x-a_star)'*C*(x-a_star); %quadratic cost function
    alpha_theta = learn_rate(i);
    alpha_w = learn_rate(i);
    for run = 1:5
        for T = 1:10000    %time-steps
            theta = 1.1*(i+3)*ones(n,T); %policy parameter matrix; initial theta is 1 vector
            w = ones(n,T); %value function parameter matrix; initial is 1
            a = zeros(m(i),T); %action matrix
            %rng(T)
            a(:,1) = theta(:,1) + sqrt(var_beta)*randn(1)*ones(m(i),1);    %initial a1
            r = zeros(T,1); %return vector
            delta = zeros(T,1); %delta vector
            
            for t = 1:T
                r(t) = re(a(:,t));   %r_t
                %rng(t)
                a(:,t+1) = theta(:,t) + sqrt(var_beta)*randn(1)*ones(m(i),1);  %a_{t+1}
                delta(t) = r(t)+gamma*sum(a(:,t+1)-theta(:,t))*w(:,t)-sum(a(:,t)-theta(:,t))*w(:,t);    %delta_t
                theta(:,t+1) = theta(:,t)-alpha_theta*m(i)*w(:,t); %theta_{t+1}
                w(:,t+1) = w(:,t)+alpha_w*delta(t)*sum(a(:,t)-theta(:,t)); %w_{t+1}
            end
            if isnan(mean(r))
                cost(run,T) = cost(run,T-1);
            else
                cost(run,T)=mean(r);
            end
        end
    end
    y(i,:) = mean(cost);
end
%% SAC

%% show results
figure
loglog(1:10000,y(1,:));
xlim([1e+2,1e+4])
grid on
xlabel('Time-steps')
ylabel('Cost')
title('10 action dimension')
figure
loglog(1:10000,y(2,:));
xlim([1e+2,1e+4])
ylim([1e-1,1e+1])
grid on
xlabel('Time-steps')
ylabel('Cost')
title('25 action dimension')
figure
loglog(1:10000,y(3,:));
grid on
xlim([1e+2,1e+4])
xlabel('Time-steps')
ylabel('Cost')
title('50 action dimension')
%%
%save COPDAC1000.mat