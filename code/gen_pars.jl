function gen_pars(p_in::Array{Float64}, idx::Int)
	#aSH, aLS, aLH, aHS, aHL, b1, b2 = p_in
	p_out = copy(p_in)

	n = length(p_out)
	idx = mod1(idx, n)
	if idx == n
		#b2 is the last value
		p_out[idx] += 1e-6randn()
	else
		p_out[idx] += 0.1randn()
	end #if

	p_out
end #fn

