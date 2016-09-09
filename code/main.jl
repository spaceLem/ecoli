using JLD
using PyPlot

include("mcmc.jl")

function main()
	# read a2, a3, b2, b3, c2, c3
	@load "files.jld"
	
	# fit parameters to data
	P = mcmc(a2, a3)
	#P = mcmc(b2, b3)
	#P = mcmc(c2, c3)
	
	@save "results.jld" P
	
	# plot the MCMC chain
	clf()
	plot(P[:, 1:end-1])
	pars = ("aSH", "aLS", "aLH", "aHS", "aHL", "b1 ", "b2 ")
	legend(pars)
	
	mp = mean(P, 1)
	sp = std(P, 1)
	
	for i = 1:size(P, 2)-1
		print(pars[i], " ")
		println("mean: ", signif(mp[i], 3), " std: ", signif(sp[i], 3))
	end #for
	
	P
end #fn

