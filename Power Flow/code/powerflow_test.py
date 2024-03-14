# -*- coding: utf-8 -*-
"""
Created on Fri Feb 20 07:09:29 2020
This code compares the power flow results of IEEE 14-bus system
between python code and Matpower result.
@author: Yaze Li
"""
import numpy as np
import pandapower
import pandapower.networks as pn
import matplotlib.pyplot as plt
#%% Calculate powerflow with python
Pg = np.zeros((5,5))
Pb = np.array([0,0,0,0.71,-0.71])
Pl = np.array([65.1275,61.8925,58.4225,56.585,58.0775])
Pw = np.array([130.7692,146.1538,200.0000,123.0769,223.0769])
nt = 1
hour_cost = np.zeros(5)
for t in range(nt):
    net = pn.case14()
    # Change the load in case14
    net.load.p_mw[3] = Pl[t]
    
    # Add wind power as generator
    pandapower.create_gen(net, 4, p_mw = Pw[t], vm_pu = 1, name = 'wind',
                          max_p_mw = Pw[t], min_p_mw = 0,
                          max_q_mvar = 50, min_q_mvar = -50)
    
    # Add storage at bus 14
    pandapower.create_storage(net, 13, p_mw = Pb[t], max_e_mwh = 10)
    
    # Run AC OPF
    pandapower.runopp(net)
    
    # Save results
    Pg[0,t] = -net.res_bus.to_numpy()[0,2]
    Pg[1:5,t] = net.res_gen.to_numpy()[0:4,0]
    hour_cost[t] = net.res_cost
cost = sum(hour_cost)    