deleteContentOfFile(output_file)

function printOutput(boo)

    if boo==true

        println()
        println("****** Number of open radiologist hours ******")
        for d=1:D
            sum_t=0
            for r=1:R
                sum_t+=value(t_var[d,r])
            end
            println("Sum of t on day ", d," = ", sum_t)
        end
    end




    if boo==true
        println()
        println("****** Variable: y_var[d] ******")
    end
    for d=1:D
        if boo==true
            println("y[",d,"] = ", value(y_var[d]))
        end
    end



    if boo==true
        println()
        println("****** Variable: x_var[i,u,s,d] ******")
        writeToFile(output_file,"\n\n"*"****** Variable: x_var[i,u,s,d] ******\n")
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
                    if value(x_var[i,u,s,d]) != 0
                        if boo==true
                            println("x_var[",i,",",u,",",s,",",d,"] = ", value(x_var[i,u,s,d]))
                        end
                        writeToFile(output_file,"x_var["*repr(i)*","*repr(u)*","*repr(s)*","*repr(d)*"] = " *repr(value(x_var[i,u,s,d]))*"\n")

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
            if value(t_var[d,r])!=0
                if boo==true
                    println("t_var[",d,",",r,"] = ", value(t_var[d,r]))
                end
            end
            for s=1:S
                if value(beta_var[s,d,r])!=0
                    if boo==true
                        println("beta_var[",s,",",d,",",r,"] = ", value(beta_var[s,d,r]))
                    end
                end
            end
                for i=1:I
                    if value(gamma_var[i,d,r])!=0
                        if boo==true
                            println("gamma_var[",i,",",d,",",r,"] = ", value(gamma_var[i,d,r]))
                        end
                    end
                    for u=1:U
                        for m=1:M
                            if value(w_var[i,u,d,r,m]) != 0
                                if boo==true
                                    println("w_var[",i,",",u,",",d,",",r,",",m,"] = ", value(w_var[i,u,d,r,m]))
                                end
                            end
                        end
                    end
                end

        end
    end


    #println()
    #println("****** Variable: w_var[i,u,d,r,m] ******")
    writeToFile(output_file,"\n\n"*"****** Variable: w_var[i,u,d,r,m] ******\n")
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
                        if value(w_var[i,u,d,r,m]) != 0
                            #println("w[",i,",",u,",",d,",",r,",",m,"] = ", value(w_var[i,u,d,r,m]))
                            writeToFile(output_file,"w_var["*repr(i)*","*repr(u)*","*repr(d)*","*repr(r)*","*repr(m)*"] = " *repr(value(w_var[i,u,d,r,m]))*"\n")
                        end
                    end
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: u_var[i,u,d,h,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: u_var[i,u,d,h,r] ******\n")

    for i=1:I
        for u=1:U
            for d=1:D
                for h=1:H
                    for r=1:R
                        if value(u_var[i,u,d,h,r]) != 0
                            if boo==true
                                println("u[",i,",",u,",",d,",",h,",",r,"] = ", value(u_var[i,u,d,h,r]))
                            end
                            writeToFile(output_file,"u_var["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(u_var[i,u,d,h,r]))*"\n")

                        end
                    end
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: v_var[i,u,d,h,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: v_var[i,u,d,h,r] ******\n")
    for i=1:I
        for u=1:U
            for d=1:D
                for h=1:H
                    for r=1:R
                        if value(v_var[i,u,d,h,r]) != 0
                            if boo==true
                                println("v_var[",i,",",u,",",d,",",h,",",r,"] = ", value(v_var[i,u,d,h,r]))
                            end
                            writeToFile(output_file,"v_var["*repr(i)*","*repr(u)*","*repr(d)*","*repr(h)*","*repr(r)*"] = " *repr(value(v_var[i,u,d,h,r]))*"\n")
                        end
                    end
                end
            end
        end
    end
    if boo==true
        println()
        println("****** Variable: p,q_var[d,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: p,q_var[d,r] *****\n")
    for d =1:D
            if boo==true
            println()
            println("Day: ",d)
            println("__________________")
        end
        for r=1:R
            if value(p_var[d,r]) != 0
                if boo==true
                    println("p_var[",d,",",r,"] = ",value(p_var[d,r]))
                end
                writeToFile(output_file,"p["*repr(d)*","*repr(r)*"] = " *repr(value(p_var[d,r]))*"\n")

            end
            if value(q_var[d,r]) != 0
                if boo==true
                    println("q_var[",d,",",r,"] = ",value(q_var[d,r]))
                end
                writeToFile(output_file,"q_var["*repr(d)*","*repr(r)*"] = "*repr(value(q_var[d,r]))*"\n")
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: alpha_var[i,u,d] ******")
    end
    writeToFile(output_file, "\n\n"*"****** Variable: alpha_var[i,u,d] ******\n")
    for i=1:I
        for u=1:U
            for d=1:D
                if value(alpha_var[i,u,d]) != 0
                    if boo==true
                        println("alpha_var[",i,",",u,",",d,"] = ", value(alpha_var[i,u,d]))
                    end
                    writeToFile(output_file,"alpha_var["*repr(i)*","*repr(u)*","*repr(d)*"] = "*repr(value(alpha_var[i,u,d]))*"\n")
                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: beta_var[s,d,r] ******")
    end
    writeToFile(output_file, "\n\n"*"****** Variable: beta_var[s,d,r] ******")
    for s=1:S
        for d=1:D
            for r=1:R
                if value(beta_var[s,d,r]) != 0
                    if boo==true
                        println("beta_var[",s,",",d,",",r,"] = ", value(beta_var[s,d,r]))
                    end
                    writeToFile(output_file,"beta_var["*repr(s)*","*repr(d)*","*repr(r)*"] = "*repr(value(beta_var[s,d,r]))*"\n")

                end
            end
        end
    end

    if boo==true
        println()
        println("****** Variable: gamma_var[i,d,r] ******")
    end
    writeToFile(output_file,"\n\n"*"****** Variable: gamma_var[i,d,r] ******\n")
    for i=1:I
        for d=1:D
            for r=1:R
                if value(gamma_var[i,d,r]) != 0
                    if boo==true
                        println("gamma_var[",i,",",d,",",r,"] = ", value(gamma_var[i,d,r]))
                    end
                    writeToFile(output_file,"gamma_var["*repr(i)*","*repr(d)*","*repr(r)*"] = "*repr(value(gamma_var[i,d,r]))*"\n")

                end
            end
        end
    end
end
