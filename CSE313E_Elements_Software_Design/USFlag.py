#  File: USFlag.py
#  Description:Creates US Flag with user's choice of flag height
#  Student's Name: Bernardo Perez 
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number: 50940
#
#  Date Created:
#  Date Last Modified:
#fucntion below draws white star and positions turtle ready to move to adjacent star
def drawWhiteStar(bb,r):
    bb.right(36)
    bb.circle(r,steps=5)
    bb.left(72)
    bb.fillcolor('white')
    bb.begin_fill()
    bb.forward(2*r*0.9512)
    bb.left(144)
    bb.forward(2*r*0.9512)
    bb.left(144)
    bb.forward(2*r*0.9512)
    bb.left(144)
    bb.forward(2*r*0.9512)
    bb.left(144)
    bb.forward(2*r*0.9512)
    bb.left(108)
    bb.end_fill()

def main():
    import turtle
    bb=turtle.Turtle()
    h=input('Height of Flag: ')
    h=int(h)
    w=h*1.9
    
    screen=turtle.Screen()
    screen.setup(200+w,200+h,0,0)
    bb.penup()
    bb.speed(speed=40)
    bb.goto(-w/2,-h/2)
    bb.pendown()
    #loop below creates rectangle for flag
    for pp in range(2):
        bb.forward(w)
        bb.left(90)
        bb.forward(h)
        bb.left(90)
#loop below makes alternating stripes
    for i in range(1,14):
        bb.pendown()
        if(i%2==0):
            bb.fillcolor('white')
        else:
            bb.fillcolor('red')
        bb.begin_fill()
        bb.forward(w)
        bb.left(90)
        bb.forward(h/13)
        bb.left(90)
        bb.forward(w)
        bb.left(180)
        bb.end_fill()
    bb.right(90)
    bb.goto(-w/2,-h/2)
    bb.goto(-w/2,h/2)
#loop below creates canton
    bb.fillcolor('blue')
    bb.begin_fill()
    for dd in range(2):
        bb.forward((7/13)*h)
        bb.left(90)
        bb.forward((2/5)*w)
        bb.left(90)
    bb.end_fill()
    bb.penup()
#lines before loop set turtle ready to make the first star in bottom left corner
    bb.goto(0,0)
    r=(4/10)*(1/13)*(h)
    bb.forward(h/26)
    bb.right(90)
    bb.forward((w/2)-w*(1/5)*(1/12))
    bb.right(180)
    bb.forward(r*0.5878)
    bb.left(90)
    bb.forward(r*0.809)
    bb.right(90)
#loops below make alternating rows of 6/5 stars
    for oo in range(1,10):
        if(oo%2==0):
            for tt in range(1,6):
                drawWhiteStar(bb,r)
                if(tt<5):
                    bb.forward(w*(4/5)*(1/12))
            bb.left(90)
            bb.forward(h*(7/13)*(1/10))
            bb.left(90)
            bb.forward(9*w*(2/5)*(1/12))
            bb.left(180)
#turtle is set to start next row of stars
        else:
            for gg in range(1,7):
                drawWhiteStar(bb,r)
                if(gg<6):
                    bb.forward(w*(4/5)*(1/12))
            bb.left(90)
            bb.forward(h*(7/13)*(1/10))
            bb.left(90)
            bb.forward(9*w*(2/5)*(1/12))
            bb.left(180)
#turtle is set to start next row of stars    
main()
