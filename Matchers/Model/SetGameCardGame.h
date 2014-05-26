//
//  SetGameCardGame.h
//  Matchers
//
//  Created by Jianbin Lei on 5/4/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"    
#import "SetGameCard.h"

@interface SetGameCardGame : NSObject

- (instancetype)initWithCardCount: (NSUInteger)count
                        usingDeck:(Deck *)deck;
- (NSAttributedString *)chooseCardAtIndex:(NSUInteger)index;
- (SetGameCard *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) NSInteger score;

@end
