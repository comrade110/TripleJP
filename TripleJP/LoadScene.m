//
//  LoadScene.m
//  TripleJurassicPark
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadScene.h"


@implementation LoadScene

-(id)init{

    self = [super init];
    if (self != nil) {
        LoadLayer *loadLayer = [LoadLayer node];
        
        [self addChild:loadLayer z:0];
    }
    return self;
}

@end
