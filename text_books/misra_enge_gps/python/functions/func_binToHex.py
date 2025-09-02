def binToHex(n):
    
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
    print("Hexadecimal equivalent of {}:  0x".format(n), end="")
    while i >= 0:
        print(end=hexaDeciNum[i])
        i = i-1
    
    print("")