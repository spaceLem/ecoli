include("likelihood.jl")
include("gen_data.jl")
include("gen_pars.jl")
include("check_bounds.jl")

function mcmc(df2::Array{Int, 2}, df3::Array{Int, 2})
	# store N samples
	N = Int(1e6)
	burn = 1_000
	thin = max(div(N, 1000), 1)
	acceptance = 0
	
	# initial parameters, data, and LL
	df2_p = gen_data(df2)
	df3_p = gen_data(df3)

	#aSH, aLS, aLH, aHS, aHL, b1, b2, eL, eH, eE = p
	#par_p = [0.2, 0.2, 0.2, 0.2, 0.2, 0.99, 1e-5]
	#aSH, aLS, aLH, aHS, aHL, b1, b2
	par_p = [0.2, 0.2, 0.2, 0.2, 0.2, 0.99, 1e-5]

	p2x = likelihood(df2_p, par_p)
	p3x = likelihood(df3_p, par_p)
	px = p2x + p3x

	#println(df_p)
	#println(par_p)
	
	P = zeros(Float64, N, length(par_p) + 1)

	# MCMC loop
	for i = 1:N
		# copy old values
		df2_q, df3_q, par_q, qx = df2_p, df3_p, par_p, px

		# nudge data / parameters
		if mod(i, 2) == 0
			par_q = gen_pars(par_p, div(i, 2))
		else
			df2_q = gen_data(df2, df2_p)
			df3_q = gen_data(df3, df3_p)
		end #if

		# calculate LL if parameters within bounds
		valid = false
		if check_bounds(par_q)
			valid = true
			qx2 = likelihood(df2_q, par_q)
			qx3 = likelihood(df3_q, par_q)
			qx = qx2 + qx3
		end #if

		#println(round([px, qx], 5))
		
		# compare LLs, and update parameters
		if valid && rand() < exp(qx - px)
			acceptance += 1
			par_p = par_q
			df2_p = df2_q
			df3_p = df3_q
			px = qx
		end #if
		
		P[i, :] = [par_p; px]
	end #for
	
	println("acceptance = ", acceptance / N)
	#println(df_p)
	
	# remove burn in period and thin
	P = P[burn+1:thin:end, :]
end #fn

