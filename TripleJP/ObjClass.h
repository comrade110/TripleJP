//
//  ObjClass.h
//  TripleJP
//
//  Created by user on 12-7-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface ObjClass : CCNode {
    
    CCSprite *mapUnitSprite;
    
    CCSprite *mapBGSprite;
    
    int unitType;
    
    BOOL isChecked;
    
}
@property(nonatomic,retain) CCSprite *mapUnitSprite;
@property(nonatomic,retain) CCSprite *mapBGSprite;
@property(nonatomic,assign) int unitType;
@property(nonatomic,assign) BOOL isChecked;


@end
