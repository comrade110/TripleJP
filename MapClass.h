//
//  MapClass.h
//  TripleJP
//
//  Created by user on 12-7-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapTileAttribute.h"

@interface MapClass : CCNode {
    
    CCSprite *mapSprite[0][0];
    CGRect	mapRect;
	CGSize	tileSize;
    
}
@property(nonatomic,retain) CCArray *map;
@property(nonatomic,assign)  CGRect	mapRect;

@end
