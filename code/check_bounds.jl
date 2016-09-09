function check_bounds(p_in::Array{Float64})

	aSH, aLS, aLH, aHS, aHL, b1, b2 = p_in

	# A = all([0 < i < 1 for i in p)
				
	A = all([
		0 < aSH < 1
		0 < aLS < 1
		0 < aLH < 1
		0 < aLS + aLH < 1
		0 < aHS < 1
		0 < aHL < 1
		0 < aHS + aHL < 1
		0 < b1 < 1
		0 < b2
	])
end #fn


