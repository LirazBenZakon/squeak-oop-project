﻿ImageMorph subclass: #Card
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Maman15-WarGame'!

!Card methodsFor: 'initialization' stamp: 'lbz 2/19/2023 01:52'!
initialize: aNumber
	| img |
	
	super initialize.
	value := aNumber rem: 13.
	img := (aNumber asString) , '.png'.
	self image: ((ImageReadWriter formFromFileNamed: img) magnifyBy: 0.16).! !


!Card methodsFor: 'display' stamp: 'lbz 2/28/2023 22:37'!
roundWinner
	| img |
	
	img:= (ImageMorph new newForm: (ImageReadWriter formFromFileNamed: 'winner.png')).
	self addMorphFront: img.
	img center: self center.

	World doOneCycle.
	0.2 seconds asDelay wait.
	self removeMorph: img.! !


!Card methodsFor: 'getter' stamp: 'lbz 2/17/2023 20:29'!
value
	" return value of card "
	^value.! !


Card subclass: #BlankCard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Maman15-WarGame'!

!BlankCard methodsFor: 'initialization' stamp: 'lbz 2/28/2023 22:37'!
initialize
	super initialize.
	value := -1.
	self image: ((ImageReadWriter formFromFileNamed:  'blank.png' ) magnifyBy: 0.137).! !


!BlankCard methodsFor: 'evaluating' stamp: 'lbz 2/26/2023 23:33'!
value
	" return value of card "
	^value.! !


Object subclass: #DeckOfCards
	instanceVariableNames: 'allCards deckPlayer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Maman15-WarGame'!

!DeckOfCards methodsFor: 'as yet unclassified' stamp: 'lbz 2/26/2023 19:50'!
popCard
	"take one card from this deck, remove it from the orederd collection"
	| card |
	
	(self numOfCards =0)
	ifTrue: [^(BlankCard new initialize)].
	
	card:= allCards at:1.
	allCards remove: card.
	
	^card! !

!DeckOfCards methodsFor: 'as yet unclassified' stamp: 'lbz 2/17/2023 20:30'!
shuffle
	" shuffle 52 cards "
	allCards := allCards shuffle.! !


!DeckOfCards methodsFor: 'getter' stamp: 'lbz 2/21/2023 02:06'!
allCards
	^allCards.! !

!DeckOfCards methodsFor: 'getter' stamp: 'lbz 2/17/2023 20:30'!
numOfCards
	"return the number of cards currently at the deck"
	^ allCards size.! !


!DeckOfCards methodsFor: 'setter' stamp: 'lbz 2/26/2023 23:26'!
addCard: card 
	"add a card to the deck"
	allCards add: card.! !

!DeckOfCards methodsFor: 'setter' stamp: 'lbz 2/26/2023 19:48'!
combineDecks: aDeck
	"combine two decks into initaial deck"
	(1 to: aDeck numOfCards) do: [:i | | card |
		card:=((aDeck allCards) at: i).
		((card value) > -1) ifTrue: [ self addCard: card]].! !


!DeckOfCards methodsFor: 'initialize-release' stamp: 'lbz 2/17/2023 14:41'!
initialize
	"a new deck of cards will be held in an Ordered Collection"
	allCards := OrderedCollection new.
	! !


BorderedMorph subclass: #Players
	instanceVariableNames: 'name aDeck cardArray'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Maman15-WarGame'!

!Players methodsFor: 'as yet unclassified' stamp: 'lbz 2/25/2023 22:13'!
drawOneCard
	"draw one card from my deck"
	| oneCard |
	
	"takes care of placement"
	(aDeck = 0) ifTrue: [oneCard := BlankCard new initialize].
	
	oneCard := aDeck popCard.
	cardArray at: 1 put: BlankCard new initialize.
	cardArray at: 2 put: BlankCard new initialize.
	cardArray at: 3 put: oneCard.

	self removeAllMorphs.
	self display.
	^oneCard.! !

