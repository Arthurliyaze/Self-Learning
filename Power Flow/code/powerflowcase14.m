%this code uses Newton-Raphson mathod to calculate
%the power flow of IEEE-14 bus system and compare
%with matpower result
%Yaze Li
clear all; close all; clc;
%% Load and calculate data
IEEE14data;
BMva = 100;                 % Base MVA..
bus = busdata(:,1);            % Bus Number..
type = busdata(:,10);           % Type of Bus 1-Slack, 2-PV, 3-PQ..
V = busdata(:,2);              % Specified Voltage..
del = busdata(:,3);            % Voltage Angle..
Pg = busdata(:,4)/BMva;        % PGi..
Qg = busdata(:,5)/BMva;        % QGi..
Pl = busdata(:,6)/BMva;        % PLi..
Ql = busdata(:,7)/BMva;        % QLi..
Pmin = 0;                      % Minimum Active Power Limit..
Pmax = 100/BMva;               % Maximum Active Power Limit..
Qmin = busdata(:,8)/BMva;      % Minimum Reactive Power Limit..
Qmax = busdata(:,9)/BMva;     % Maximum Reactive Power Limit..
Vmin = 0.94;                %Minimum Voltae magnitude
Vmax = 1.06;                %Maxmum Voltage magnitude
P = Pg - Pl;                % Pi = PGi - PLi..
Q = Qg - Ql;                % Qi = QGi - QLi..
Psp = P;                    % P Specified..
Qsp = Q;                    % Q Specified..
G = real(Y);                % Conductance matrix..
B = imag(Y);                % Susceptance matrix..

pv = find(type == 2 | type == 1);   % PV Buses..
pq = find(type == 3);               % PQ Buses..
npv = length(pv);                   % No. of PV buses..
npq = length(pq);                   % No. of PQ buses..
%% N-R method
tolerance = 1;
iteration = 1;
while (tolerance > 0.0000001)
    
    P = zeros(nbus,1);
    Q = zeros(nbus,1);
    % Calculate P and Q
    for i = 1:nbus
        for k = 1:nbus
            P(i) = P(i) + V(i)* V(k)*(G(i,k)*cos(del(i)-del(k)) + B(i,k)*sin(del(i)-del(k)));
            Q(i) = Q(i) + V(i)* V(k)*(G(i,k)*sin(del(i)-del(k)) - B(i,k)*cos(del(i)-del(k)));
        end
    end
    
    % Checking P-limit violations..
    %if iteration <= 7 && iteration > 2    % Only checked up to 7th iterations..
    for n = 2:nbus
        %if type(n) == 2
            if P(n) < Pmin
                V(n) = V(n) + 0.01;
            elseif P(n) > Pmax
                V(n) = V(n) - 0.01;
            end
        %end
    end
    %end
    
    % Checking Q-limit violations..
    %if iteration <= 7 && iteration > 2    % Only checked up to 7th iterations..
    for n = 2:nbus
        %if type(n) == 2
            if Q(n) < Qmin(n)
                V(n) = V(n) + 0.01;
            elseif Q(n) > Qmax(n)
                V(n) = V(n) - 0.01;
            end
        %end
    end
    
    % Calculate change from specified value
    dPa = Psp-P;
    dQa = Qsp-Q;
    k = 1;
    dQ = zeros(npq,1);
    for i = 1:nbus
        if type(i) == 3
            dQ(k,1) = dQa(i);
            k = k+1;
        end
    end
    dP = dPa(2:nbus);
    M = [dP; dQ];       % Mismatch Vector
    
    % Checking V-limit violations..
    %if iteration <= 7 && iteration > 2    % Only checked up to 7th iterations..
    for n = 2:nbus
        if V(n) < Vmin
            V(n) = Vmin;
        elseif V(n) > Vmax
            V(n) = Vmax;
        end
    end
    %end
    
    
    
    
    % Jacobian
    % H - Derivative of Real Power Injections with Angles..
    H = zeros(nbus-1,nbus-1);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    H(i,k) = H(i,k) + V(m)* V(n)*(-G(m,n)*sin(del(m)-del(n)) + B(m,n)*cos(del(m)-del(n)));
                end
                H(i,k) = H(i,k) - V(m)^2*B(m,m);
            else
                H(i,k) = V(m)* V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    % N - Derivative of Real Power Injections with V..
    N = zeros(nbus-1,npq);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    N(i,k) = N(i,k) + V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                N(i,k) = N(i,k) + V(m)*G(m,m);
            else
                N(i,k) = V(m)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % K - Derivative of Reactive Power Injections with Angles..
    K = zeros(npq,nbus-1);
    for i = 1:npq
        m = pq(i);
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    K(i,k) = K(i,k) + V(m)* V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                K(i,k) = K(i,k) - V(m)^2*G(m,m);
            else
                K(i,k) = V(m)* V(n)*(-G(m,n)*cos(del(m)-del(n)) - B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % L - Derivative of Reactive Power Injections with V..
    L = zeros(npq,npq);
    for i = 1:npq
        m = pq(i);
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    L(i,k) = L(i,k) + V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
                end
                L(i,k) = L(i,k) - V(m)*B(m,m);
            else
                L(i,k) = V(m)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    J = [H N; K L];     % Jacobian Matrix..
    
    X = J\M;           % Correction Vector
    dDel = X(1:nbus-1);      % Change in Voltage Angle..
    dV = X(nbus:end);       % Change in Voltage Magnitude..
    
    % Updating State Vectors..
    del(2:nbus) = dDel + del(2:nbus);    % Voltage Angle..
    k = 1;
    for i = 2:nbus
        if type(i) == 3
            V(i) = dV(k) + V(i);        % Voltage Magnitude..
            k = k+1;
        end
    end
    
    iteration = iteration + 1;
    tolerance = max(abs(M));                  % Tolerance..
    
end
V1 = V;
del1 = del;
%% Matpower
result = runopf('case14');
V2 = result.bus(:,8);
del2 = result.bus(:,9);
%% Compare
close all;

figure;
plot(1:14,V1,'r+-','LineWidth',1.5);
grid on;
hold on;
plot(1:14,V2,'b*:','LineWidth',1.5);
legend('N-R','Matpower');
xlim([1,14])
ylim([1,1.07])
xlabel('Bus number');
ylabel('Voltage magnitude (pu)');

figure;
plot(1:14,del1/pi*180,'r+-','LineWidth',1.5);
grid on;
hold on;
plot(1:14,del2,'b*:','LineWidth',1.5);
legend('N-R','Matpower');
xlim([1,14])
xlabel('Bus number');
ylabel('Voltage angle (deg)');