def goldCodeSeed(prn):

    if prn == 1:
        s1 = 2
        s2 = 6
    elif prn == 2:
        s1 = 3
        s2 = 7
    elif prn == 3:
        s1 = 4
        s2 = 8
    elif prn == 4:
        s1 = 5
        s2 = 9
    elif prn == 5:
        s1 = 1
        s2 = 9
    elif prn == 6:
        s1 = 2
        s2 = 10
    elif prn == 7:
        s1 = 1
        s2 = 8
    elif prn == 8:
        s1 = 2
        s2 = 9
    elif prn == 9:
        s1 = 3
        s2 = 10
    elif prn == 10:
        s1 = 2
        s2 = 3
    elif prn == 11:
        s1 = 3
        s2 = 4
    elif prn == 12:
        s1 = 5
        s2 = 6
    elif prn == 13:
        s1 = 6
        s2 = 7
    elif prn == 14:
        s1 = 7
        s2 = 8
    elif prn == 15:
        s1 = 8
        s2 = 9
    elif prn == 16:
        s1 = 9
        s2 = 10
    elif prn == 17:
        s1 = 1
        s2 = 4
    elif prn == 18:
        s1 = 2
        s2 = 5
    elif prn == 19:
        s1 = 3
        s2 = 6
    elif prn == 20:
        s1 = 4
        s2 = 7
    elif prn == 21:
        s1 = 5
        s2 = 8
    elif prn == 22:
        s1 = 6
        s2 = 9
    elif prn == 23:
        s1 = 1
        s2 = 3
    elif prn == 24:
        s1 = 4
        s2 = 6
    elif prn == 25:
        s1 = 5
        s2 = 7
    elif prn == 26:
        s1 = 6
        s2 = 8
    elif prn == 27:
        s1 = 7
        s2 = 9
    elif prn == 28:
        s1 = 8
        s2 = 10
    elif prn == 29:
        s1 = 1
        s2 = 6
    elif prn == 30:
        s1 = 2
        s2 = 7
    elif prn == 31:
        s1 = 3
        s2 = 8
    elif prn == 32:
        s1 = 4
        s2 = 9
    else:
        print("INELIGIBLE GPS PRN!")
        exit()

    s1 = s1 - 1
    s2 = s2 - 1

    return s1, s2
    