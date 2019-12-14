#Initial formulation
@constraint(model, [d = 1:D, r = 1:R], q_var[d, r] + p_var[d, r] <= y_var[d] )

#Constraints connected to alternative formulation 1
#@constraint(model, [d = 1:D, r = 1:R], t_var[d, r] <= y_var[d] )

#Constraints connected to alternative formulation 2
#@constraint(model, [d = 1:D, r = 1:R], p_var[d, r] + q_var[d, r] <= z_var[r] )

#Constraints capturing the deviation from target value G
@constraint(model, [d = 1:D, r = 1:R], q_var[d, r] - p_var[d, r] + t_var[d, r] == G )

#Defining the h_var variables
@constraint(model, [d = 1:D, r = 1:R], h_var[d, r] == t_var[d, r] + sum(T_im[i, m] * w_var[i, u, d, r, m] for i = 1:I, u = 1:U, m in [1,2]) + sum(T_sd_Scan[s, d] * beta_var[s, d, r] for s = 1:S) + sum(T_i_MD[i] * gamma_var[i, d, r] for i = 1:I))

#minimum number of hours a radiologist can work per day
@constraint(model, [d = 1:D, r = 1:R], h_var[d, r] >= K_dr[d, r] - Q_d )

#maximum number of hours a radiologist can work per day
@constraint(model, [d = 1:D, r = 1:R], h_var[d, r] <= K_dr[d, r] + Q_d )

#The total number of working hours for each radiologist must equal Q_w
@constraint(model, [r = 1:R], sum(h_var[d, r] for d = 1:D) == Q_w )

#The sum of all internal and external interpretation tasks for u a given day h
#must equal the number of w the same day
@constraint(model, [i = 1:I, u = 1:U, h = 1:H, r = 1:R], sum(u_var[i, u, d, h, r] for d = 1:D) == sum(w_var[i, u, h, r, m] for m = 1) )
@constraint(model, [i = 1:I, u = 1:U, h = 1:H, r = 1:R], sum(v_var[i, u, d, h, r] for d = 1:D) == sum(w_var[i, u, h, r, m] for m = 2) )

#Making sure that internal interpretations can be done the current and the following week
for i = 1:I, u = 1:U, d = 1:D
    if d + B_iu[i,u] <= 7
        @constraint(model, [i, u, d], sum(x_var[i, u, s, d] for s = 1:S) - sum(u_var[i, u, d, h, r] for r = 1:R, h = d:(d + B_iu[i,u]) if h <= D) == 0 )
    else
        @constraint(model, [i, u, d], sum(x_var[i, u, s, d] for s = 1:S) - sum(u_var[i, u, d, h, r] for r = 1:R, h = d:(d + B_iu[i,u]) if h <= D) - sum(u_var[i, u, d, h, r] for r = 1:R, h = 1:(d + B_iu[i, u])%7 if h < d) == 0 )
    end
end

#Making sure that external interpretations can be done the current and the following week
for i = 1:I, u = 1:U, d = 1:D
    if d + B_iu[i, u] <= 7
        @constraint(model, [i, u, d], sum(v_var[i, u, d, h, r] for r = 1:R, h = d:(d + B_iu[i, u]) if h <= D) == E_iud[i, u, d] )
        @constraint(model, [i, u, d], sum(v_var[i, u, d, h, r] for r = 1:R, h = 1:(d - 1)) == 0 )
        @constraint(model, [i, u, d], sum(v_var[i, u, d, h, r] for r = 1:R, h = (d + B_iu[i, u] + 1):D if h <= D) == 0 )
    else
        @constraint(model, [i, u, d], sum(v_var[i, u, d, h, r] for r = 1:R, h = d:(d + B_iu[i, u]) if h <= D) + sum(v_var[i, u, d, h, r] for r = 1:R, h = 1:(d + B_iu[i, u])%7 if h < d) == E_iud[i, u, d] )
        @constraint(model, [i, u, d], sum(v_var[i, u, d, h, r] for r = 1:R, h = ((d + B_iu[i, u])%7) + 1:(d - 1)) == 0 )
    end
end

#Connecting D_iuD to alpha
@constraint(model, [i = 1:I, u = 1:U], sum(alpha_var[i, u, d] for d = 1:D) >= D_iuD[i, u] )

#Connecting alpha to x
@constraint(model, [i = 1:I, u = 1:U, d = 1:D], sum(x_var[i, u, s, d] for s = 1:S) >= alpha_var[i, u, d] )

#The number of internal interpretations must equal number of assigned slots
@constraint(model, sum(w_var[i, u, d, r, m] for i = 1:I, u = 1:U, d = 1:D, r = 1:R, m = 1) == sum(x_var[i, u, s, d] for i = 1:I, u = 1:U, s = 1:S, d = 1:D) )

#The number of assigned blocks must equal the demand
@constraint(model, [i = 1:I, u = 1:U], sum(x_var[i, u, s, d] for s = 1:S, d = 1:D) == 1 * D_iuW[i, u] )

#The number of assigned blocks must be less than the available capacity at the scanners
@constraint(model, [s = 1:S, d = 1:D], sum(x_var[i, u, s, d] for i = 1:I, u = 1:U) <= N_sd[s, d] - S_sd[s, d] )

#Connecting the gamma variables to the demand of radiologists at M&D
@constraint(model, [i = 1:I, d = 1:D], sum(gamma_var[i, d, r] for r = 1:R) == A_id[i, d] )

#Connecting the beta variables to the demand of radiologists for monitoring the scanners
@constraint(model, [s = 1:S, d = 1:D], sum(beta_var[s, d, r] for r = 1:R) == L_sd[s, d] )

#Maximum share of the week that can be devoted to monitoring a scanner
@constraint(model, [r = 1:R], sum(T_sd_Scan[s, d] * beta_var[s, d, r] for s = 1:S, d = 1:D) <= 0.5 * Q_w )

#Constraints that ensure that only certain patient groups can be scanned by certain scanners
@constraint(model, [i = 1:I, s = 1:S], sum(x_var[i, u, s, d] for u = 1:U, d = 1:D) <= sum(N_sd[s, d] for d = 1:D) * L_isA[i, s] )

#Symmetry breaking constraints
#@constraint(model, [r = 1:(R - 1)], sum(w_var[i, u, d, r, m] for i = 1:I, u = 1:U, d = 1:D, m = 1:M) >= sum(w_var[i, u, d, r, m] for i = 1:I, u = 1:U, d = 1:D, r = (r + 1), m = 1:M) )
