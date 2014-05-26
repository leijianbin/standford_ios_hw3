//
//  HistroyViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 5/10/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "HistroyViewController.h"

@interface HistroyViewController()

@property (weak, nonatomic) IBOutlet UITextView *historyBody;


@end

@implementation HistroyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    if (self.history) {
        self.historyBody.text = self.history;
    }
    else {
        [self.historyBody setAttributedText:self.sethistory];
    }
}

@end
