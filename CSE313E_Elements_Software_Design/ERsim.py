#  File: ERsim.py
#  Description:Takes sim file and excutes instructions with implied priority for certain patients when treating 
#  Student's Name:Bernardo Perez Fonseca
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number:51320 
#
#  Date Created:10/7/16
#  Date Last Modified:10/7/16
class Queue:

    def __init__(self):
        self.items = []

    def enqueue(self,item):
        self.items.insert(0,item)

    def dequeue(self):
        return self.items.pop(-1)

    def isEmpty(self):
        return self.items == []

    def size(self):
        return len(self.items)

    def peek(self):
        return self.items[-1]
    def __str__(self):
        return(str(self.items))


def readF(file1):
    c=Queue()
    s=Queue()
    f=Queue()
    for line in file1:
            line1 = line.rstrip("\n")
#will look at first word in each line            
            e=''
            i=0
            while(i<len(line1)):
                if(line1[i]==' '):
                    break
                else:
                    e=e+line1[i]
                    i=i+1
            if(e=='add'):
                addP(line1,c,s,f)
            if(e=='treat'):
                treatP(line1,c,s,f)
            if(e=='exit'):
                print('Exit')
                break

def addP(line1,c,s,f):
    i=4
    name=''
    while(line1[i]!=' '):
        name=name+line1[i]
        i=i+1
    #leaves i on blank space btw name and condition
    if(line1[i+1]=="C"):
        con='Critical'
        c.enqueue(name)
    elif(line1[i+1]=='S'):
        con='Serious'
        s.enqueue(name)
    else:
        con='Fair'
        f.enqueue(name)
    print('Add patient '+name+' to '+con+' queue')
    print('Queues are:')
    print('Critical: ',c)
    print('Serious: ',s)
    print('Fair: ',f)
    print('')

def treatAll(line1,c,s,f):
    print('Treat all patients')
    empty=False
    while(not empty):
        if(not c.isEmpty()):
            t=c.dequeue()
            con='Critical'
        elif(not s.isEmpty()):
            t=s.dequeue()
            con='Serious'
        elif(not f.isEmpty()):
            t=f.dequeue()
            con='Fair'
        else:
            empty=True
        if(not empty):
            print('')
            print('Treating ',t,' from ',con,' queue')
            print('Queues are:')
            print('Critical: ',c)
            print('Serious: ',s)
            print('Fair: ',f)
            print('')
        else:
            print('')
            print('No patients in queues')
            print('')

def treatP(line1,c,s,f):
    empty=False
    nextP=True
    allP=False
    if(line1[6]=='n'):
        if(not c.isEmpty()):
            t=c.dequeue()
            con='Critical'
        elif(not s.isEmpty()):
            t=s.dequeue()
            con='Serious'
        elif(not f.isEmpty()):
            t=f.dequeue()
            con='Fair'
        else:
            empty=True
    elif(line1[6]=='a'):
        allP=True
    else:
        nextP=False
        if(line1[6]=="C"):
            con='Critical'
            if(not c.isEmpty()):
                t=c.dequeue()
            else:
                empty=True
        elif(line1[6]=='S'):
            con='Serious'
            if(not s.isEmpty()):
                t=s.dequeue()
            else:
                empty=True
        else:
            con='Fair'
            if(not f.isEmpty()):
                t=f.dequeue()
            else:
                empty=True
    if(allP):
        treatAll(line1,c,s,f)
    elif(nextP):
        print('Treat next patient')
    elif(not nextP):
        print('Treat next patient on ',con,' queue')
#not allP ensures nothing is printed if allP is true (allP is notEmpty, wouldn't want to print this stuff )
    if(not empty and not allP):
        print('')
        print('Treating ',t,' from ',con,' queue')
        print('Queues are:')
        print('Critical: ',c)
        print('Serious: ',s)
        print('Fair: ',f)
        print('')
    elif(empty):
        print('')
        print('No patients in queue')
        print('')





def main():
    file1 = open("ERsim.txt","r")	
    readF(file1)	
    file1.close()
main()
    





    
