using Distributions

function sis(N::Int = 5)
	# parameters
	aSH = 0.52
	aLS = 0.5
	aLH = 0.25
	aHS = 0.33
	aHL = 0.16
	b1 = 0.98
	b2 = 1e-6
	eL = 1e2
	eH = 1e4
	eE = 0.1

	T = 18

	data = zeros(Int, T, N + 1)

	P = zeros(Float64, 3, 3)
	P[2, :] = [aLS, 1 - aLS - aLH, aLH]
	P[3, :] = [aHS, aHL, 1 - aHL - aHS]

	# initial conditions
	X = ones(Int, N + 1)
	X[1] = 3
	X[end] = 0

	data[1, :] = X

	for t = 2:T
		L = sum(X[1:N] .== 2)
		H = sum(X[1:N] .== 3)
		E = X[end]

		B = 1 - b1 * exp(-b2 * E)
		P[1,:] = [1 - B, (1 - aSH) * B, aSH * B]
		Q = cumsum(P, 2)

		for i = 1:N
			z = rand()
			for i = 1:3
				if z < Q[X[i], i]
					X[i] = i
					break
				end #if
			end #for
		end #for

		shed = eL * L + eH * H + eE * E
		X[end] = rand(Poisson(shed))

		data[t, :] = X
	end #for

	data
end #fn

