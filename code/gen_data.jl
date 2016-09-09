function gen_data(ref_df::Array{Int, 2}, last_df::Array{Int, 2}, idx::Int)
	new_df = copy(last_df)
	
	mask = ref_df .== -1
	
	if sum(mask) > 0
		#idx = rand(find(mask))
		idx = mod1(idx, sum(mask))
		if idx <= 5 * size(ref_df, 1)
			# S L H
			new_df[idx] = rand(setdiff(1:3, last_df[idx]))
		else
			# Env
			new_df[idx] += round(Int, 10randn())
		end #if
	end #if
	
	new_df
end #fn


function gen_data(ref_df::Array{Int, 2})
	new_df = copy(ref_df)
	
	for i = 1:length(new_df)
		if new_df[i] == -1
			if i <= 5 * size(ref_df, 1)
				new_df[i] = rand(1:3)
			else
				mu = mean(max(ref_df[2:end, 6], 0))
				new_df[i] = round(Int, mu * randexp())
			end #if
		end #if
	end #for
	
	new_df
end #fn

