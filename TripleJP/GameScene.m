//
//  GameScene.m
//  TripleJP
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(id)init{
    
    self = [super init];
    if (self != nil) {
        GameLayer *gameLayer = [GameLayer node];
        
        [self addChild:gameLayer z:0];
    }
    return self;
}

@end
