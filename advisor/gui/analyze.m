function RESP = analyze(X)


if nnz(X)>0
   RESP = vdoc_as_opt('visdoc',X);
else
   RESP=1;
end

return