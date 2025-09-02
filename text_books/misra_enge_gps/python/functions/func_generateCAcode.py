def ca_code(prn):
    
    # number of chips
    n = pow(2,10) # 1024 chips

    # initialize bit registers
    g1 = [1 for i in range(10)]
    g2 = [1 for i in range(10)]

    # pre-allocate ca code chip vector
    xgi = []

    # pull gold code seed
    from functions.func_goldCodeSeed import goldCodeSeed
    s1, s2 = goldCodeSeed(prn)

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

    return xgi

