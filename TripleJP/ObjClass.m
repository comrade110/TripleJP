//
//  ObjClass.m
//  TripleJP
//
//  Created by user on 12-7-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ObjClass.h"


@implementation ObjClass

@synthesize mapUnitSprite,mapBGSprite,unitType,isChecked;

- (id)init {
    self = [super init];
    if (self) {
        mapUnitSprite = nil;
        mapUnitSprite = nil;
        unitType = 0;
        isChecked = NO;
    }
    return self;
}

/********创建路径**********/

//if (getID == max[0]) {
//    if (getID2 == max[1]) {
//        if (getID3 == max[2]) {
//            if (getID4 == max[3]) {
//                refreshUnit =[CCSprite spriteWithSpriteFrameName:@"7001.png"];
//                [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
//                [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
//            }else {
//                nowID = getID4;
//            }
//        }else {
//            nowID = getID3;
//            if (getID3 - getID4 <= 2) {    // 第四级能合 且是最大的下级
//                nowID = getID4;                 // 则为第四级
//            }
//            
//        }
//    }else {
//        nowID = getID2;
//        if (getID3 == max[2]) {       // 第三级不能合
//            if (getID4 == max[3]) {      // 第四级不能合
//                nowID = getID2;              // 下3级都不行 所以等于最大
//            }else if (getID2 - getID4 <= 2) {    // 第四级能合 且是最大的下级
//                nowID = getID4;                 // 则为第四级
//            }
//        }else if (getID2 - getID3<= 2) {         // 第三级能合 且为最大下级
//            if (getID3-getID4<=2) {             // 则判断第四级
//                nowID = getID4;                 // 能合 且为第三级下级
//            }else {
//                nowID = getID3;                 // 不能合则为第三级
//            }
//        }
//        
//    }
//}else {                        
//    nowID = getID;                  //  当最大的可以合成
//    if (getID2 == max[1]) {         // 第二级不能合
//        if (getID3 == max[2]) {       // 第三级不能合
//            if (getID4 == max[3]) {      // 第四级不能合
//                nowID = getID;              // 下3级都不行 所以等于最大
//            }else if (getID - getID4 <= 2) {    // 第四级能合 且是最大的下级
//                nowID = getID4;                 // 则为第四级
//            }
//        }else if (getID - getID3<= 2) {         // 第三级能合 且为最大下级
//            if (getID3-getID4<=2) {             // 则判断第四级
//                nowID = getID4;                 // 能合 且为第三级下级
//            }else {
//                nowID = getID3;                 // 不能合则为第三级
//            }
//        }
//    }else if (getID - getID2 <= 2) {            // 第二级能和 且为最大下级
//        if (getID2-getID3<=2) {                 // 第三级也能合 且为2下级
//            if (getID3-getID4>=2) {             // 第四级也能合 且为3下级  
//                nowID = getID4;                 // 则为4
//            }else {
//                nowID = getID3;                 // 4不行 则3
//            }
//        }else {
//            nowID = getID2;                     // 3不行 则2
//        }
//    }
//    
//}

@end
