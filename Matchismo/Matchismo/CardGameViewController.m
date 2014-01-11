//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Андрей Балясников on 03/01/14.
//  Copyright (c) 2014 Andrey Balyasnikov. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
// private property

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end



@implementation CardGameViewController


- (CardMatchingGame *) game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}


- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}




- (IBAction)touchCardButton:(UIButton *)sender
{
    
    int cardAtIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardAtIndex];
    [self updateUI];
    
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardAtIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardAtIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}


- (NSString *) titleForCard:(Card *) card
{
    
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
