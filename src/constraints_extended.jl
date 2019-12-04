#Initial formulation
@constraint(model, [d = 1:D, r = 1:R], q_var[d, r] + p_var[d, r] <= y_var[d] )

#ALTERNATIV 1
#@constraint(model, [d = 1:D, r = 1:R], t_var[d, r] <= y_var[d] )

#ALTERNATIV 2
#@constraint(model, [d = 1:D, r = 1:R], p_var[d, r] + q_var[d, r] <= z_var[r] )


#Constraints capturing the deviation from target value G
@constraint(model, [d = 1:D, r = 1:R], q_var[d, r] - p_var[d, r] + t_var[d, r] == G )

#minimum number of hours a radiologist can work per day
@constraint(model, [d = 1:D, r = 1:R], t_var[d, r] + sum(T_im[i, m] * a_var[i, u, h, d, r, m] for i = 1:I, u = 1:U, h = 1:H, m = 1:M) + sum(T_sd_Scan[s, d] * beta_var[s, d, r] for s = 1:S) + sum(T_i_MD[i]*gamma_var[i, d, r] for i = 1:I) >= K_dr[d, r] - Q_d )

#maximum number of hours a radiologist can work per day
@constraint(model, [d = 1:D, r = 1:R], t_var[d, r] + sum(T_im[i, m] * a_var[i, u, h, d, r, m] for i = 1:I, u = 1:U, h = 1:H, m = 1:M) + sum(T_sd_Scan[s, d] * beta_var[s, d, r] for s = 1:S) + sum(T_i_MD[i] * gamma_var[i, d, r] for i = 1:I) <= K_dr[d, r]+ Q_d )

#The total number of working hours for each radiologist must equal Q_w
@constraint(model, [r = 1:R], sum(t_var[d, r] for d = 1:D) + sum(T_im[i, m]*a_var[i, u, d, h, r, m] for i = 1:I, u = 1:U, d = 1:D, h = 1:H, m in [1,2]) + sum(T_sd_Scan[s, d] * beta_var[s, d, r] for s = 1:S, d = 1:D) + sum(T_i_MD[i] * gamma_var[i, d, r] for i = 1:I, d = 1:D) == Q_w )


#Making sure that internal interpretations can be done the current and the following week
for i = 1:I, u = 1:U, d = 1:D
    if d+B_iu[i,u] <= 7
        @constraint(model, [i, u, d], sum(x_var[i, u, s, d] for s = 1:S) - sum(a_var[i, u, d, h, r, m] for r = 1:R, m = 1, h = d:(d + B_iu[i, u]) if h <= D) == 0 )
    else
        @constraint(model, [i, u, d], sum(x_var[i, u, s, d] for s = 1:S) - sum(a_var[i, u, d, h, r, m] for r = 1:R, m = 1, h = d:(d + B_iu[i,u]) if h <= D) - sum(a_var[i, u, d, h, r, m] for r = 1:R, m = 1, h = 1:(d+B_iu[i,u])%7 if h < d) == 0 )
    end
end

#Making sure that external interpretations can be done the current and the following week
for i = 1:I, u = 1:U, d = 1:D
    if d + B_iu[i, u] <= 7
        @constraint(model, [i, u, d], sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h = d:(d + B_iu[i,u]) if h <= D) == E_iud[i, u, d] )
        @constraint(model, [i, u, d], sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h = 1:d-1) == 0 ) #Setter starten av uka =0
        @constraint(model, [i, u, d], sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h = (d + B_iu[i,u] + 1:D) if h <= D) == 0 )  #20
    else
        @constraint(model, [i, u, d], sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h = d:(d + B_iu[i, u]) if h <= D) + sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h = 1:(d+B_iu[i,u])%7 if h < d) == E_iud[i, u, d] )
        @constraint(model, [i, u, d], sum(a_var[i, u, d, h, r, m] for m = 2, r = 1:R, h=((d + B_iu[i, u])%7) + 1:(d - 1)) == 0 )    #setter midten av uka =0
    end
end

#Connecting D_iuD to alpha
@constraint(model, [i = 1:I, u = 1:U], sum(alpha_var[i, u, d] for d = 1:D) >= D_iuD[i, u] )

#Connecting alpha to x
@constraint(model, [i = 1:I, u = 1:U, d = 1:D], sum(x_var[i, u, s, d] for s = 1:S) >= alpha_var[i, u, d] )

#The number of internal interpretations must equal number of assigned slots
@constraint(model, sum(a_var[i, u, d, h, r, m] for h = 1:H, i = 1:I, u = 1:U, d = 1:D, r = 1:R, m = 1) == sum(x_var[i, u, s, d] for i = 1:I, u = 1:U, s = 1:S, d = 1:D) )

#The number of assigned blocks must equal the demand
@constraint(model, [i = 1:I, u = 1:U], sum(x_var[i, u, s, d] for s = 1:S, d = 1:D) == 5 * D_iuW[i, u] )

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


#EXTENSIONS - NOT INCLUDED IN THE INITIAL MODEL

#Constraint that ensures the radiologists get tasks connected to their specialization
#@constraint(m, [i=1:I, r=1:R], sum(a_var[i,u,d,h,r,m]+ gamma_var[i,d,r] for u=1:U, d=1:D, h=1:H, m=1:M) <=sum(K_dr[d,r] for d=1:D)*C_ir[i,r])


#****************************************************************************************
