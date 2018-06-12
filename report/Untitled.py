def a():
    name = input("Please enter the name:")
    file = open(name,"r")
    new= open("new.txt","w")
    for i in file.readlines():
        a = int(i) + 2000000
        new.write(str(a))
        new.write("\n")
    new.close()
    file.close()
        
