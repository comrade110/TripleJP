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

struct StoCoor {
    int x1;
    int y1;
    int x2;
    int y2;
};
typedef struct StoCoor StoCoor;


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
    
    CCArray *storageArr;
    
    CCArray *clearArr;                         // 判断需要合并后待删除的单位
    
    CCArray *aroundSpriteTag;                  // 判断周围未存为组的
    
    
    
    NSMutableArray *rowItems;
    
    NSValue *miValue;
    
    BOOL isNeedGroup;                          // 是否合并
    
    CCSprite *mapbg;
}


@end
