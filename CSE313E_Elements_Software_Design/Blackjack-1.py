#  File: Blackjack.py
#  Description: Play blackjack against the computer
#  Student's Name: Bernardo Perez
#  Student's UT EID:bap2323
#  Course Name: CS 313E 
#  Unique Number: 51320
#
#  Date Created:9/16/16
#  Date Last Modified:9/19/16
class Player:
    
    def __init__(self):
        self.hand=[]
        pass
    def phand(self,c):
        self.handv=0
        self.hand.append(c)
        for ff in range(len(self.hand)):
            self.handv=self.handv+self.hand[ff].value
            #adds value of elements(cards) in hand
    def __str__(self):
        rr=''
        for y in range(len(self.hand)):
            rr=rr+" "+str(self.hand[y])
        return rr
    #printing a player obj prints their hand

def showHands(o,d):
    print('Dealer shows '+str(d.hand[1])+' faceup')
    print('You show '+str(o.hand[1])+' faceup')
    print('')
    print('You go first.')
    #shows only second card drawn
    

def opponentTurn(cardDeck,d,o):
    aceCount=0
    usedAce=False
    hasAce=False
    #looks at first individual cards in hand
    tt=o.hand[0]
    rr=o.hand[1]
    v1=rr.value
    v2=tt.value
    total=v1+v2
    o.handv=total
    #assigns the total to player variable value, total being hand value
    count=2
    for gg in range(len(o.hand)):
            gg1=str(o.hand[gg])
            if(gg1[0]=='A'):
                hasAce=True
                aceCount=aceCount+1
    #check for aces above
    #opponent stays in loop to be offereed hit or pass, unless bust occurs
    while(int(total)<21):
        print('')
        if(hasAce and aceCount>0):
            print('Assuming 11 points for an ace I was dealt for now')
        if(hasAce and aceCount==0):
            print('Assuming 1 point for an ace you were dealt for now')
        print("You hold "+str(o)+" for a total of "+ str(total))
        response=int(input('1 (hit) or 2 (stay)? '))
        #break if 2 is selceted
        if(response==1):
            cardDeck.dealOne(o)
            print(' ')
            print('Card dealt: '+str(o.hand[count]))
            ww=o.hand[count]
            ww1=str(ww)
            if(ww1[0]=='A'):
                hasAce=True
                aceCount=aceCount+1
            count=count+1
            v3=ww.value
            total=total+v3
            while(total>21):
                if (hasAce and aceCount>0):
                    print("Over 21. Switching from 11 points to 1.")
                    total=total-10
                    print('New total: '+str(total))
                    aceCount=aceCount-1
                else:
                    print('You have '+str(total)+'. You bust! Dealer wins.')
                    break
            if(total==21):
                print('21! My turn...')
                break   
        else:
            print('')
            print("Staying with "+str(total))
            break 
    o.handv=total                

def dealerTurn(cardDeck,d,o):
    print('')
    print("Dealer's turn")
    print('Your hand: '+str(o)+" for a total of "+ str(o.handv))
    
    aceCount=0
    usedAce=False
    hasAce=False
    tt=d.hand[0]
    rr=d.hand[1]
    v1=rr.value
    v2=tt.value
    total=v1+v2
    d.value=total
    count=2
    print("Dealer's hand: "+str(d)+" for a total of "+ str(total))
    for gg in range(len(d.hand)):
            gg1=str(d.hand[gg])
            if(gg1[0]=='A'):
                hasAce=True
                aceCount=aceCount+1
    #loop ensures dealer plays to least match the opponents hand
    while(int(total)<21 and total<o.handv):
        cardDeck.dealOne(d)
        print(' ')
        if(hasAce and aceCount>0):
            print('Assuming 11 points for an ace I was dealt for now')
        if(hasAce and aceCount==0):
            print('Assuming 1 point for an ace I was dealt for now')
        print('Dealer hits: '+str(d.hand[count]))
        ww=(d.hand[count])
        ww1=str(ww)
        if(ww1[0]=='A'):
                hasAce=True
                aceCount=aceCount+1
        count=count+1
        v3=ww.value
        total=total+v3
        print('New total: '+str(total))
        if(total==21):
            print('Dealer has 21. Dealer wins! You lose.')
    #following loops deals with a potential bust or victory (total>21)
        while(total>21):
            if (hasAce and aceCount>0):
                print('')
                print("Over 21. Switching an ace from 11 points to 1.")
                total=total-10
                print('New total: '+str(total))
                aceCount=aceCount-1
            else:
                print('')
                print('Dealer has '+str(total)+'. Dealer busts! You win.')
                break
            if(total==21):
                print('')
                print('21! Dealer wins!')
                break   
    if(total<21 and total>=o.handv):
            print('')
            print("Dealer has "+str(total)+'. Dealer wins!') 
    d.handv=total   
                
            
            
        

    
class Card:
#init automatically assigns value variable to each card
    def __init__(self,p,s):
        self.pip=p
        self.suit=s
        if(self.pip=='J'or self.pip=='Q' or self.pip=='K'):
            self.value=10
        elif(self.pip=='A'):
            self.value=11
        else:
            self.value=int(self.pip)
        

    def __str__(self):
        return(str(self.pip)+str(self.suit))
  

import random
class Deck:
    suits=["C","D","H","S"]
    pips=[2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    dd=[]
    for d in range(len(suits)):
        for b in range(len(pips)):
            c=Card(str(pips[b]),str(suits[d]))
            dd.append(c)
            
    def __init__(self):
        pass
    
    def __str__(self):
        count=0
        mm=''
        sets=len(self.dd)//13
        rem=len(self.dd)%13
#uses modulous/remainder to have even sets of 13 when possible when printing
        for g in range(0,sets):
            for o in range(0,13):
                mm=(mm+' '+'%3s' %(str(self.dd[count])))
                count=count+1
            mm=mm+'\n'
        for w in range(0,rem):
            mm=(mm+' '+'%3s' %(str(self.dd[count])))
            count=count+1
        return(mm)

    def shuffle(self):
        newDeck=random.shuffle(self.dd)
        return(newDeck)

    def dealOne(self,p):
        p.phand(self.dd[0])
        self.dd.remove(self.dd[0])
        
def main():
    cardDeck = Deck()
    print('Initial deck:')
    print('')
    print(cardDeck)
    random.seed(50)
    cardDeck.shuffle()
    print('Shuffled deck')
    print(cardDeck)

    dealer=Player()
    opponent=Player()
    cardDeck.dealOne(opponent)
    cardDeck.dealOne(dealer)
    cardDeck.dealOne(opponent)
    cardDeck.dealOne(dealer)
    print('')
    print('Deck after dealing two cards each:')
    print(cardDeck)
    print('')
    showHands(opponent,dealer)

    opponentTurn(cardDeck,dealer,opponent)
#ensures dealer plays if you haven't busted
    if(opponent.handv<=21):
        dealerTurn(cardDeck,dealer,opponent)
    print('Game over.')
    print('Final hands:')
    print('Dealer: '+ str(dealer))
    print('Opponent: '+ str(opponent))
main()
