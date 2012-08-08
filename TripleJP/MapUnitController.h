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
    
    int mapTileX;
    int mapTileY;
    
    int mapUnitType[6][6];
    int mapBGType[6][6];
    int mapIsChecked[6][6];
    
}

@end
