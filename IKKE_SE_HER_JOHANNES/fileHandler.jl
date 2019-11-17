#this function inputs multiple string arrays and outputs a matrix of int and float
function arrayToMatrix(array)
    h=[]
    counter=0
    for element in array
        counter=0
        g=split(element)
        b=[]
        #converting strings to int or float
        for item in g
            counter+=1
            if occursin(".",item)
                push!(b,parse(Float64,item))
                continue
            end
            push!(b,parse(Int64,item))
        end
        push!(h,b)
    end
    #creating an empty matrix and thereafter adding all the arrays in the matrix
    m = Matrix{Any}(nothing, 0, counter)
    for element in h
        m=[m;element']
    end
    return m
end

#this function inputs a textfile and outputs a dictionary
function readFromFile(text)
    a=readlines(text)
    dict=Dict([])
    key=""
    array=[]
    flag=false
    for element in a
        if flag==true && occursin(";", element)
            ja=arrayToMatrix(array)
            push!(dict, key=>ja)
            array=[]
            flag=false
            continue
        end
        if flag==true
            push!(array, element)
        end
        if occursin("#",element)
            key=element[2:end]
            flag=true
        end
    end
    return dict
end


function deleteContentOfFile(path)
    open(path, "w") do f
        nothing
    end
end

function writeToFile(path, content)
    open(path, "a") do f
        write(f, content)
    end
end
