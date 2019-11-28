
#Constraints connecting p, q, G and y
#Bjørn
@constraint(m,[d=1:D, r=1:R], q[d,r]-p[d,r] + t[d,r]==G)
@constraint(m,[d=1:D, r=1:R], q[d,r]+p[d,r]<=y[d])

#Ikke-bjørn
#@constraint(m,[d=1:D,r=1:R], t[d,r] <= y[d])
#Sum-Ikke-Bjørn
#@constraint(m,[d=1:D], sum(t[d,r] for r=1:R) <= y[d])



#Bjørn NEDRE
#@constraint(m,[d=1:D, r=1:R], q[d,r]+p[d,r]<=y[d])
#@constraint(m,[d=1:D, r=1:R], q[d,r]+p[d,r]>=a[d])

#AlternativJohannes
#compu gjort med - mellom. Like mye over som under. Gir mening
#@constraint(m,[d=1:D], sum(q[d,r]-p[d,r] for r=1:R)<=y[d])
#@constraint(m,[d=1:D], a[d] <= sum(q[d,r]-p[d,r] for r=1:R))

#minimum number of hours a radiologist can work per day
@constraint(m,[d=1:D,r=1:R], t[d,r] + sum(T_im[i,m]*extended[i,u,h,d,r,m]  for i=1:I,u=1:U, h=1:H, m =1:M)+sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I)>=K_dr[d,r]-Q_d)

#maximum number of hours a radiologist can work per day
@constraint(m,[d=1:D,r=1:R], t[d,r] + sum(T_im[i,m]*extended[i,u,h,d,r,m]  for i=1:I,u=1:U, h=1:H, m=1:M)+sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I)<=K_dr[d,r]+Q_d)

#The total number of working hours for each radiologist must equal Q_w
@constraint(m, [r=1:R], sum(t[d,r] for d=1:D)+sum(T_im[i,m]*extended[i,u,d,h,r,m] for i=1:I, u=1:U, d=1:D, h=1:H, m in [1,2]) + sum(scanning_time_sd[s,d]*beta[s,d,r] for s=1:S, d=1:D)+sum(MDT_interpretation_time_i[i]*gamma[i,d,r] for i=1:I, d=1:D)==Q_w)


#Making sure that internal interpretations can be done the current and the following week
for i=1:I, u=1:U, d=1:D
    if d+B_iu[i,u] <= 7
        @constraint(m, [i,u,d], sum(x[i,u,s,d] for s=1:S) - sum(extended[i,u,d,h,r,m] for r=1:R,m=1,h=d:d+B_iu[i,u] if h <= D) == 0)
    else
        @constraint(m, [i,u,d], sum(x[i,u,s,d] for s=1:S) - sum(extended[i,u,d,h,r,m] for r=1:R,m=1,h=d:d+B_iu[i,u] if h <= D) - sum(extended[i,u,d,h,r,m] for r=1:R,m=1, h=1:(d+B_iu[i,u])%7 if h<d) == 0)
    end
end

#Making sure that external interpretations can be done the current and the following week
for i=1:I, u=1:U, d=1:D
    if d+B_iu[i,u] <= 7
        @constraint(m, [i,u,d], sum(extended[i,u,d,h,r,m] for m=2, r=1:R, h=d:d+B_iu[i,u] if h<=D) == E_iud[i,u,d])
        @constraint(m, [i,u,d], sum(extended[i,u,d,h,r,m] for m=2, r=1:R, h=1:d-1) == 0) #Setter starten av uka =0
        @constraint(m, [i,u,d], sum(extended[i,u,d,h,r,m] for m=2, r=1:R, h=(d+B_iu[i,u]+1:D) if h <= D)==0)  #20
    else
        @constraint(m, [i,u,d], sum(extended[i,u,d,h,r,m] for m=2, r=1:R, h=d:d+B_iu[i,u] if h<=D) + sum(extended[i,u,d,h,r,m] for m=2, r=1:R, h=1:(d+B_iu[i,u])%7 if h<d) == E_iud[i,u,d])
        @constraint(m, [i,u,d], sum(extended[i,u,d,h,r,m] for m=2, r=1:R,h=((d+B_iu[i,u])%7) + 1:(d-1)) == 0)    #setter midten av uka =0
    end
end

#Connecting D_iuD to alpha
@constraint(m,[i=1:I,u=1:U], sum(alpha[i,u,d] for d=1:D)>=D_iuD[i,u])

#Connecting alpha to x
@constraint(m,[i=1:I,u=1:U, d=1:D], sum(x[i,u,s,d] for s=1:S)>=alpha[i,u,d])

#The number of internal interpretations must equal number of assigned slots
#We have to include this constraint, otherwise the w can be set to meet G_dr
@constraint(m, sum(extended[i,u,d,h,r,m] for h=1:H, i=1:I, u=1:U, d=1:D, r=1:R, m=1)==sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))

#Constraints that deals with demand. Either comment out the two first ones, or the third one.
#@constraint(m, [i=1:I, u=1:U], sum(x[i,u,s,d] for s=1:S, d=1:D)<=(D_iuW_NY[i,u]+Percentage)*sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))
#@constraint(m, [i=1:I, u=1:U], sum(x[i,u,s,d] for s=1:S, d=1:D)>=(D_iuW_NY[i,u]-Percentage)*sum(x[i,u,s,d] for i=1:I, u=1:U, s=1:S, d=1:D))
@constraint(m,[i=1:I,u=1:U], sum(x[i,u,s,d] for s=1:S,d=1:D)==1*D_iuW[i,u])

#All the available slots has to be filled up
@constraint(m,[s=1:S,d=1:D], sum(x[i,u,s,d] for i=1:I,u=1:U)<=N_sd[s,d]-S_sd[s,d])

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
#@constraint(m, [i=1:I, r=1:R], sum(extended[i,u,d,h,r,m]+ gamma[i,d,r] for u=1:U, d=1:D, h=1:H, m=1:M) <=1000*Preferanse_ir[i,r])

#@constraint(m, [r=1:R-1], sum(beta[s,d,r] for s=1:S, d=1:D)<=sum(beta[s,d,r+1] for s=1:S, d=1:D))
#@constraint(m, [r=1:R-1], sum(gamma[i,d,r] for i=1:I, d=1:D)>=sum(gamma[i,d,r+1] for i=1:I, d=1:D))


#****************************************************************************************
