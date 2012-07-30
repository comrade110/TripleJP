//
//  MapTileAttribute.h
//  TripleJP
//
//  Created by user on 12-7-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MapTileAttribute : CCNode {
    
    CGRect rect;
    CCSprite *tileBg;
    
}
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) CCSprite *tileBg;

@end