!Players methodsFor: 'as yet unclassified' stamp: 'lbz 2/28/2023 22:31'!
drawThreeCards
	"draw three cards from my deck"
	| firstCard secondCard thirdCard threeCards |
	
	self removeAllMorphs.
	firstCard := aDeck popCard.
	secondCard :=  aDeck popCard.
	thirdCard :=  aDeck popCard.
	cardArray at: 1 put: thirdCard.
	cardArray at: 2 put: secondCard.
	cardArray at: 3 put: firstCard.
	
	threeCards := DeckOfCards new initialize.
	threeCards addCard: thirdCard.
	threeCards addCard: secondCard.
	threeCards addCard: firstCard.

	self removeAllMorphs.
	self display.
	^threeCards.! !

!Players methodsFor: 'as yet unclassified' stamp: 'lbz 2/28/2023 22:31'!
drawTwoCards
	"draw two cards from my deck"
	| firstCard secondCard twoCards |
	
	firstCard := aDeck popCard.
	secondCard := aDeck popCard.
	cardArray at: 1 put: BlankCard new initialize.
	cardArray at: 2 put: secondCard.
	cardArray at: 3 put: firstCard.
	
	twoCards := DeckOfCards new initialize.
	twoCards addCard: BlankCard new initialize..
	twoCards addCard: secondCard.
	twoCards addCard: firstCard.
	
	self removeAllMorphs.
	self display.
	^twoCards.! !


!Players methodsFor: 'display' stamp: 'lbz 2/28/2023 22:32'!
display
	"displaying relevant cards and the relevant cards in the player's deck"

	self addMorph: (self displayRelevantCards).
	self addMorph: (self displayNumOfCards).! !

!Players methodsFor: 'display' stamp: 'lbz 2/26/2023 23:22'!
displayNumOfCards
	" displays the number of cards at player's deck at current time "
	| cardHeight cardWidth displayCount deckNum|
	
	cardWidth := (Card new initialize: 1) width.
	cardHeight := (Card new initialize: 1) height.
	displayCount := TextMorph new.
	deckNum := aDeck numOfCards.
	displayCount contents: (' Player name: ', name, ' Number of cards in deck: ', (deckNum asString), ' ').

	displayCount extent: 3*cardWidth@cardHeight.
	displayCount wrapCentering: #center.
	displayCount color: Color black.	
	displayCount backgroundColor: Color paleRed.
	^displayCount.! !

!Players methodsFor: 'display' stamp: 'lbz 2/28/2023 22:33'!
displayRelevantCards
	" display relevante cards (1 or 3 or blanks) "
	| cardHeight cardWidth Row  |
							
	cardWidth := (Card new initialize: 1) width.
	cardHeight := (Card new initialize: 1) height.
	
	Row := Morph new.
	Row layoutPolicy: TableLayout new.
	Row extent: cardWidth*2.6@cardHeight.
	Row listDirection: #leftToRight.
	Row listCentering: #topLeft.
	Row wrapCentering: #center.	
	Row color: Color paleBlue.
	(1 to: 3) do: [:i | 
		Row addMorph: (cardArray at: i )].

	^Row.! !


!Players methodsFor: 'setter' stamp: 'lbz 2/19/2023 17:20'!
addCardToPlayerDeck: aCard
	aDeck addCard: aCard.
	! !

!Players methodsFor: 'setter' stamp: 'lbz 2/21/2023 02:10'!
addCardsToPlayerDeck: deck
	aDeck combineDecks: deck.
	self removeAllMorphs.
	self display.! !


