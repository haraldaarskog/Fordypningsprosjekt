using JuMP, Gurobi

#defining the input and output files
input_file = "/Users/hara/Downloads/Fordypningsprosjekt-master/src/BP_parameters_OUS.txt"
output_file = "/Users/hara/Downloads/Fordypningsprosjekt-master/src/output/output_TEST.txt"


#sets and parameters
include("setsAndParameters.jl")

#initializing the model with Gurobi as optimizer. The model is in this case
#set to stop after 600 seconds
model = Model(with_optimizer(Gurobi.Optimizer) )

#Defining the variables
@variable(model, y_var[1:D] >= 0 )
@variable(model, z_var[1:R] >= 0 )
@variable(model, p_var[1:D, 1:R] >= 0 )
@variable(model, q_var[1:D, 1:R] >= 0 )
@variable(model, t_var[1:D, 1:R] >= 0 )
@variable(model, h_var[1:D, 1:R] >= 0 )
@variable(model, beta_var[1:S, 1:D, 1:R], Bin )
@variable(model, gamma_var[1:I, 1:D, 1:R], Bin )
@variable(model, alpha_var[1:I, 1:U, 1:D], Bin )
@variable(model, x_var[1:I, 1:U, 1:S, 1:D] >= 0, Int )
@variable(model, w_var[1:I, 1:U,1:D, 1:R, 1:M] >= 0, Int )
@variable(model, u_var[1:I, 1:U,1:D, 1:H, 1:R] >= 0, Int )
@variable(model, v_var[1:I, 1:U,1:D, 1:H, 1:R] >= 0, Int )



#Only included in the extended formulation
#@variable(model, a_var[1:I,1:U,1:D,1:H,1:R,1:M] >=0, Int )

#Initial objectve function
@objective(model, Min, sum(y_var[d] for d = 1:D) )

#Objective function for alternative 2
#@objective(model, Min, sum(z_var[r] for r = 1:R) )

#Constraints
include("constraints.jl")

#include this in the extended formulation
#include("constraints_extended.jl")

#Solving the problem
println("Running model with: ","I=",I,", U=",U,", S=",S,", D=",D,", H=",H,", R=",R,", M=",M )
optimize!(model )
println("Status: ", termination_status(model) )
println("Primal status: ", primal_status(model) )
println("Dual status: ", dual_status(model) )
println("Objective value: ", objective_value(model) )
include("printer.jl")
printOutput(false)
