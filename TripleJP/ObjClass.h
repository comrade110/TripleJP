//
//  ObjClass.h
//  TripleJP
//
//  Created by user on 12-7-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct coordinates{
    
    NSArray *xcoord;
    
    NSArray *ycoord;
    
};

@interface ObjClass : CCNode {
    
    struct coordinates *coo;
}

-(CCSprite *)buildUnit:(NSString *)UnitID;


@end