!Players methodsFor: 'initialization' stamp: 'lbz 2/28/2023 22:36'!
initialize: thisDeck withName: aName
	| aCard cardWidth cardHeight|
	
	super initialize.
	aDeck := thisDeck.
	name := aName.
	aCard := Card new initialize: 1.
	cardWidth := aCard width.
	cardHeight := aCard height.
	cardArray := Array new: 3.
	
	cardArray at: 1 put: ( BlankCard new initialize).
	cardArray at: 2 put: ( BlankCard new initialize).
	cardArray at: 3 put: ( BlankCard new initialize).
	
	self extent: 3*cardWidth@cardHeight+5.
	self layoutPolicy: TableLayout new.
	self listDirection: #topToBottom.
	self listCentering: #topRight.
	self wrapCentering: #center.
	self vResizing: #spaceFill.
	self hResizing: #spaceFill.
	self color: Color paleBlue.
	self borderWidth: 1.
	self borderColor: Color black.

	self display.
! !


!Players methodsFor: 'getter' stamp: 'lbz 2/22/2023 00:39'!
aDeck
	^ aDeck.! !

!Players methodsFor: 'getter' stamp: 'lbz 2/28/2023 22:33'!
cardsInDeck
	^aDeck numOfCards.! !

!Players methodsFor: 'getter' stamp: 'lbz 2/17/2023 17:55'!
name
	^name.! !


BorderedMorph subclass: #WarGame
	instanceVariableNames: 'allPlayers stop do'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Maman15-WarGame'!

!WarGame methodsFor: 'as yet unclassified' stamp: 'lbz 2/27/2023 00:31'!
presentWinnerPlayAgain: winner
	|  anotherRound |
	
	UIManager default inform: 'The winner is:' , winner name.

	[anotherRound ~= 'a' and: anotherRound ~= 'c'] whileTrue:[
		anotherRound := UIManager default request: 'Game has ended!!', String cr, 'Would you like to play again?', String cr,'a for accept c for cancel.'].

	(anotherRound = 'a')
	ifTrue:[self removeAllMorphs.
			self initialize.]
	
	ifFalse: [^false.]! !


!WarGame methodsFor: 'event handling' stamp: 'lbz 2/20/2023 18:28'!
handlesMouseDown: anEvent
	"Yes, handle mouse down"
	^true! !

!WarGame methodsFor: 'event handling' stamp: 'lbz 2/26/2023 21:49'!
handlesMouseOver: anEvent
	"Yes, handle mouse over"
	^true.! !

!WarGame methodsFor: 'event handling' stamp: 'lbz 2/24/2023 19:00'!
mouseDown: anEvent
	"when mouse is on the game board and it was clicked once, do one round"
	do:=true.! !

!WarGame methodsFor: 'event handling' stamp: 'lbz 2/24/2023 19:00'!
mouseEnter: anEvent
	"when the mouse is on the game board stop running"
	stop:=true.
	do := false.! !

!WarGame methodsFor: 'event handling' stamp: 'lbz 2/27/2023 00:32'!
mouseLeave: anEvent
	"when mouse leaves the game board update to keep running"
	stop:=false.
	do := true.! !


!WarGame methodsFor: 'initialization' stamp: 'lbz 2/28/2023 22:31'!
initialize
	| playersNames aPlayer boardWidth boardHeight numPlayers playerDeck allCards cardsPerPlayer  |
	
	super initialize.
	playersNames := (UIManager default request: ('Please enter playesr names' , String cr, '(name1, name2...')) asString.
	playersNames ifNil: [^self]. "the user canceled the input"
	numPlayers := (playersNames subStrings: ',') size.
	
	((numPlayers<2) or: (numPlayers>4)) 
	ifTrue: [UIManager default inform: 'Invalid input. Please enter number of players between 2 and 4.'. 
		     ^self].

	aPlayer := Players new initialize: (DeckOfCards new initialize) withName: 'a'.
	boardWidth := aPlayer width.
	boardHeight := aPlayer height.
	
	self position: 45@50.
	self extent: numPlayers*boardWidth@boardHeight.
	self layoutPolicy: TableLayout new.
	self listDirection:  #leftToRight.
	self listCentering: #topLeft.
	self wrapCentering: #center.
	self vResizing: #spaceFill.
	self hResizing: #spaceFill.
	self color: Color black.
	self borderWidth: 0.
	self openInWorld.
	
	"initialize the 52 cards deck of cards"
	allCards := DeckOfCards new initialize.
	cardsPerPlayer := (52 / numPlayers) floor.
	
	0 to: 51 do: [:cardSerial |
		allCards addCard: (Card new initialize: cardSerial)].
	allCards shuffle.
	
	allPlayers := OrderedCollection new: numPlayers.
	(1 to: numPlayers) do: [:p |
		playerDeck := DeckOfCards new initialize.  "initialize a deck per player"
		(1 to: cardsPerPlayer) do: [:i | playerDeck addCard: (allCards popCard)].  "fill with cards"
		allPlayers add: (Players new initialize: playerDeck withName:((playersNames subStrings: ',') at: p)) . "create player object with name and a deck to play"
		].
	
	" add to board all players morphs "
	(1 to: numPlayers) do: [:x| 	self addMorph: (allPlayers at: x)].
		
	stop:=false.
	do:=true.
	World doOneCycle.
	0.5 seconds asDelay wait.
		! !


