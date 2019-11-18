include("fileHandler.jl")

fileName="/Users/hara/Downloads/Fordypningsprosjekt-master/IKKE_SE_HER_JOHANNES/BP_parameters.txt"
I=readFromFile(fileName)["I"][1]
U=readFromFile(fileName)["U"][1]
S=readFromFile(fileName)["S"][1]
D=H=readFromFile(fileName)["D"][1]
R=readFromFile(fileName)["R"][1]
M=readFromFile(fileName)["M"][1]


Preferanse_ir=readFromFile(fileName)["Preferanse_ir"]
L_isA=readFromFile(fileName)["L_isA"]
T_im=readFromFile(fileName)["T_im"]
G=readFromFile(fileName)["G"][1]
N_sd=readFromFile(fileName)["N_sd"]
S_sd=readFromFile(fileName)["S_sd"]
D_iuW=readFromFile(fileName)["D_iuW"]
D_iuW_NY=D_iuW/sum(D_iuW)
K_dr=readFromFile(fileName)["K_dr"]
D_iuD=readFromFile(fileName)["D_iuD"]
B_iu=readFromFile(fileName)["B_iu"]
L_sd=readFromFile(fileName)["L_sd"]
A_id=readFromFile(fileName)["A_id"]
Q_d=readFromFile(fileName)["Q_d"][1]
Q_w=readFromFile(fileName)["Q_w"][1]
Percentage=readFromFile(fileName)["Percentage"][1]
E_iu1=readFromFile(fileName)["E_iu1"]
E_iu2=readFromFile(fileName)["E_iu2"]
E_iu3=readFromFile(fileName)["E_iu3"]
E_iu4=readFromFile(fileName)["E_iu4"]
E_iu5=readFromFile(fileName)["E_iu5"]
E_iud=cat(dims=3,E_iu1,E_iu2,E_iu3, E_iu4, E_iu5)
MDT_interpretation_time_i=readFromFile(fileName)["MDT_interpretation_time_i"]
scanning_time_sd=readFromFile(fileName)["scanning_time_sd"]
