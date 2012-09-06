//
//  MoveStep.m
//  TripleJP
//
//  Created by user on 12-9-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoveStep.h"


@implementation MoveStep

@synthesize utime,step;

static MoveStep *moveStep = nil;
+(MoveStep*)shareMoveStep{

    @synchronized(self){
        if (moveStep == nil) {
            moveStep = [[MoveStep alloc] init];
        }
    }
    
    return moveStep;
}

@end