!WarGame methodsFor: 'round' stamp: 'lbz 2/27/2023 00:23'!
inWar: players with: cards addTo: deck
	"play round of war between players"
	| numPlayers max twoCards threeCards check warPlayers newDeck winnerCard winner roundCards  oneCard inRound |

	numPlayers := players size.
	max := (BlankCard initialize new) value.
	warPlayers := OrderedCollection new.
	roundCards := OrderedCollection new.
	newDeck := OrderedCollection new.
	check := OrderedCollection new.
	inRound := OrderedCollection new.

	(1 to: (players size)) do: [:p1 | | w1 w2 | 
		w1 := (players at:p1) at:1.
		((p1+1) to: (players size)) do: [:p2 |
			w2 := (players at:p2) at:1.
			(w1~=w2) ifTrue:  [inRound add: ((players at: p1) at:1).
								inRound add: ((players at: p2) at:1)]
			].	
		].	
		inRound := (inRound asSet) asOrderedCollection.	
			
	"seperates players in war from those who are not and adds their cards to new deck to check if theres need for another war with their last round cards"
	(1 to: (cards size)) do: [:x |
		((inRound includes: ((cards at: x) at:1))) ifFalse: [newDeck add:{((cards at:x) at:1).((cards at:x) at:2)}]].

	
	(1 to: (inRound size)) do: [:i |
	((inRound at: i) cardsInDeck>2) ifTrue:[
			threeCards := (inRound at: i) drawThreeCards.
			deck combineDecks: threeCards.	
			(1 to: 3) do: [:c | newDeck add: {(inRound at: i). (threeCards allCards) at: c}].]
		
		"player in war but has only 2 cards left"
		ifFalse: [((inRound at: i) cardsInDeck = 2) ifTrue:[
					twoCards := (inRound at: i) drawTwoCards. 
					deck combineDecks: twoCards.
					(1 to: 2) do: [:c | newDeck add: {(inRound at: i). (twoCards allCards) at: c}].	
					].
				"player in war but has only 1 card left"
				((inRound at: i) cardsInDeck = 1) ifTrue:[ 
					oneCard:=(inRound at: i) drawOneCard. 
					deck addCard: oneCard.
					newDeck add: {(inRound at: i). oneCard}.].
				
			].
		].
	
	"find the winner for this round"
	(1 to: (newDeck size)) do: [:i | | card |
		card := (newDeck at:i) at: 2.
		(card value>max) ifTrue: [
				winnerCard := card.
				max := (card value). 
				winner := (newDeck at: i) at:1.]
		
		].
	
	
	"finds if two or more players have the same value card, if true, add them to the list of players that go to another war round"
	(1 to: (newDeck size)) do: [:p1 | | prevVal prevVal2 |
			prevVal := (((newDeck at: p1) at: 2) value).
		((p1+1) to: (newDeck size)) do: [:p2 | 
				prevVal2 := (((newDeck at: p2) at: 2) value). 
				((prevVal = prevVal2)and:(((newDeck at: p1)at:1)~=((newDeck at: p2)at:1)))
				ifTrue: [warPlayers add: { ((newDeck at: p1) at:1) . ((newDeck at: p1) at:2) }.
						warPlayers add: { ((newDeck at: p2) at:1) . ((newDeck at: p2) at:2) }].
			]
		].
	
	World doOneCycle.
	1 seconds asDelay wait.
	
	"checks if we need to play round of war"
	((warPlayers size)>0) 
		ifTrue: [self inWar: warPlayers with: newDeck addTo: deck.]
		ifFalse: [winnerCard roundWinner.
				winner addCardsToPlayerDeck: deck.].
