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

net = pn.case14()
    
# Run AC OPF
pandapower.runopp(net)
