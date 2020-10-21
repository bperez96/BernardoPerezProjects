#  File: SortingComparissons.py
#  Description: generates different lists and compares the timeit takes to sort them using different algorithms
#  Student's Name: Bernardo Perez
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number: 51320
#
#  Date Created:11/14/16
#  Date Last Modified:11/15/16
import random
import time
import sys
sys.setrecursionlimit(10000)

def bubbleSort(alist):
    for passnum in range(len(alist)-1,0,-1):
        for i in range(passnum):
            if alist[i] > alist[i+1]:
                temp = alist[i]
                alist[i] = alist[i+1]
                alist[i+1] = temp

def selectionSort(alist):
    for fillslot in range(len(alist)-1,0,-1):
        positionOfMax = 0
        for location in range(1,fillslot+1):
            if alist[location] > alist[positionOfMax]:
                positionOfMax = location
        temp = alist[fillslot]
        alist[fillslot] = alist[positionOfMax]
        alist[positionOfMax] = temp


def insertionSort(alist):
    for index in range(1,len(alist)):
        currentvalue = alist[index]
        position = index

        while position>0 and alist[position-1]>currentvalue:
            alist[position] = alist[position-1]
            position = position-1

        alist[position] = currentvalue

def shellSort(alist):
    sublistcount = len(alist)//2
    while sublistcount > 0:
        for startposition in range(sublistcount):
            gapInsertionSort(alist,startposition,sublistcount)
        sublistcount = sublistcount // 2

def gapInsertionSort(alist,start,gap):
    for i in range(start+gap,len(alist),gap):
        currentvalue = alist[i]
        position = i

        while position>=gap and alist[position-gap]>currentvalue:
            alist[position] = alist[position-gap]
            position = position - gap

        alist[position] = currentvalue

def mergeSort(alist):
    if len(alist) > 1:
        mid = len(alist) // 2
        lefthalf = alist[:mid]
        righthalf = alist[mid:]

        mergeSort(lefthalf)
        mergeSort(righthalf)

        i = 0
        j = 0
        k = 0

        while i<len(lefthalf) and j<len(righthalf):
            if lefthalf[i] < righthalf[j]:
                alist[k] = lefthalf[i]
                i += 1
            else:
                alist[k] = righthalf[j]
                j += 1
            k += 1

        while i < len(lefthalf):
            alist[k] = lefthalf[i]
            i += 1
            k += 1

        while j < len(righthalf):
            alist[k] = righthalf[j]
            j += 1
            k += 1

def quickSort(alist):
    quickSortHelper(alist,0,len(alist)-1)

def quickSortHelper(alist,first,last):
    if first < last:
        splitpoint = partition(alist,first,last)
        quickSortHelper(alist,first,splitpoint-1)
        quickSortHelper(alist,splitpoint+1,last)

def partition(alist,first,last):
    pivotvalue = alist[first]
    leftmark = first + 1
    rightmark = last
    done = False

    while not done:

        while leftmark <= rightmark and alist[leftmark] <= pivotvalue:
            leftmark += 1

        while alist[rightmark] >= pivotvalue and rightmark >= leftmark:
            rightmark -= 1

        if rightmark < leftmark:
            done = True
        else:
            temp = alist[leftmark]
            alist[leftmark] = alist[rightmark]
            alist[rightmark] = temp

    temp = alist[first]
    alist[first] = alist[rightmark]
    alist[rightmark] = temp

    return rightmark

def generateRlist(n):
    l=[]
    for i in range(n):
        d=random.randint(0,n)
        l.append(d)
    return l

def swapSome(l):
    size=len(l)
    s=size//10
    for i in range(s):
        m1=random.randint(0,size-1)
        m2=m1
        while(m2==m1):
            m2=random.randint(0,size-1)
        temp=l[m1]
        l[m1]=l[m2]
        l[m2]=temp
    return l

def getAvg(t):
    sum=0
    for i in range (5):
        sum=sum+t[i]
    avg=sum/5
    return sum

def getTime(w,d,n):
    times=[]
    
    for i in range(5):
        if (d==2 or d==3 or d==4):
            l=[m for m in range(n)]
        if (d==3):
            l.reverse()
        if (d==1):
            l=generateRlist(n)
        if(d==4):
            l=swapSome(l)
        if w==1:
            sTime=time.perf_counter()
            bubbleSort(l)
            endtime=time.perf_counter()
        if w==2:
            sTime=time.perf_counter()
            selectionSort(l)
            endtime=time.perf_counter()
        if w==3:
            sTime=time.perf_counter()
            insertionSort(l)
            endtime=time.perf_counter()
        if w==4:
            sTime=time.perf_counter()
            shellSort(l)
            endtime=time.perf_counter()
        if w==5:
            sTime=time.perf_counter()
            mergeSort(l)
            endtime=time.perf_counter()
        if w==6:
            sTime=time.perf_counter()
            quickSort(l)
            endtime=time.perf_counter()
        etime=endtime-sTime
        times.append(etime)
    avg=getAvg(times)
    return avg




def main():
    t=[1,2,3,4]
    fun=[1,2,3,4,5,6]
    for i in range (len(t)):
        if t[i]==1:
            mm='Random'
        if t[i]==2:
            mm='Sorted'
        if t[i]==3:
            mm='Reverse'
        if t[i]==4:
            mm='Almost sorted'
        print('Input type = ',mm)
        print('%27s' %('avg time')+'%11s' %('avg time')+'%11s' %('avg time'))
        print('%15s' %('Sort Function')+'%12s' %('(n=10)')+'%11s' %('(n=100)')+'%11s' %('(n=1000)'))
        print('-------------------------------------------------')
        for ii in range (len(fun)):
            if fun[ii]==1:
                dd='bubbleSort'
            if fun[ii]==2:
                dd='selectionSort'
            if fun[ii]==3:
                dd='insertionSort'
            if fun[ii]==4:
                dd='shellSort'
            if fun[ii]==5:
                dd='mergeSort'
            if fun[ii]==6:
                dd='quickSort'
            print('%15s' %(dd)+'%12.6f' %(getTime(fun[ii],t[i],10))+'%11.6f' %(getTime(fun[ii],t[i],100))+'%11.6f' %(getTime(fun[ii],t[i],1000))  )    
        print('')
        print('')
            
        

main()
