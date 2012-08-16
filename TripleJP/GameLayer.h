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
    
    int intID;                                   //  精灵的ID
    int intGroupType;                                //  初始化的精灵的groupType
    int intType;                                //  初始化的精灵的type
    
//    BOOL singleGroup;                             //  周围单个的精灵 是否需要与当前精灵一起存为数组  当当前精灵被合并后  不存数组  
    
    
    int mapTileX;
    int mapTileY;
    
    int myx;
    int myy;
    
    int mapUID[6][6];                           // mapUnitID
    
    int mapUGT[6][6];                           // mapUnitGroupType
    
    int delGroup[6][6];                         // 存储待删除单位
    
    int delCount;                               // 删除计数
    
    int mapUnitType[6][6];
    
    int mapSpriteTag[6][6];
    
    CCArray *storageArr;
    
    CCArray *clearArr;                         // 判断需要合并后待删除的单位
    
    CCArray *aroundSpriteTag;                  // 判断周围未存为组数组
    
    
    
    NSMutableArray *rowItems;
    
    NSValue *miValue;
    
    BOOL isNeedGroup;                          // 是否合并
    
    BOOL isLeftEmpty;
    
    BOOL isRightEmpty;
    
    BOOL isTopEmpty;
    
    BOOL isBottomEmpty;
    
    BOOL isCorner;
    
    BOOL isLCorner;
    
    BOOL isRCorner;
    
    BOOL isTCorner;
    
    BOOL isBCorner;
    
    CCSprite *mapbg;
}


@end
