//
//  GameLayer.h
//  TripleJP
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjClass.h"

@interface GameLayer : CCLayer {
    
    CCSprite *playBg;
    CCSprite *refreshUnit;
    CCSpriteBatchNode *bgTiledBatchNode;
    CCSpriteBatchNode *refreshBatchNode;
    CGRect unitRect;
    CGSize screenSize;
    CGRect mapRect;
    CGRect tileRect;                            // 1/36每个 rect

    
    int mapTileX;
    int mapTileY;
    
    int mapUnitType[6][6];
    
    
    NSMutableArray *rowItems;
    
    CCSprite *mapbg;
}


@end
