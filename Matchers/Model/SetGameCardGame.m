//
//  SetGameCardGame.m
//  Matchers
//
//  Created by Jianbin Lei on 5/4/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "SetGameCardGame.h"
#import "SetGameCard.h"

@interface SetGameCardGame()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards;
@property (nonatomic,strong) NSMutableArray *choseCards; //of Cards
@property (nonatomic) NSMutableAttributedString *currentResult;

@end

@implementation SetGameCardGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)choseCards
{
    if(!_choseCards) _choseCards = [[NSMutableArray alloc] init];
    return _choseCards;
}

- (instancetype)initWithCardCount: (NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    if(self)
    {
        //implemenet your own init
        for (int i = 0;  i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            //cards[i] = card;
            //[self.cards insertObject:card atIndex:i];
        }
    }
    return self;
}

- (SetGameCard *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? self.cards[index]:nil; //better
}

- (NSAttributedString *)chooseCardAtIndex:(NSUInteger)index
{
    SetGameCard *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.choseCards removeObject:card];
            self.currentResult = [[NSMutableAttributedString alloc] initWithAttributedString:[card getSetCardContent]];
            NSAttributedString *otherContent = [[NSAttributedString alloc] initWithString:@" is not chosen"];
            [self.currentResult appendAttributedString:otherContent];
            
        } else {
            card.chosen = YES;
            if([self.choseCards count] == 2)
            {
                int matchScore = [card match:self.choseCards];
                SetGameCard* element_0 = self.choseCards[0];
                SetGameCard* element_1 = self.choseCards[1];
                
                if (matchScore) {
                    //if match
                    card.chosen = YES;
                    
                    card.matched = YES;
                    element_0.matched = YES;
                    element_1.matched = YES;
                    [self.choseCards removeAllObjects];
                    self.score += 4;
                    
                    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
                    self.currentResult = [[NSMutableAttributedString alloc] initWithAttributedString:[card getSetCardContent]];
                    [self.currentResult appendAttributedString:space];
                    [self.currentResult appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[element_0 getSetCardContent]]];
                    [self.currentResult appendAttributedString:space];
                    [self.currentResult appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[element_1 getSetCardContent]]];
                    
                    NSAttributedString *otherContent = [[NSAttributedString alloc] initWithString:@" is matched! Score: +4!"];
                    [self.currentResult appendAttributedString:otherContent];
                } else {
                    //if not match ...
                    card.chosen = NO;
                    element_0.chosen = NO;
                    element_1.chosen = NO;
                    [self.choseCards removeAllObjects];
                    self.score -= 1;
                    
                    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
                    self.currentResult = [[NSMutableAttributedString alloc] initWithAttributedString:[card getSetCardContent]];
                    [self.currentResult appendAttributedString:space];
                    [self.currentResult appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[element_0 getSetCardContent]]];
                    [self.currentResult appendAttributedString:space];
                    [self.currentResult appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:[element_1 getSetCardContent]]];
                    
                    NSAttributedString *otherContent = [[NSAttributedString alloc] initWithString:@" is not matched! Score: -1!"];
                    [self.currentResult appendAttributedString:otherContent];
                }
            } else {
                [self.choseCards addObject:card];
                self.currentResult = [[NSMutableAttributedString alloc] initWithAttributedString:[card getSetCardContent]];
                NSAttributedString *otherContent = [[NSAttributedString alloc] initWithString:@" is chosen"];
                [self.currentResult appendAttributedString:otherContent];
            }
        }
    }
    return self.currentResult;
}

@end
