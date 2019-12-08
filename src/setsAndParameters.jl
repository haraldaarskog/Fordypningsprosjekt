include("fileHandler.jl")

#Set sizes

#The number of patient groups
I = readFromFile(input_file)["I"][1]

#The number of urgency classes
U = readFromFile(input_file)["U"][1]

#The number of scanners
S = readFromFile(input_file)["S"][1]

#The number of days in planning horizon
D = H = readFromFile(input_file)["D"][1]

#The number of radiologists
R = readFromFile(input_file)["R"][1]

#The number of interpretation tasks
M = readFromFile(input_file)["M"][1]


#Parameters

#Radiologist specializations
C_ir = readFromFile(input_file)["C_ir"]

#Which patient groups that can be scanned by scanner s
L_isA = readFromFile(input_file)["L_isA"]

#Interpretation times
T_im = readFromFile(input_file)["T_im"]

#Average unassigned hours for each radiologist
G = readFromFile(input_file)["G"][1]

#Number of slots available at the scanners
N_sd = readFromFile(input_file)["N_sd"]

#Number of studies at the scanners
S_sd = readFromFile(input_file)["S_sd"]

#Weekly demand
D_iuW = readFromFile(input_file)["D_iuW"]

#Radiologist capacity
K_dr = readFromFile(input_file)["K_dr"]

#Minimum number of blocks for each patient group
D_iuD = readFromFile(input_file)["D_iuD"]

#Maximum time from scan to interpretation
B_iu = readFromFile(input_file)["B_iu"]

#Number of radiologists needed each day at the scanners
L_sd = readFromFile(input_file)["L_sd"]

#A parameter denoting when the M&D takes place for a patient group
A_id = readFromFile(input_file)["A_id"]

#Maximum allowed deviation in working hours
Q_d = readFromFile(input_file)["Q_d"][1]

#Number of weekly hours each radiologist works
Q_w = readFromFile(input_file)["Q_w"][1]

#Number of interpretation tasks from external patients throughout the week
E_iu1 =readFromFile(input_file)["E_iu1"]
E_iu2 = readFromFile(input_file)["E_iu2"]
E_iu3 = readFromFile(input_file)["E_iu3"]
E_iu4 = readFromFile(input_file)["E_iu4"]
E_iu5 = readFromFile(input_file)["E_iu5"]
E_iud = cat(dims=3,E_iu1,E_iu2,E_iu3, E_iu4, E_iu5)

#Time used for M&D-tasks
T_i_MD = readFromFile(input_file)["T_i_MD"]

#Monitoring time at the scanner
T_sd_Scan = readFromFile(input_file)["T_sd_Scan"]
