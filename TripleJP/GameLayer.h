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
    
    int intGroupType;                                //  初始化的精灵的groupType
    int intType;                                //  初始化的精灵的type
    
    int mapTileX;
    int mapTileY;
    
    int mapUnitGroupType[6][6];
    
    int mapUnitType[6][6];
    
    int mapSpriteTag[6][6];
    
    int mapUnitGroupStorage[6][6];
    
    
    NSMutableArray *rowItems;
    
    CCSprite *mapbg;
}


@end
