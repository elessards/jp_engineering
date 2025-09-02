"""
Created on Sun May 19 15:24:03 2024

@author: Justin Pedersen
textbook: Global Positioning System by Pratap Misra and Per Enge
description: homework question 2-1
"""

############################# 
# IMPORT LIBRARIES 
#############################

import pandas
import numpy
import time
import os
import matplotlib.pyplot as plt
from datetime import datetime

############################# 
# USER INPUT
#############################
 
PRN = 25
n = pow(2,11)

############################# 
# FUNCTION(S)
#############################

def binToHexa(n):
    bnum = int(n)
    temp = 0
    mul = 1
     
    # counter to check group of 4
    count = 1
     
    # char array to store hexadecimal number
    hexaDeciNum = ['0'] * 100
     
    # counter for hexadecimal number array
    i = 0
    while bnum != 0:
        rem = bnum % 10
        temp = temp + (rem*mul)
         
        # check if group of 4 completed
        if count % 4 == 0:
           
            # check if temp < 10
            if temp < 10:
                hexaDeciNum[i] = chr(temp+48)
            else:
                hexaDeciNum[i] = chr(temp+55)
            mul = 1
            temp = 0
            count = 1
            i = i+1
             
        # group of 4 is not completed
        else:
            mul = mul*2
            count = count+1
        bnum = int(bnum/10)
         
    # check if at end the group of 4 is not
    # completed
    if count != 1:
        hexaDeciNum[i] = chr(temp+48)
         
    # check at end the group of 4 is completed
    if count == 1:
        i = i-1
         
    # printing hexadecimal number
    # array in reverse order
    print("Hexadecimal equivalent of {}:  ".format(n), end="")
    while i >= 0:
        print(end=hexaDeciNum[i])
        i = i-1

############################# 
# MAIN
#############################

os.system("clear")
print("GLOBAL POSITIONING SYSTEM - HOMEWORK PROBLEMS")
print("Code Author: Justin Pedersen")
now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
print("Date/Time: " + dt_string)
print("Homework Question 2-1")

# chipping frequency
f_prn = 10.23e6 / 10

# initialize bit registers
g1 = [1 for i in range(10)]
g2 = [1 for i in range(10)]

# PRN bit selector
if PRN == 1:
    s1 = 2-1
    s2 = 6-1
elif PRN == 2:
    s1 = 3-1
    s2 = 7-1
elif PRN == 19:
    s1 = 3-1
    s2 = 6-1
elif PRN == 25:
    s1 = 5-1
    s2 = 7-1
else:
    print("INELIGIBLE PRN!")
    exit()

# pre-allocate
xgi = []

for i in range(n):

    # 1 - register outputs
    g1_output = g1[9]
    g2_output = g2[9]

    # 2 - register left most bit (lmb) calculation
    g1_new_lmb = (g1[2] + g1[9]) % 2
    g2_new_lmb = (g2[1] + g2[2] + g2[5] + g2[7] + g2[8] + g2[9]) % 2

    # 3 - phase selector
    g2i = (g2[s1] + g2[s2]) % 2

    # 4 - C/A code
    xgi = xgi + [(g2i + g1_output) % 2]

    # 5 - shift registers
    g1[1:10] = g1[0:9]
    g1[0] = g1_new_lmb

    g2[1:10] = g2[0:9]
    g2[0] = g2_new_lmb


## A)
print("\nQuestion 2-1-A")
print("What are the first 16 chips of PRN " + str(PRN) + ", epressed in hexadecimal?")
chips_16 = ''
for i in range(16):
    chips_16 = chips_16 + str(xgi[i])

binToHexa(chips_16)
print("")

print("What are the last 16 chips of PRN " + str(PRN) + ", expressed in hexadecimal?")
chips_16 = ''
for i in range(16):
    chips_16 = chips_16 + str(xgi[(1023-16)+i])

binToHexa(chips_16)
print("")

## B)
print("\nQuestion 2-1-B")
print("Compare the C/A code output for PRN " + str(PRN) + " from epochs 1024 to 2046")
epoch1 = xgi[0:1023]
epoch2 = xgi[1023:2046]

delta = []
sum = 0
for i in range(1023):
    delta = delta + [epoch1[i] - epoch2[i]]
    sum = sum + epoch1[i] - epoch2[i]

print("Sum of delta epoch vectors = " + str(sum))
t = list(range(0, 1023))

fig = plt.figure()
plt.figure(figsize=(15, 4.8))
plt.step(t,epoch1)
plt.step(t,epoch2)
plt.title("C/A Code PRN 19")
plt.xlabel("Time")
plt.ylabel("Chips")
plt.xlim(0, 1023)
plt.legend(["epoch 1", "epoch 2"])
plt.grid(True)
plt.savefig("figures/ca_code_ep1ep2_full.png")
plt.close(fig)

fig = plt.figure()
plt.figure(figsize=(15, 4.8))
plt.step(t,epoch1)
plt.step(t,epoch2)
plt.title("C/A Code PRN 19")
plt.xlabel("Time")
plt.ylabel("Chips")
plt.xlim(400, 600)
plt.legend(["epoch 1", "epoch 2"])
plt.grid(True)
plt.savefig("figures/ca_code_ep1ep2_zoom.png")
plt.close(fig)

fig = plt.figure()
plt.figure(figsize=(15, 4.8))
plt.step(t,delta)
plt.title("Epoch 1 & Epoch 2 Delta")
plt.xlabel("Time")
plt.ylabel("Chips")
plt.xlim(0, 1023)
plt.grid(True)
plt.savefig("figures/ca_code_ep1ep2_delta.png")
plt.close(fig)