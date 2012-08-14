//
//  MapUnitController.h
//  TripleJP
//
//  Created by user on 12-8-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ReflashUnit.h"

@interface MapUnitController : CCNode {

    
    int mapUGT[6][6];
    
    int delGroup[6][6];
    
    int mapUnitType[6][6];
    
    int mapSpriteTag[6][6];
    
    int mapSpriteIschecked[6][6];
    
    CCArray *delArr;
    
}

@end