! !

!WarGame methodsFor: 'round' stamp: 'lbz 2/27/2023 00:22'!
playOneStep
	"one round to play"
	| card winner max winnerCard deck warPlayers  war keepPlaying |

	max := (BlankCard new initialize) value.
	deck := DeckOfCards new.
	warPlayers := OrderedCollection new.
	war := OrderedCollection new.

	(1 to: (allPlayers size)) do: [:i | 
		((allPlayers at: i) cardsInDeck>0) ifTrue:[
				card := (allPlayers at: i) drawOneCard.
				deck addCard: card.  "a deck that recives all cards played in this round, winner will win all cards"
				war add: {((allPlayers at: i) ).(card)}. "holds all players with their card"
				(card value>max) ifTrue: [ "find the winner for this round"
					winnerCard := card.
					max := (card value). 
					winner := (allPlayers at: i).]]
			ifFalse: [(allPlayers at: i) drawOneCard.].
			
		]. 	

	
	"finds if two or more players have the same value card, if true, add them to the list of players that go to war round"
	(1 to: (war size)) do: [:p1 | | prevVal prevVal2 |
			prevVal := (((war at: p1) at: 2) value).
		((p1+1) to: (war size)) do: [:p2 | 
				prevVal2 := (((war at: p2) at: 2) value). 
				((prevVal = prevVal2)and:(((war at: p1)at:1)~=((war at: p2)at:1)))
				ifTrue: [warPlayers add: { ((war at: p1) at:1) . ((war at: p1) at:2) }.
						warPlayers add: { ((war at: p2) at:1) . ((war at: p2) at:2) }].
			]
		].
	
	
	"check if we found a winner"
	(1 to: (allPlayers size)) do: [:i |
	(((allPlayers at: i) cardsInDeck=51) or: (((allPlayers at: i) cardsInDeck=50)and:(allPlayers size =3)))
			ifTrue: [keepPlaying:=self presentWinnerPlayAgain: (allPlayers at: i)].
			(keepPlaying=false) ifTrue:[^false]].
		

	World doOneCycle.
	1 seconds asDelay wait.
	
	"checks if we need to play round of war"
	((warPlayers size)>0) 
		ifTrue:[ self inWar: warPlayers with:war addTo:deck.]
		ifFalse: [winnerCard roundWinner.
				winner addCardsToPlayerDeck: deck.].
	^true.		
	! !


!WarGame methodsFor: 'getter' stamp: 'lbz 2/20/2023 17:45'!
do
	^do.! !

!WarGame methodsFor: 'getter' stamp: 'lbz 2/20/2023 17:45'!
stop
	^stop.! !


!WarGame methodsFor: 'stepping and presenter' stamp: 'lbz 2/27/2023 00:23'!
play
	"controls mouse actions"
	| checkStop checkDo loop |

	loop:= true.
	[loop] whileTrue: [
	checkStop := stop.
	checkDo := do.
	checkStop ifTrue:[World doOneCycle.(Delay forMilliseconds:1)wait. (checkDo) ifTrue:[do:=false. self playOneStep]].
	((checkStop=false) and: (checkDo=true)) ifTrue: [(loop:= self playOneStep)].]! !
