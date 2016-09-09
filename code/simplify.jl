using DataFrames
using JLD

env_to_int(x::DataArrays.NAtype) = -1

env_to_int(x::Float64) = round(Int, x)

plates_to_var(x::DataArrays.NAtype) = -1

plates_to_var(x::Float64) = begin
	y = if x < 1e2; 1 		# S
		elseif x < 1e4; 2	# L
		else 3				# H
		end #if
end #fn


function convert_date(x::Int)
	if 0 < x < 13
		x += 5
	else
		x = 18 + 2(x-13)
	end #if
	x
end #fn

function simplify()

	# read data, tidy and extract
	df = readtable("../data/data1.csv")
	
	# each strain will have different parameters
	# so treat them separately
	expA = df[df[:Strain] .== "A", :]
	expB = df[df[:Strain] .== "B", :]
	expC = df[df[:Strain] .== "C", :]
	
	#types = [Char, Char, Char, Char, Char, Int]
	#names = [:c1, :c2, :c3, :c4, :c5, :env]
	#a2 = DataFrame(types, names, 18)
	
	a2 = -1ones(Int, 26, 6)
	b2 = copy(a2)
	c2 = copy(a2)
	a3 = copy(a2)
	b3 = copy(a2)
	c3 = copy(a2)
	
	# TODO: fix magic numbers
	ncols, nrows = 6, 18
	for j = 1:ncols-1, i = 1:nrows
		foo = 54j + 3i + (-56:-54)
		a2[i,j] = plates_to_var(mean(expA[foo, :Plate_count]))
		b2[i,j] = plates_to_var(mean(expB[foo, :Plate_count]))
		c2[i,j] = plates_to_var(mean(expC[foo, :Plate_count]))
		
		foo += 324
		a3[i,j] = plates_to_var(mean(expA[foo, :Plate_count]))
		b3[i,j] = plates_to_var(mean(expB[foo, :Plate_count]))
		c3[i,j] = plates_to_var(mean(expC[foo, :Plate_count]))
	end #for
	
	for i = 1:nrows
		foo = 3i + (268:270)
		a2[i,6] = env_to_int(mean(expA[foo, :Plate_count]))
		b2[i,6] = env_to_int(mean(expB[foo, :Plate_count]))
		c2[i,6] = env_to_int(mean(expC[foo, :Plate_count]))
		
		foo += 324
		a3[i,6] = env_to_int(mean(expA[foo, :Plate_count]))
		b3[i,6] = env_to_int(mean(expB[foo, :Plate_count]))
		c3[i,6] = env_to_int(mean(expC[foo, :Plate_count]))
	end #for
	
	@save "files.jld" a2 a3 b2 b3 c2 c3
end #fn

