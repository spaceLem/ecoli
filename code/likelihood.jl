function likelihood(df::Array{Int, 2}, p::Array{Float64})

	#aSH, aLS, aLH, aHS, aHL, b1, b2, eL, eH, eE = p
	aSH, aLS, aLH, aHS, aHL, b1, b2 = p

	# Transition matrix
	P = zeros(Float64, 3, 3)
	P[2, :] = [aLS, 1-aLS-aLH, aLH]
	P[3, :] = [aHS, aHL, 1-aHS-aHL]
	
	# Log Likelihood
	LL = 0.0
	
	nrows, ncols = size(df)
	
	for i = 3:nrows
		# transmission changes with Env
		B = 1 - b1 * exp(-b2 * df[i-1, end])
		P[1, :] = [1 - B, (1 - aSH) * B, aSH * B]

		if any(P .< 0)
			println("P = ")
			println(round(P, 5))
		end #if

		for j = 1:ncols-1
			Lk = P[df[i-1, j], df[i, j]]

			if Lk == 0
				println("p=0 at ",[i,j])
				@show df[i-1:i, :]
				@show p
				@show P
			end #if

			LL += ifelse(Lk > 0, log(Lk), -1e5)

		end #for

		#=
		L = sum(df[i-1, 1:end-1] .== 2)
		H = sum(df[i-1, 1:end-1] .== 3)
		E = df[i-1, end]

		shed = eL*L + eH*H + eE*E

		Lk = pdf(Poisson(shed), df[i, end])
		LL += ifelse(Lk > 0, log(Lk), -1e5)
		=#
		
	end #for

	#println("Log Likelihood = ", LL)

	LL
end #fn

