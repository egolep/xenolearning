import Pkg
Pkg.activate("../")

using DataFrames
using MLJ
using Plots

XGBoost = @load XGBoostRegressor verbosity=0

function sum_first_N_numbers(N)
    N*(N+1)÷2
end

function data_augmentation(data, features, target, augmentation=10)
    @show augmentation
    temp_x = data[!,features]
    temp_y = data[!,target]
    s1, s2 = size(temp_x)
    x = Matrix{Float64}(undef, s1*augmentation, s2)
    for i=0:augmentation-1
        x[(s1*i)+1:(s1*i)+s1, :] .= temp_x
    end
    y = Vector{Float64}(undef, s1*augmentation)
    for i=0:augmentation-1
        y[(s1*i)+1:(s1*i)+s1] .= temp_y
    end
    x, y
end

function my_amazing_ML_model(x, y)
    #W = x |> Standardizer() 
    #z = y |> Standardizer() 
    #ŷ = (x, y) |> XGBoost(seed=42)
    #ŷ = ẑ |> inverse_transform(z)
    #ŷ = (x,y) |> KPLSRegressor()
    #train, test = partition(eachindex(y), 0.7, shuffle=true)
    m = machine(XGBoost(), table(x), y)
    fit!(m, verbosity=0) #, verbosity=0, force=true)
    preds = predict(m)
    error = rms(preds, y)
    @show error
    return m, error, error/mean(y)
end

function confront_ML_Gauss(N)
    model([N ;;])[1], sum_first_N_numbers(N)
end

function plot_data(data, features, target, model)
    p1 = plot(data[!,:N], [data[!,:Sum], predict(model, data[!,[:N]])]);
    p2 = plot(predict(model, data[!,[:N]]), data[!,:Sum]);
    plot(p1, p2, layout=(2,1),size=(1000,500))
end


points=1000
m_data = Matrix{Float64}(undef,points,2);
for i=1:points
    m_data[i,1] = i
    m_data[i,2] = sum_first_N_numbers(i)
end
data = DataFrame(m_data, [:N, :Sum]);

features = [:N];
target = [:Sum];
augmentation = points÷10;

x, y = data_augmentation(data, features, target, augmentation);

model, error = my_amazing_ML_model(x, y)
#plot_data(data, features, target, model)
model, error, data, features, target
