//
//  Deck.h
//  Matchismo
//
//  Created by Андрей Балясников on 04/01/14.
//  Copyright (c) 2014 Andrey Balyasnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"



@interface Deck : NSObject

- (void)addCard: (Card *)card atTop:(BOOL)atTop;
- (void)addCard: (Card *)card;

- (Card *)drawRandomCard;


@end
