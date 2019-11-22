using JuMP, Gurobi, PyCall

input_file="/Users/haraldaarskog/GoogleDrive/Fordypningsprosjekt/Kode/BP_parameters.txt"
output_file="/Users/haraldaarskog/GoogleDrive/Fordypningsprosjekt/Kode/output/output.txt"

include("setsAndParameters.jl")

#***********************************Variables***********************************
m = Model(with_optimizer(Gurobi.Optimizer))
@variable(m, p[1:D,1:R] >= 0)
@variable(m, q[1:D,1:R] >= 0)
@variable(m, x[1:I,1:U,1:S,1:D] >= 0, Int)
@variable(m, w[1:I,1:U,1:D,1:R,1:M] >= 0, Int)
@variable(m, u_i[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, v[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, alpha[1:I,1:U,1:D], Bin)
@variable(m, beta[1:S,1:D,1:R], Bin)
@variable(m, gamma[1:I,1:D,1:R], Bin)
#@variable(m, zeta[1:S,1:D]>=0, Int) #number of open slots at the scanner s at day d
@variable(m, t[1:D,1:R] >=0, Int)
@variable(m, y[1:D] >=0)
#****************************************************************************************





#***********************************Objective function***********************************
#@objective(m, Min, sum(p[d,r]+q[d,r] for d=1:D, r=1:R));
@objective(m, Min, sum(y[d] for d=1:D))
#****************************************************************************************
include("constraints.jl")


#***********************************Solving*****************************************************
optimize!(m)
println("Status: ",termination_status(m))
println("Primal status: ",primal_status(m))
println("Dual status: ",dual_status(m))
println("Objective value: ", objective_value(m))
include("printer.jl")
printOutput(true)
