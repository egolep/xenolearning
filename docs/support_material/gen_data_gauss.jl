import Pkg
Pkg.activate(".")

using CSV, DataFrames

function sum_first_N_numbers(N)
    N*(N+1)÷2
end

max_N = 101
m_data = Matrix{Float64}(undef,max_N,2);
for i=1:max_N
    m_data[i,1] = i
    m_data[i,2] = sum_first_N_numbers(i)
end
data = DataFrame(m_data, [:N, :Sum]);

CSV.write("src/gauss_dataset.csv", data)
