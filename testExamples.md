# EVENT SOURCING

## Store events - not state
 - Atburðir sem gerast í kerfinu
 - Event Concepts
 --- hlutir sem gerast í þátíð
 --- t.d. PlayerPlacedMove, GameCreated, GameJoined

 - Triggeruð af Commands
 -- Commands => hlutir sem ég vil að gerist
 -- þ.e. PlaceMove, CreateGame, JoinGame
 -- oftast eitt command á móti hverjum event


# server
tictactoe-game.Spec
tictactoe-game
tictactoe-state
# client
app.js
app-test.js


- Aggregate (samansafn)
-- einn tictactoe leikur
- Command handler (sem tekur við command)
-- kann að túlka command, hlaða upp aggregate og setja saman, láta aggregate fá command
- Event Store 
-- Geymir eventa sem hafa orðið til í kerfinu
-- gagnagrunnar (postgres)
-- tvær töflur (commands store, event store)
- app context
-- uppúr "domain driven design"
-- hluturinn sem "límir" allt saman

- Projections
-- ef event fjöldinn hefur efri mörk þarf ekki
-- til að gera event hröð


Event Sourcing

Given
 [Events]
When
 Command
Then
 [Resulting Event(s)]

#1
Given
 [ GameCreated ]
When
 Place(0,0,X)
Then
 [ MovePlaced ]

#1.1
Given
 [ GameCreated, Placed(0,0,X) ]
When
 Place(0,0,Y)
Then
 [ IllegalMove ]

#1.2
Given
 [ GameCreated, Placed(0,0,X) ]
When
 Place(0,0,X)
Then
 [ NotYourMove ]

#1.3
Given
 [ GameCreated, Placed(0,0,X), Placed(0,1,X) ]
When
 Place(0,2,X)
Then
 [ X Won ]

#2
Given
 [ Placed(0,0,X) ]
When
 Place(0,0,Y)  
Then
 [ NotAllowed ]

 #3
Given
 [ GameCreated, GameStarted ]
When
 GameJoine
Then
 [ FullGameJoinAttempted ]


 #3.1
Given
 [ GameCreated ]
When
 GameJoine
Then
 [ GameJoined ]


#4
Given
 [ X Won ]
When
 Place(0,0,Y)
Then
 [ NotAllowed ]

#5
Given
 [ Placed(0,0,X), Placed(1,1,X) ]
When
 Place(2,2,X)
Then
 [ GameWon X]

#6
Given
 [ Placed(0,0,Y), Placed(1,1,Y) ]
When
 Place(2,2,Y)
Then
 [ GameWon Y]

 #7
Given
 [ GameCreated ]
When
 Place(3,0,X)
Then
 [ NotAllowed ]

#8
Given
 [ GameCreated, Placed(0,2,X), Placed(1,2,X) ]
When
 Place(2,2,X)
Then
 [ GameWon ] 

    Should not emit game draw if won on last move
    Should emit game draw when neither wins
    
#9
Given
 [ GameCreated, 
 Placed(0,0,X), Placed(0,1,Y), Placed(0,2,X), 
 Placed(1,1,Y), Placed(1,0,X), Placed(1,2,Y), 
 Placed(2,1,X), Placed(2,0,Y) 
When
 Place(2,2,X)
Then
 [ Tie, GameEnded ]

#9.1
Given
 [ GameCreated, 
 Placed(0,0,X), Placed(0,1,Y), Placed(0,2,X), 
 Placed(1,0,Y), Placed(1,1,X), Placed(1,2,Y), 
 Placed(2,1,X), Placed(2,0,Y) 
When
 Place(2,2,X)
Then
 [ GameWon ]

#10
Given
 []
When
 CreateGame
Then
 [ GameCreated ]
