//
//  CardMatchingGame.m
//  Matchers
//
//  Created by Jianbin Lei on 4/23/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
//private
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards;
@property (nonatomic,strong) NSMutableArray *choseCards; //of Cards
@property (nonatomic) NSString *currentResult;

@end

@implementation CardMatchingGame

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

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? self.cards[index]:nil; //better
}

static const int MISMATCH_PENATY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSString *)chooseCardAtIndex:(NSUInteger)index
              threeCardOn:(BOOL)onff
{
    Card *card = [self cardAtIndex:index];
    self.currentResult = @"";
    if (onff) {
    // 3 cards model logic
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
                self.currentResult = [NSString stringWithFormat:@"%@ is not Chosen",card.contents];
                [self.choseCards removeObject:card];
            } else {
                if([self.choseCards count] == 2) //match
                {
                    int matchScore = [card match:self.choseCards];
                    int index_0 = [self.cards indexOfObject:self.choseCards[0]];
                    Card* element_0 = self.cards[index_0];
                    int index_1 = [self.cards indexOfObject:self.choseCards[1]];
                    Card* element_1 = self.cards[index_1];
                    //int matchScore = 2;
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.chosen = YES;
                        card.matched = YES;

                        element_0.matched = YES;

                        element_1.matched = YES;
                        [self.choseCards removeAllObjects];
                        
                        self.currentResult = [NSString stringWithFormat:@"Matched %@ %@ %@ for %d Points",card.contents,element_0.contents, element_1.contents, matchScore];
                        
                    } else {
                        self.score -= MISMATCH_PENATY;
                        self.currentResult = [NSString stringWithFormat:@"%@ %@ %@ don't matched!%d Points penalty",card.contents,element_0.contents, element_1.contents, MISMATCH_PENATY];
                        //code is not legacy, repeat itslef....
                        while([self.choseCards count])
                        {
                            Card *rmCard = [self.choseCards lastObject];
                            rmCard.chosen = NO;
                            [self.choseCards removeLastObject];
                        }
                        [self.choseCards addObject:card];
                        card.chosen = YES;
                    }
                }
                else {
                    [self.choseCards addObject:card];
                    card.chosen = YES;
                    self.currentResult = [NSString stringWithFormat:@"%@ is chosen",card.contents];
                }
                self.score -= COST_TO_CHOOSE;
            }
        }
    }
    else {
    // 2 cards model logic
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
                self.currentResult = [NSString stringWithFormat:@"%@ is not Chosen",card.contents];
            } else {
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                            self.currentResult = [NSString stringWithFormat:@"Matched %@ %@ for %d Points",card.contents, otherCard.contents,matchScore];
                        } else {
                            self.score -= MISMATCH_PENATY;
                            otherCard.chosen = NO;
                            self.currentResult = [NSString stringWithFormat:@"%@ %@ don't matched!%d Points penalty",card.contents, otherCard.contents, MISMATCH_PENATY];
                        }
                        break; // can only choose 2 cars for now
                    }
                }
                self.score -= COST_TO_CHOOSE;
                if (![self.currentResult length]) {
                    self.currentResult = [NSString stringWithFormat:@"%@ is chosen",card.contents];
                }
                card.chosen = YES;
            }
        }
        
    }
    return self.currentResult; //return the result of the current touch.
}


@end
