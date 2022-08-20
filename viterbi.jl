states = ["Healthy", "Fever"]
 
observations = ["normal", "cold", "dizzy"]
 
start_probability = ["Healthy"=> 0.6, "Fever"=> 0.4]
 
transition_probability = [
   "Healthy" => ["Healthy"=> 0.7, "Fever"=> 0.3],
   "Fever" => ["Healthy"=> 0.4, "Fever"=> 0.6]
   ]
 
emission_probability = [
   "Healthy" => ["normal"=> 0.5, "cold"=> 0.4, "dizzy"=> 0.1],
   "Fever" => ["normal"=> 0.1, "cold"=> 0.3, "dizzy"=> 0.6]
   ]
 
function viterbi{K,N}(obs::Array{K}, states::Array{K}, start_p::Dict{K,N}, trans_p::Dict{K,Dict{K,N}}, emit_p::Dict{K,Dict{K,N}})
    V = [Dict{K,N}()]
    path = Dict{K,Any}()
 
    # Initialize base cases (t == 1)
    for y in states
        V[1][y] = start_p[y] * emit_p[y][obs[1]]
        path[y] = (y)
    end
 
    # Run Viterbi for t > 1
    for t = 2:length(obs)
        push!( V, Dict{K,N}() )
        newpath = Dict{K,Any}()
 
        for y in states
            (prob, state) = maximum([(V[t-1][y0] * trans_p[y0][y] * emit_p[y][obs[t]], y0) for y0 in states])
            V[t][y] = prob
            newpath[y] = ( y, path[state] )
        end
 
        # Don't need to remember the old paths
        path = newpath
    end
    n = 1           # if only one element is observed maximum is sought in the initialization values
    if length(obs)!=1
        n = length(obs)
    end
#    print_dptable(V)
    (prob, state) = maximum([(V[n][y], y) for y in states])
    return (prob, path[state])
end
 
# Don't study this, it just prints a table of the steps.
function print_dptable(V)
    print( "    " )
    for i = 1:length(V)
        @printf( "%7d ", i )
    end
    println()
    for y in keys(V[1])
        @printf( "%.5s: ", y )
        for v in V
            @printf( "%.7s ", @sprintf( "%f",  v[y]) )
        end
        println()
    end
end
 
function example()
    return viterbi(observations,
                   states,
                   start_probability,
                   transition_probability,
                   emission_probability)
end
 
start = time()
for i = 1:1000000
    example()
end
finish = time()
println( finish - start )
