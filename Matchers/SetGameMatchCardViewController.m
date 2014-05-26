//
//  SetGameMatchCardViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 5/2/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "SetGameMatchCardViewController.h"
#import "SetGameCard.h"
#import "SetGameCardDeck.h"
#import "SetGameCardGame.h"
#import "HistroyViewController.h"

@interface SetGameMatchCardViewController()

@property (nonatomic,strong)SetGameCard *card;

@property (strong, nonatomic) SetGameCardGame *game;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *setGameScore;

@property (weak, nonatomic) IBOutlet UILabel *setGameResultLable;

@property (strong,nonatomic) NSAttributedString *setGameCurrentResult;
@property (nonatomic) NSMutableAttributedString *history;
@end

@implementation SetGameMatchCardViewController


- (NSMutableAttributedString *)history
{
    if (!_history) {
        _history = [[NSMutableAttributedString alloc] init];
    }
    return _history;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setGameHis"]) {
        if ([segue.destinationViewController isKindOfClass:[HistroyViewController class]]) {
            HistroyViewController *tsvs = (HistroyViewController*)segue.destinationViewController;
            tsvs.sethistory = self.history;
        }
    }
    
}


- (SetGameCardGame *)game
{
    if (!_game) {
        _game = [[SetGameCardGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (Deck*)createDeck
{
    return [[SetGameCardDeck alloc]init];
}


- (SetGameCard *)card
{
    if (!_card) {
        _card = [[SetGameCard alloc]init];
    }
    return _card;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self upDateUI];
}

- (void)upDateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetGameCard *card = [self.game cardAtIndex:cardButtonIndex];
        NSLog(@"Bool value: %d",card.isChosen);
        [cardButton setAttributedTitle:[card getSetCardContent] forState:UIControlStateNormal];
        if(card.isChosen)
        {
            [cardButton.layer setBorderWidth:3.0];
            [cardButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        } else
        {
            [cardButton.layer setBorderWidth:0];
        }
        cardButton.enabled = !card.isMatched;
    }
    //NSLog(@"setGameResultLable: %@", self.setGameResultLable);
    //NSLog(@"GameResult: %@", self.setGameCurrentResult);
    [self.setGameResultLable setAttributedText:self.setGameCurrentResult];
    self.setGameScore.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}
- (IBAction)refreshCard {
    self.game = nil;
    [self upDateUI];
}

- (IBAction)touchCard:(UIButton *)sender {

    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    self.setGameCurrentResult = [self.game chooseCardAtIndex:chosenButtonIndex];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@"\n"];
    [self.history appendAttributedString: self.setGameCurrentResult];
    [self.history appendAttributedString: space];
    [self upDateUI];
}

@end
