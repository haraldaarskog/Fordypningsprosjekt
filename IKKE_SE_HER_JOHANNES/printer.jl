deleteContentOfFile(output_file)

function printOutput(boo)
    if boo==true
        println()
        println("****** Variable: y[d] ******")
    end
    for d=1:D
        if boo==true
            println("y[",d,"] = ", value(y[d]))
        end
    end



    if boo==true
        println()
        println("****** Variable: x[i,u,s,d] ******")
        writeToFile(output_file,"\n\n"*"****** Variable: x[i,u,s,d] ******\n")
    end
    for s=1:S
        if boo==true
            println()
            println("Scanner: ",s)
        end
        for d=1:D
            if boo==true
                println()
                println("Day: ",d)
                println("__________________")
            end
            for u=1:U
                for i=1:I
                    if value(x[i,u,s,d]) != 0
                        if boo==true
                            println("x[",i,",",u,",",s,",",d,"] = ", value(x[i,u,s,d]))
                        end
                        writeToFile(output_file,"x["*repr(i)*","*repr(u)*","*repr(s)*","*repr(d)*"] = " *repr(value(x[i,u,s,d]))*"\n")

                    end
                end
            end
        end
    end

    if boo==true
        println()
        println("Radiologist schedules:")
    end
    for r=1:R
        if boo==true
            println()
            println("Radiologist:",r)
        end

        for d=1:D
            if boo==true
                println("Day:", d)
            end
            if value(t[d,r])!=0
                if boo==true
                    println("t[",d,",",r,"] = ", value(t[d,r]))
                end
            end
            for s=1:S
                if value(beta[s,d,r])!=0
                    if boo==true
                        println("beta[",s,",",d,",",r,"] = ", value(beta[s,d,r]))
                    end
                end
            end
                for i=1:I
                    if value(gamma[i,d,r])!=0
                        if boo==true
                            println("gamma[",i,",",d,",",r,"] = ", value(gamma[i,d,r]))
                        end
                    end
                    for u=1:U
                        for m=1:M
                            if value(w[i,u,d,r,m]) != 0
                                if boo==true
                                    println("w[",i,",",u,",",d,",",r,",",m,"] = ", value(w[i,u,d,r,m]))
                                end
                            end
                        end
                    end
                end

        end
    end


    #println()
    #println("****** Variable: w[i,u,d,r,m] ******")
    writeToFile(output_file,"\n\n"*"****** Variable: w[i,u,d,r,m] ******\n")
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
                            writeToFile(output_file,"w["*repr(i)*","*repr(u)*","*repr(d)*","*repr(r)*","*repr(m)*"] = " *repr(value(w[i,u,d,r,m]))*"\n")
                        end
                    end
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: u[i,u,d,h,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: u[i,u,d,h,r] ******\n")

    for i=1:I
        for u=1:U
            for d=1:D
                for h=1:H
                    for r=1:R
                        if value(u_i[i,u,d,h,r]) != 0
                            if boo==true
                                println("u[",i,",",u,",",d,",",h,",",r,"] = ", value(u_i[i,u,d,h,r]))
                            end
                            writeToFile(output_file,"u["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(u_i[i,u,d,h,r]))*"\n")

                        end
                    end
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: v[i,u,d,h,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: v[i,u,d,h,r] ******\n")
    for i=1:I
        for u=1:U
            for d=1:D
                for h=1:H
                    for r=1:R
                        if value(v[i,u,d,h,r]) != 0
                            if boo==true
                                println("v[",i,",",u,",",d,",",h,",",r,"] = ", value(v[i,u,d,h,r]))
                            end
                            writeToFile(output_file,"v["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(v[i,u,d,h,r]))*"\n")
                        end
                    end
                end
            end
        end
    end
    if boo==true
        println()
        println("****** Variable: p,q[d,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: p,q[d,r] *****\n")
    for d =1:D
            if boo==true
            println()
            println("Day: ",d)
            println("__________________")
        end
        for r=1:R
            if value(p[d,r]) != 0
                if boo==true
                    println("p[",d,",",r,"] = ",value(p[d,r]))
                end
                writeToFile(output_file,"p["*repr(d)*","*repr(r)*"] = " *repr(value(p[d,r]))*"\n")

            end
            if value(q[d,r]) != 0
                if boo==true
                    println("q[",d,",",r,"] = ",value(q[d,r]))
                end
                writeToFile(output_file,"q["*repr(d)*","*repr(r)*"] = "*repr(value(q[d,r]))*"\n")
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: alpha[i,u,d] ******")
    end
    writeToFile(output_file, "\n\n"*"****** Variable: alpha[i,u,d] ******\n")
    for i=1:I
        for u=1:U
            for d=1:D
                if value(alpha[i,u,d]) != 0
                    if boo==true
                        println("alpha[",i,",",u,",",d,"] = ", value(alpha[i,u,d]))
                    end
                    writeToFile(output_file,"alpha["*repr(i)*","*repr(u)*","*repr(d)*"] = "*repr(value(alpha[i,u,d]))*"\n")
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: beta[s,d,r] ******")
    end
    writeToFile(output_file, "\n\n"*"****** Variable: beta[s,d,r] ******")
    for s=1:S
        for d=1:D
            for r=1:R
                if value(beta[s,d,r]) != 0
                    if boo==true
                        println("beta[",s,",",d,",",r,"] = ", value(beta[s,d,r]))
                    end
                    writeToFile(output_file,"beta["*repr(s)*","*repr(d)*","*repr(r)*"] = "*repr(value(beta[s,d,r]))*"\n")

                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: gamma[i,d,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: gamma[i,d,r] ******\n")
    for i=1:I
        for d=1:D
            for r=1:R
                if value(gamma[i,d,r]) != 0
                    if boo==true
                        println("gamma[",i,",",d,",",r,"] = ", value(gamma[i,d,r]))
                    end
                    writeToFile(output_file,"gamma["*repr(i)*","*repr(d)*","*repr(r)*"] = "*repr(value(gamma[i,d,r]))*"\n")

                end
            end
        end
    end
end
