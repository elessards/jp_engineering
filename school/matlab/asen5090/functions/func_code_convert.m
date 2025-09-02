function code_cor = func_code_convert(code)

% convert 0 -> 1 and 1 -> -1
code_cor = code;
code_cor(code == 0) = 1;
code_cor(code == 1) = -1;

end