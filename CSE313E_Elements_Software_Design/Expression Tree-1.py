#  File: Expression Tree.py
#  Description: creates expression tree which is traversed to be evaluated
#  Student's Name: Bernardo Perez
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number: 51320
#
#  Date Created:11/28/16
#  Date Last Modified:11/29/16

    
class BinaryTree:

    def __init__(self,initval,parent=None):
        self.data=initval
        self.left=None
        self.right=None
        self.parent=parent

    
            

    def insertLeft(self,newNode):
        if self.left == None:
            self.left = BinaryTree(newNode,parent=self)
        else:
            t = BinaryTree(newNode,parent=self)
            t.left = self.left
            self.left = t

    def insertRight(self,newNode):
        if self.right == None:
            self.right = BinaryTree(newNode,parent=self)
        else:
            t = BinaryTree(newNode,parent=self)
            t.right = self.right
            self.right = t

    def createTree (self, expr):
        
        current=self
        l=[' ','+','-','*','/','(',')']
        op=['+','-','/','*']
        i=0
        while i<(len(expr)):
            if(expr[i]=='('):
                current.insertLeft(' ')
                current=current.left
            elif(expr[i] not in l ):
                g=''
                flo=False
                while expr[i]!=' ':
                    g=g+expr[i]
                    if(expr[i]=='.'):
                        flo=True
                    i+=1
                if(flo):
                    current.setRootVal(float(g))
                    current=current.parent
                else:
                    current.setRootVal(int(g))
                    current=current.parent
            elif(expr[i]==')'):
                current=current.parent
            elif(expr[i] in op):
                current.setRootVal(expr[i])
                current.insertRight(' ')
                current=current.right
            i+=1

    

    

    def setRootVal(self,value):
        self.data = value

    def getRootVal(self):
        return self.data

    def evaluate(self):
        op=['+','-','/','*']
        if self.getRootVal() not in op:
            return(self.getRootVal())
        else:
            if(self.getRootVal()=="+"):
                return(self.left.evaluate()+self.right.evaluate())
            elif(self.getRootVal()=="-"):
                return(self.left.evaluate()-self.right.evaluate())
            elif(self.getRootVal()=="/"):
                return(self.left.evaluate()/self.right.evaluate())
            elif(self.getRootVal()=="*"):
                return(self.left.evaluate()*self.right.evaluate())

    def inorder(self):
      if self.left == None:
         leftVal = ""
      else:
         leftVal = self.left.inorder()+" "

      if self.right == None:
         rightVal = ""
      else:
         rightVal = " "+self.right.inorder()

      return (leftVal+str(self.getRootVal())+rightVal)

    def preorder(self):
      if self.left == None:
         leftVal = ""
      else:
         leftVal = ' '+self.left.preorder()+" "

      if self.right == None:
         rightVal = ""
      else:
         rightVal = " "+self.right.preorder()

      return (str(self.getRootVal())+leftVal+rightVal)

    def postorder(self):
      if self.left == None:
         leftVal = ""
      else:
         leftVal = self.left.postorder()+" "

      if self.right == None:
         rightVal = ""
      else:
         rightVal = " "+self.right.postorder()+' '

      return (leftVal+rightVal+str(self.getRootVal()))




    

    
      




def main():
    file1 = open("treedata.txt","r")
    for line in file1:
        line1 = line.rstrip("\n")
        
        expr=line1
        theTree=BinaryTree(' ')
        theTree.createTree(expr)
        m=theTree.evaluate()
        print('Infix expression:  ',line1)
        print(' ')
        print('   Value:  ', m)
        print('   Prefix expression: ', theTree.preorder())
        print('   Postfix expression: ', theTree.postorder())
        
        print(' ')
        
 
    
main()

