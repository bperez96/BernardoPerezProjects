#  File: Queens.py
#  Description:Finds different solutions to the Queens problem given a board size
#  Student's Name:Bernardo Perez Fonseca
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number:51320 
#
#  Date Created:11/5/16
#  Date Last Modified:11/7/16
class QueensProblem:
    def __init__(self,n):
        self.board=[]
        self.size=n
        for i in range(n):
            a=[]
            for u in range(n):
                a.append('*')
            self.board.append(a)
        self.sols=0

    def __str__(self):
        n=self.size
        e=''
        for i in range(n):
            for u in range(n):
                e=e+str(self.board[i][u])+' '
            e=e+'\n'
        return(e)

    def solve(self,n):
        n1=n-1
        placed=False
        tested=False
        if(n1>=self.size):
            return('')
        elif('Q' in self.board[n1]):
            tested=True
        
        if not tested:
      #      print('not tested, working on row ',n1 )
            for i in range(self.size):
                if(self.isValid(n1,i)):
                    self.board[n1][i]='Q'
                    placed=True
       #             print(self)
                    if(n1==0):
                        self.sols+=1
                        print('Solution', self.sols)
                        print(self)
                        print('')
                        self.board[n1][i]='*'
                    else:
                        return(self.solve(n-1))
        
        else:
            Qfound=False
            for d in range(self.size):
                if(self.board[n1][d]=='Q'):
                    self.board[n1][d]='*'
                    Qfound=True
                    break
            for m in range(d+1,self.size):
 #               print(m)
                if(self.isValid(n1,m)):
                    self.board[n1][m]='Q'
                    placed=True
                    if(n1==0):
                        self.sols+=1
                        print('solution ',self.sols)
                        print(self)
                        print('')
                        self.board[n1][m]='*'
                    else:
                        return(self.solve(n-1))
        if(n1==0 and placed):
            #self.setUp()
#            print(self)
            return(self.solve(n+1))
        if not placed:
 #           print('going back')
 #           print(self)
            return(self.solve(n+1))
        

    def setUp(self):
        c=self.size-2
        while (c>=0):
            for i in range(self.size):
                self.board[c][i]='*'
            c-=1

    def isValid(self,n,i):
        rowsB=self.size-1-n
        rowsA=n-1
        valid=True
        for d in range (rowsB):
            if(i+d+1<self.size):
                if(self.board[n+d+1][i+d+1]=='Q'):
                    valid=False
                    return valid
            if(i-(d+1)>=0):
                if(self.board[n+d+1][i-(d+1)]=='Q'):
                    valid=False
                    return valid
        for c in range(rowsA):
            if(i+(c+1)<self.size):
                if(self.board[n-(c+1)][i+c+1]=='Q'):
                    valid=False
                    return valid
            if(i-(c+1)>=0):
                if(self.board[n-(c+1)][i-(c+1)]=='Q'):
                    valid=False
                    return valid    
        diag=[]
        diag2=[]
        col=[]
#        row=self.board[n]
#        print(row)
        rowB=False
        if(n>=i):
            rowB=True
            n1=n-i
            i1=0
           # n2=self.size-1
           # i2=
        else:
            rowB=False
            i1=i-n
            n1=0
#        while(i1<=self.size-1 and n1<=self.size-1):
#            diag.append(self.board[n1][i1])
#            n1+=1
#            i1+=1
        for d in range(self.size):
            col.append(self.board[d][i])
        
        if('Q' in col):
            return False
#        elif('Q' in row):
 #           return False
#        elif('Q' in diag):
#            return False
        else:
            return True
        
            
            
            
        



def main():
    valid=False
    while(not valid):
        size=int(input('Enter size of the square board: '))
        if(size<4):
            print("Invalid input!")
        else:
            valid=True
    q=QueensProblem(size)
    print(q)
    q.solve(size)
main()
