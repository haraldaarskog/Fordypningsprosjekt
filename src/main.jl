using JuMP, Gurobi, PyCall

#defining the input and output files
input_file="/Users/hara/Downloads/Fordypningsprosjekt-master/IKKE_SE_HER_JOHANNES/BP_parameters_OUS.txt"
output_file="/Users/hara/Downloads/Fordypningsprosjekt-master/IKKE_SE_HER_JOHANNES/output/output_TEST.txt"

#sets and parameters
include("setsAndParameters.jl")

#initializing the model with Gurobi as optimizer. The model is in this case
#set to stop after 600 seconds
m = Model(with_optimizer(Gurobi.Optimizer,TimeLimit=600))

#Defining the variables
@variable(m, p_var[1:D,1:R] >= 0)
@variable(m, q_var[1:D,1:R] >= 0)
@variable(m, x_var[1:I,1:U,1:S,1:D] >= 0, Int)
@variable(m, w_var[1:I,1:U,1:D,1:R,1:M] >= 0, Int)
@variable(m, u_var[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, v_var[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, alpha_var[1:I,1:U,1:D], Bin)
@variable(m, beta_var[1:S,1:D,1:R], Bin)
@variable(m, gamma_var[1:I,1:D,1:R], Bin)
@variable(m, t_var[1:D,1:R] >=0)
@variable(m, y_var[1:D] >=0)

#Only included in the extended formulation
@variable(m, a_var[1:I,1:U,1:D,1:H,1:R,1:M] >=0, Int)

#Initial objectve function
@objective(m, Min, sum(y_var[d] for d=1:D))

#Objective function for alternative 2
#@objective(m, Min, sum(z[r] for r=1:R))

#Constraints
include("constraints.jl")

#include this in the extended formulation
#include("constraints_extended.jl")

#Solving the problem
println("Running model with: ","I=",I,", U=",U,", S=",S,", D=",D,", H=",H,", R=",R,", M=",M)
optimize!(m)
println("Status: ",termination_status(m))
println("Primal status: ",primal_status(m))
println("Dual status: ",dual_status(m))
println("Objective value: ", objective_value(m))
include("printer.jl")
printOutput(true)
