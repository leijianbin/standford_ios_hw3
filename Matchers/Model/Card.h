//
//  Card.h
//  Matchers
//
//  Created by Jianbin Lei on 4/20/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject


@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property(nonatomic,getter = isMatched) BOOL matched;

-(int)match:(NSArray *)otherCards;

@end
