
path="/Users/haraldaarskog/GoogleDrive/Fordypningsprosjekt/Kode/output/output_TEST.txt"
deleteContentOfFile(path)

println()
println("****** Variable: x[i,u,s,d] ******")
writeToFile(path,"\n\n"*"****** Variable: x[i,u,s,d] ******\n")
for s=1:S
    println()
    println("Scanner: ",s)
    for d=1:D
        println()
        println("Day: ",d)
        println("__________________")
        for u=1:U
            for i=1:I
                if value(x[i,u,s,d]) != 0
                    println("x[",i,",",u,",",s,",",d,"] = ", value(x[i,u,s,d]))
                    writeToFile(path,"x["*repr(i)*","*repr(u)*","*repr(s)*","*repr(d)*"] = " *repr(value(x[i,u,s,d]))*"\n")

                end
            end
        end
    end
end


println()
println("Radiologist schedules:")
for r=1:R
    println()
    println("Radiologist:",r)
    for d=1:D
        println("Day:", d)
        if value(open_task_dr[d,r])!=0
            println("open_task[",d,",",r,"] = ", value(open_task_dr[d,r]))
        end
        for s=1:S
            if value(beta[s,d,r])!=0
                println("beta[",s,",",d,",",r,"] = ", value(beta[s,d,r]))
            end
        end
            for i=1:I
                if value(gamma[i,d,r])!=0
                        println("gamma[",i,",",d,",",r,"] = ", value(gamma[i,d,r]))
                end
                for u=1:U
                    for m=1:M
                        if value(w[i,u,d,r,m]) != 0
                            println("w[",i,",",u,",",d,",",r,",",m,"] = ", value(w[i,u,d,r,m]))
                        end
                    end
                end
            end

    end
end


#println()
#println("****** Variable: w[i,u,d,r,m] ******")
writeToFile(path,"\n\n"*"****** Variable: w[i,u,d,r,m] ******\n")
for d=1:D
    #println()
    #println("Day: ",d)
    #println("__________________")
    for r=1:R
        #println("Patient group: ", i)
        for i=1:I
            for u=1:U
                #println("Radioligst: ",r)
                for m=1:M
                    if value(w[i,u,d,r,m]) != 0
                        #println("w[",i,",",u,",",d,",",r,",",m,"] = ", value(w[i,u,d,r,m]))
                        writeToFile(path,"w["*repr(i)*","*repr(u)*","*repr(d)*","*repr(r)*","*repr(m)*"] = " *repr(value(w[i,u,d,r,m]))*"\n")
                    end
                end
            end
        end
    end
end
println()
println("****** Variable: u[i,u,d,h,r] ******")
writeToFile(path,"\n\n"*"****** Variable: u[i,u,d,h,r] ******\n")

for i=1:I
    for u=1:U
        for d=1:D
            for h=1:H
                for r=1:R
                    if value(u_i[i,u,d,h,r]) != 0
                        println("u[",i,",",u,",",d,",",h,",",r,"] = ", value(u_i[i,u,d,h,r]))
                        writeToFile(path,"u["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(u_i[i,u,d,h,r]))*"\n")

                    end
                end
            end
        end
    end
end

println()
println("****** Variable: v[i,u,d,h,r] ******")
writeToFile(path,"\n\n"*"****** Variable: v[i,u,d,h,r] ******\n")
for i=1:I
    for u=1:U
        for d=1:D
            for h=1:H
                for r=1:R
                    if value(v[i,u,d,h,r]) != 0
                        println("v[",i,",",u,",",d,",",h,",",r,"] = ", value(v[i,u,d,h,r]))
                        writeToFile(path,"v["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(v[i,u,d,h,r]))*"\n")
                    end
                end
            end
        end
    end
end

println()
println("****** Variable: p,q[d,r] ******")
writeToFile(path,"\n\n"*"****** Variable: p,q[d,r] *****\n")
for d =1:D
    println()
    println("Day: ",d)
    println("__________________")
    for r=1:R
        if value(p[d,r]) != 0
            println("p[",d,",",r,"] = ",value(p[d,r]))
            writeToFile(path,"p["*repr(d)*","*repr(r)*"] = " *repr(value(p[d,r]))*"\n")

        end
        if value(q[d,r]) != 0
            println("q[",d,",",r,"] = ",value(q[d,r]))
            writeToFile(path,"q["*repr(d)*","*repr(r)*"] = "*repr(value(q[d,r]))*"\n")
        end
    end
end

println()
println("****** Variable: alpha[i,u,d] ******")
writeToFile(path, "\n\n"*"****** Variable: alpha[i,u,d] ******\n")
for i=1:I
    for u=1:U
        for d=1:D
            if value(alpha[i,u,d]) != 0
                println("alpha[",i,",",u,",",d,"] = ", value(alpha[i,u,d]))
                writeToFile(path,"alpha["*repr(i)*","*repr(u)*","*repr(d)*"] = "*repr(value(alpha[i,u,d]))*"\n")
            end
        end
    end
end

println()
println("****** Variable: beta[s,d,r] ******")
writeToFile(path, "\n\n"*"****** Variable: beta[s,d,r] ******")
for s=1:S
    for d=1:D
        for r=1:R
            if value(beta[s,d,r]) != 0
                println("beta[",s,",",d,",",r,"] = ", value(beta[s,d,r]))
                writeToFile(path,"beta["*repr(s)*","*repr(d)*","*repr(r)*"] = "*repr(value(beta[s,d,r]))*"\n")

            end
        end
    end
end

println()
println("****** Variable: gamma[i,d,r] ******")
writeToFile(path,"\n\n"*"****** Variable: gamma[i,d,r] ******\n")
for i=1:I
    for d=1:D
        for r=1:R
            if value(gamma[i,d,r]) != 0
                println("gamma[",i,",",d,",",r,"] = ", value(gamma[i,d,r]))
                writeToFile(path,"gamma["*repr(i)*","*repr(d)*","*repr(r)*"] = "*repr(value(gamma[i,d,r]))*"\n")

            end
        end
    end
end
