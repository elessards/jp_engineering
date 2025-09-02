function [code] = func_gen_code_CA(prn,chips,delay)

% g2 register taps for given PRN
ca_code_taps = readmatrix('/Users/jp/Library/CloudStorage/GoogleDrive-elessards@gmail.com/My Drive/Code/matlab/school/asen5090/data/gps_ca_code.csv');
idx = find(ca_code_taps(:,1) == prn);
prn_bit1 = ca_code_taps(idx,2);
prn_bit2 = ca_code_taps(idx,3);

% initialize both G1 and G2 bit shift registers (bsr) with ones
g1_bsr = ones(1,10);
g2_bsr = ones(1,10);

code_full = zeros(1,1023);
for i = 1:1023
    % generate XG_i C/A Code
    s1 = g2_bsr(prn_bit1);
    s2 = g2_bsr(prn_bit2);
    G2_i = bitxor(s1,s2);
    
    % save g1 out
    G1 = g1_bsr(10);

    % update C/A code
    code_full(i) = bitxor(G1, G2_i);
    
    % generate new register bits for g1 and g2
    g1_new = bitxor(g1_bsr(3),g1_bsr(10));
    g2_new = bitxor(bitxor(bitxor(bitxor(bitxor(g2_bsr(2),g2_bsr(3)),g2_bsr(6)),g2_bsr(8)),g2_bsr(9)),g2_bsr(10));
    
    % shift the register and add the new bit to the leftmost element
    g1_bsr = [g1_new g1_bsr(1:9)];
    g2_bsr = [g2_new g2_bsr(1:9)];
    
end

% apply circular delay (wrap-around shift)
code_shifted = circshift(code_full, [0 delay]);

% extract requested number of chips
% wrap indices with mod to avoid running off the end
idx = mod(0:chips-1, 1023) + 1;
code = code_shifted(idx);

end