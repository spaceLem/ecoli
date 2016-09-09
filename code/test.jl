using JLD

#include("mcmc.jl")

function fnoof()
	# read a2, a3, b2, b3, c2, c3
	d = load("files.jld")
	
	a2 = d["a2"]
	b2 = d["b2"]
	c2 = d["c2"]
	a3 = d["a3"]
	b3 = d["b3"]
	c3 = d["c3"]
	
	a2, b2, c2, a3, b3, c3

end #fn
