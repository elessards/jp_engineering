"""
Created on Sun May 25 14:52:03 2024

@author: Justin Pedersen
textbook: Global Positioning System by Pratap Misra and Per Enge
description: homework question 2-1
"""

############################# 
# IMPORT LIBRARIES 
#############################

import os
import matplotlib.pyplot as plt
from datetime import datetime
from functions.func_binToHex import binToHex
from functions.func_generateCAcode import ca_code

############################# 
# USER INPUT
#############################

############################# 
# MAIN
#############################

# pre-amble
os.system("clear")
print("GLOBAL POSITIONING SYSTEM - GOLD CODE GENERATOR")
print("Code Author: Justin Pedersen")
now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
print("Date/Time: " + dt_string)

# QUESTION 2-1-A
print("\nQuestion 2-1-A")
PRN = 19
ca_19 = ca_code(PRN)
print("Code for PRN " + str(PRN) + " generated.")

print("\nWhat are the first 16 chips of PRN " + str(PRN) + ", expressed in hexadecimal?")
chips_16 = ''
for i in range(16):
    chips_16 = chips_16 + str(ca_19[i])

binToHex(chips_16)
print("")

t = list(range(0, 1024))
fig = plt.figure()
plt.figure(figsize=(15, 4.8))
plt.step(t,ca_19)
plt.title("Epoch 1 & Epoch 2 Delta")
plt.xlabel("Time")
plt.ylabel("Chips")
plt.xlim(0, 1023)
plt.grid(True)
plt.savefig("figures/ca_code_prn19.png")
plt.close(fig)

# QUESTION 2-1-C
print("\nQuestion 2-1-C")
PRN = 25
ca_25 = ca_code(PRN)
print("Code for PRN " + str(PRN) + " generated.")

print("\nWhat are the first 16 chips of PRN " + str(PRN) + ", expressed in hexadecimal?")
chips_16 = ''
for i in range(16):
    chips_16 = chips_16 + str(ca_25[i])

binToHex(chips_16)
print("")

# QUESTION 2-1-D
print("\nQuestion 2-1-D")
PRN = 5
ca_05 = ca_code(PRN)
print("Code for PRN " + str(PRN) + " generated.")

print("\nWhat are the first 16 chips of PRN " + str(PRN) + ", expressed in hexadecimal?")
chips_16 = ''
for i in range(16):
    chips_16 = chips_16 + str(ca_05[i])

binToHex(chips_16)
print("")


