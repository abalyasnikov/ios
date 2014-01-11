//
//  PlayingCard.h
//  Matchismo
//
//  Created by Андрей Балясников on 04/01/14.
//  Copyright (c) 2014 Andrey Balyasnikov. All rights reserved.
//

#import "Card.h"


@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;


+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;


@end
