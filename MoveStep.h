//
//  MoveStep.h
//  TripleJP
//
//  Created by user on 12-9-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MoveStep : CCNode {
    
}
@property(nonatomic,readwrite) int utime;
@property(nonatomic,readwrite) int step;

+(MoveStep*)shareMoveStep;
//
//-(void)saveData;
//
//-(void)loadData;

@end
