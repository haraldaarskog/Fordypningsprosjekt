using JuMP, Gurobi, PyCall
plt = pyimport("matplotlib.pyplot")
include("setsAndParameters.jl")



m = Model(with_optimizer(Gurobi.Optimizer))
@variable(m, p[1:D,1:R] >= 0, Int)
@variable(m, q[1:D,1:R] >= 0, Int)
@variable(m, x[1:I,1:U,1:S,1:D] >= 0, Int)
@variable(m, w[1:I,1:U,1:D,1:R,1:M] >= 0, Int)
@variable(m, u_i[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, v[1:I,1:U,1:D,1:H,1:R] >= 0, Int)
@variable(m, alpha[1:I,1:U,1:D], Bin)
@variable(m, beta[1:S,1:D,1:R], Bin)
@variable(m, gamma[1:I,1:D,1:R], Bin)
@variable(m, zeta[1:S,1:D]>=0, Int) #number of open slots at the scanner s at day d
@variable(m, open_task_dr[1:D,1:R] >=0, Int)

#Objective function
@objective(m, Min, sum(p[d,r]+q[d,r] for d=1:D, r=1:R));

#Deltas
@constraint(m,[d=1:D, r=1:R], q[d,r]-p[d,r] + open_task_dr[d,r]==G)

#minimum number of hours a radiologist can work per day
@constraint(m,[d=1:D,r=1:R], open_task_dr[d,r] + sum(T_im[i,m]*w[i,u,d,r,m]  for i=1:I,u=1:U, m in [1,2])+sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I)>=K_dr[d,r]-Q_d)

#maximum number of hours a radiologist can work per day
@constraint(m,[d=1:D,r=1:R], open_task_dr[d,r] + sum(T_im[i,m]*w[i,u,d,r,m]  for i=1:I,u=1:U, m in [1,2])+sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I)<=K_dr[d,r]+Q_d)

#The total number of working hours for each radiologist must equal Q_w
@constraint(m, [r=1:R], sum(open_task_dr[d,r] for d=1:D)+sum(T_im[i,m]*w[i,u,d,r,m] for i=1:I, u=1:U, d=1:D, m in [1,2]) + sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S, d=1:D)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I, d=1:D)==Q_w)

#The sum of all internal interpretation tasks for u a given day h must equal the number of w[m=1] the same day
#The same goes to v.
@constraint(m,[i=1:I,u=1:U,h=1:H, r=1:R], sum(u_i[i,u,d,h,r] for d=1:D) == sum(w[i,u,h,r,m] for m=1))
@constraint(m,[i=1:I,u=1:U,h=1:H, r=1:R], sum(v[i,u,d,h,r] for d=1:D) == sum(w[i,u,h,r,m] for m=2))

#Making sure that internal interpretations can be done the current and the following week
for i=1:I, u=1:U, d=1:D
    if d+B_iu[i] <= 7
        @constraint(m, [i,u,d], sum(x[i,u,s,d] for s=1:S) - sum(u_i[i,u,d,h,r] for r=1:R,h=d:d+B_iu[i] if h <= D) == 0)
    else
        @constraint(m, [i,u,d], sum(x[i,u,s,d] for s=1:S) - sum(u_i[i,u,d,h,r] for r=1:R,h=d:d+B_iu[i] if h <= D) - sum(u_i[i,u,d,h,r] for r=1:R, h=1:(d+B_iu[i])%7 if h<d) == 0)
    end
end

#Making sure that external interpretations can be done the current and the following week
for i=1:I, u=1:U, d=1:D
    if d+B_iu[i,u] <= 7
        @constraint(m, [i,u,d], sum(v[i,u,d,h,r] for r=1:R, h=d:d+B_iu[i,u] if h<=D) == E_iud[i,u,d])
        @constraint(m, [i,u,d], sum(v[i,u,d,h,r] for r=1:R, h=1:d-1) == 0) #Setter starten av uka =0
        @constraint(m, [i,u,d], sum(v[i,u,d,h,r] for r=1:R, h=(d+B_iu[i,u]+1:D) if h <= D)==0)  #20
    else
        @constraint(m, [i,u,d], sum(v[i,u,d,h,r] for r=1:R, h=d:d+B_iu[i,u] if h<=D) + sum(v[i,u,d,h,r] for r=1:R, h=1:(d+B_iu[i,u])%7 if h<d) == E_iud[i,u,d])
        @constraint(m, [i,u,d], sum(v[i,u,d,h,r] for r=1:R,h=((d+B_iu[i,u])%7) + 1:(d-1)) == 0)    #setter midten av uka =0
    end
end

#Connecting D_iuD to alpha
@constraint(m,[i=1:I,u=1:U], sum(alpha[i,u,d] for d=1:D)>=D_iuD[i,u])

#Connecting alpha to x
@constraint(m,[i=1:I,u=1:U, d=1:D], sum(x[i,u,s,d] for s=1:S)>=alpha[i,u,d])

#The number of internal interpretations must equal number of assigned slots
#We have to include this constraint, otherwise the w can be set to meet G_dr
@constraint(m, sum(w[i,u,d,r,m] for i=1:I, u=1:U, d=1:D, r=1:R, m=1)==sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))

#Constraints that deals with demand. Either comment out the two first ones, or the third one.
@constraint(m, [i=1:I, u=1:U], sum(x[i,u,s,d] for s=1:S, d=1:D)<=(D_iuW_NY[i,u]+Percentage)*sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))
@constraint(m, [i=1:I, u=1:U], sum(x[i,u,s,d] for s=1:S, d=1:D)>=(D_iuW_NY[i,u]-Percentage)*sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))
#@constraint(m,[i=1:I,u=1:U], sum(x[i,u,s,d] for s=1:S,d=1:D)>=D_iuW[i,u])

#All the available slots has to be filled up
@constraint(m,[s=1:S,d=1:D], sum(x[i,u,s,d] for i=1:I,u=1:U)==N_sd[s,d]-S_sd[s,d])

#Demand for radiologists the MDT-meetings
@constraint(m,[i=1:I,d=1:D], sum(gamma[i,d,r] for r=1:R)==A_id[i,d])


#Demand for radiologists for monitoring the scanners
@constraint(m,[s=1:S,d=1:D], sum(beta[s,d,r] for r=1:R)==L_sd[s,d])


#Maximum share of work week that can be devoted to monitoring a scanner
@constraint(m,[r=1:R], sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S, d=1:D)<=0.5*Q_w)

#specialized scanners
@constraint(m, [i=1:I,s=1:S], sum(x[i,u,s,d] for u=1:U, d=1:D)<=1000*L_isA[i,s])


#EXTENSIONS - NOT INCLUDED IN THE INITIAL MODEL

#Radiologist specializations
#@constraint(m, [i=1:I, r=1:R], sum(w[i,u,d,r,m] for u=1:U, d=1:D, m=1:M)<=1000*Preferanse_ir[i,r])

optimize!(m)
println("Status: ",termination_status(m))
println("Primal status: ",primal_status(m))
println("Dual status: ",dual_status(m))
println("Objective value: ", objective_value(m))
include("printer.jl")
