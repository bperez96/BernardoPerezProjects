#  File: htmlChecker.py
#  Description:Checks html file for errors in code
#  Student's Name:Bernardo Perez
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number: 50940
#
#  Date Created:10/3/16
#  Date Last Modified:10/6/16
class Stack (object):
   def __init__(self):
      self.items = [ ]

   def isEmpty (self):
      return self.items == [ ]

   def push (self, item):
      self.items.append (item)

   def pop (self):
      return self.items.pop ()

   def peek (self):
      return self.items [len(self.items)-1]

   def size (self):
      return len(self.items)
   def __str__(self):
      return(str(self.items))
#goes thru file and finds tags within the code
def getTag(file1):
    inTag=False
    relevant=False
    tags=[]
    for line in file1:
        line1 = line.rstrip("\n")
        for p in range (0,len(line1)):
#first if ensures we only pay attention when < pops up
            if(line1[p]=='<'):
                relevant=True
                e=''
#ensures we dont pay attention to things after the white space in a tag
#appends what is considered relevant up to that point within the tag
            elif(line1[p]==' ' and relevant):
                relevant=False
                tags.append(e)
#ensures that if > is found and no whitespace is within the tag, everything within <> is appended
            elif(relevant and line1[p]=='>'):
                relevant=False
                tags.append(e)
#if relevance remains, the string(tag) continues to grow
            elif(relevant):
                e=e+line1[p]
    return tags 
    
#checks if tags match each other        
def checker(tags):
    exceptions=['br','hr','meta']
    s=Stack()
    balanced=True
    i=0
    mismatch=False
    validTags=[]
    while(i<len(tags) and balanced):
        sym=tags[i]
        if (sym[0]!='/' and sym not in exceptions):
            s.push(sym)
            print('Tag ',sym,' pushed: stack now ', s)
            if(sym not in validTags):
               validTags.append(sym)
               print(sym, ' added to Valid Tags')
        elif(sym in exceptions):
            print('Tag ' ,sym,' does not need to match:  stack is still ' ,s)
        else:
#this for if finds out if a closing tag doesnt have a opening match
            if s.isEmpty():
                balanced=False
            else:
                top=s.pop()
                if not matches(top,sym):
                    balanced=False
                    mismatch=True
                    break
                else:
                    print('Tag ',sym, 'matches top of stack: stack is  now ',s )
        i=i+1
    validTags.sort()
    if(balanced and s.isEmpty()):
        return("Process complete. No mismatches found. \n Valid Tags: "+ str(validTags)+ "\n Exceptions: "+str(exceptions))
    elif(not s.isEmpty and not mismatch):
        return('Process complete. Unmatched tags remain on stack:' +str(s)+ '\n'+'Valid Tags: '+ str(validTags)+ "\n Exceptions: "+str(exceptions))
    elif(mismatch):
        return('Error: tag is '+str(sym)+' but top of stack is '+str(top)+'\n Valid Tags: '+ str(validTags)+'\n Exceptions: '+str(exceptions))
    elif(not blanaced and not mismatch):
        return('Error: closing tag does not have matching openeing tag!')     

def matches (top, sym):
   s1 = sym[1:]
   return(s1==top)

def main():
    file1 = open("htmlfile.txt","r")
    tags=[]
    tags=getTag(file1)
    print(tags)
    print(checker(tags))
    
    




    file1.close()	
main()
