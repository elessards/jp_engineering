function R_k = func_correlate_auto(n,code)

chips = length(code_k);
R_k = zeros(size(n));

for j = 1:length(n)

    sum_ac = 0;

    for i = 1:chips

        x_k = code(i);
        x_k_ipn = code(mod(i + n(j) - 1, 1023) + 1);
        sum_ac = sum_ac + x_k*x_k_ipn;
    
    end
    
    R_k(j) = (1/1023)*sum_ac;

end

end