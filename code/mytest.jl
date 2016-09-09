include("mcmc.jl")
include("simplify.jl")

if !isdefined(:a2)
	df = readtable("../data/data1.csv");
	a2, a3, b2, b3, c2, c3 = simplify(df);
end #if


df2_p = gen_data(a2)
df3_p = gen_data(a3)
par_p = [0.2, 0.2, 0.2, 0.2, 0.2, 0.99, 1e-5]

p2x = likelihood(df2_p, par_p)
p3x = likelihood(df3_p, par_p)

px = p2x + p3x

println([signif(i, 3) for i in [p2x p3x]])

