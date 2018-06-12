def calculator():
    try:
        nameTS = input("Please enter the name of TS:")
        fileTS = open(nameTS,"r")
        sumTS = 0
        countTS = 0
        for i in fileTS:
            countTS += 1
            sumTS += int(i)
        print("The Average time of TS is",sumTS/countTS)
        nameTJ = input("Please enter the name of TJ:")
        fileTJ = open(nameTJ,"r")
        sumTJ = 0
        countTJ = 0
        for i in fileTJ:
            countTJ += 1
            sumTJ += int(i)
        print("The Average time of TJ is",sumTJ/countTJ)
    except:
        print("Error")



calculator()
