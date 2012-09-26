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
#import "MapUnitController.h"
#import "Config.h"
#import "AnimateSprite.h"
#import "EmptyArea.h"
#import "MoveStep.h"



@interface GameLayer : CCLayer {
    
    CCSprite *playBg;
    CCSprite *refreshUnit;
    CCSprite *newSprite;
    CCSpriteBatchNode *bgTiledBatchNode;
    CCSpriteBatchNode *refreshBatchNode;
    
    MapUnitController *unitController;
    
    MoveStep *ms;                                //  计时与步数
    
    CCSprite *pgbg;
    
    CCArray *storeArr;                           //  存储reflashunit
    
    
    CCProgressTimer *ct;
    CCProgressFromTo *ctft;
    
    CCLabelAtlas *stepLabel;
    
    BOOL timeStop;
        
    CGRect unitRect;
    CGSize screenSize;
    CGRect mapRect;
    CGRect tileRect;                            // 1/36每个 rect
    
    int intID;                                   //  精灵的ID
    int intGroupType;                                //  初始化的精灵的groupType
    int intType;                                //  初始化的精灵的type
    int intScore;                                //  初始化的精灵的分数
     
    
    
    int mapTileX;
    int mapTileY;
    
    int myx;
    int myy;
    
    int lastmyx;
    int lastmyy;
    
    int mapUID[6][6];                           // mapUnitID
    
    int mapUGT[6][6];                           // mapUnitGroupType
    
    int delGroup[6][6];                         // 存储待删除单位
    
    int delCount;                               // 删除计数
    
    int mapUnitType[6][6];
    
    int mapSpriteTag[6][6];
    
    int mapUnitScore[6][6];                     // 分数
    
    int nowID;
    
    BOOL isFirstTouch;
    
    BOOL beBombed;
    
    BOOL isPut;
    
    BOOL isFilled;                               // 地图是否已被填满
    
    CCSprite *firstTouchBG;
    
    CCArray *randomArr;                         // 飞的随机点
    
    CCArray *aroundSpriteTag;                  // 判断周围未存为组数组
    
    AnimateSprite *asp;                        //  动画效果
    
    NSMutableArray *rowItems;
    
    NSString *nowUnitID;
        
    BOOL isNeedGroup;                          // 是否合并
    
    BOOL isLeftEmpty;                          // 判断某个点左边是否有单位存在，没有则YES，反之NO;
    
    BOOL isRightEmpty;
    
    BOOL isTopEmpty;
    
    BOOL isBottomEmpty;
    
    BOOL isLTEmpty;
    
    BOOL isRTEmpty;
    
    BOOL isLBEmpty;
    
    BOOL isRBEmpty;
    
    BOOL isLCorner;                            // 判断改点是否属于边界上的点 属于则YES 反之NO;
    
    BOOL isRCorner;
    
    BOOL isTCorner;
    
    BOOL isBCorner;
    
    CCSprite *mapbg;                               //  背景精灵
    CCSprite *mapLTbg;                              
    CCSprite *mapRTbg;
    CCSprite *mapLBbg;
    CCSprite *mapRBbg;
    
    int mapbgArr[6][6];
    int mapbgInitArr[6][6];
    int mapLTbgArr[6][6];
    int mapRTbgArr[6][6];
    int mapLBbgArr[6][6];
    int mapRBbgArr[6][6];
    int mapLTbgInitArr[6][6];
    int mapRTbgInitArr[6][6];
    int mapLBbgInitArr[6][6];
    int mapRBbgInitArr[6][6];
    
    int ischecked[6][6];                            // 是否检测过移动
    
    int isDchecked[6][6];                            // 是否检测过移动
    
    BOOL isNeedDel;                            //  周围布满时是否需要挂掉
    
    BOOL isNeedMove;                           //  由于周围布满递归后不一定返回0 所以第一步返回0等于NO后直接让返回0
    
    
    int le;
    int te;
    int re;                                     //                  X   X
    int be;                                     //                  X O X
                                                //                  X   X
    int delGroupCount;                          //            用于放置O时 以上情况的计数  X为挂逼的单位
    
    int mergeX[4];
    
    int mergeY[4];
    
}

-(void)saveData;

@end
