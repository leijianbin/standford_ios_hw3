//
//  MatchCardViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 4/20/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "MatchCardViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "HistroyViewController.h"

@interface MatchCardViewController ()

@property (strong, nonatomic) Deck* deck;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UISwitch *threeCardsModel;

@property (weak, nonatomic) IBOutlet UILabel *currentReulstLable;

@property (nonatomic) NSString *currentResult;

@property (nonatomic) NSMutableString *history;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end


@implementation MatchCardViewController

- (NSMutableString *)history
{
    if (!_history) {
        _history = [[NSMutableString alloc] init];
    }
    return _history;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"matchGameHis"]) {
        if ([segue.destinationViewController isKindOfClass:[HistroyViewController class]]) {
            HistroyViewController *tsvs = (HistroyViewController*)segue.destinationViewController;
            tsvs.history = self.history;
        }
    }
    
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                          usingDeck:[self createDeck]];
    }
    return _game;
}

//abstract
- (Deck*)createDeck
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    if (![self.threeCardsModel isOn]) {
        self.currentResult = [self.game chooseCardAtIndex:chosenButtonIndex threeCardOn:NO];
        [self upDateUI];
    }
    else{
        self.currentResult = [self.game chooseCardAtIndex:chosenButtonIndex threeCardOn:YES];
        [self upDateUI];
        //NSLog(@"You are in the 3 cards model. Still under construction!!!!");
    }
    self.currentReulstLable.text = self.currentResult;
    [self.history appendFormat:@"%@\n",self.currentResult];
    NSLog(@"History: %@",self.history);
}

- (void)upDateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLable.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
}
- (IBAction)restartButton:(UIButton *)sender {
    self.game = nil; //re-init game Model
    [self upDateUI]; //update the Game UI
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents: @"";
}

- (IBAction)modelSwitch:(UISwitch *)sender {
    
    if ([sender isOn])
    {
        NSLog(@"On");
        NSLog(@"Switch to 3 Card Modle, please wait to restart!");
         self.game = nil;
         [self upDateUI];
    }
    else
    {
        NSLog(@"Off");
        NSLog(@"Switch to 2 Card Modle, please wait to restart!");
        self.game = nil;
        [self upDateUI];
    }

}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}



@end
