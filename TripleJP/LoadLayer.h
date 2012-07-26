//
//  LoadLayer.h
//  TripleJurassicPark
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadLayer : CCLayer<CCDirectorDelegate> {
    
    CCSprite *bg;
    
    CCMenu *loadMenu;
    
    CCMenuItemImage *sBtn;
    
    CCDirectorIOS	*director_;	
}

@property (readonly) CCDirectorIOS *director;

@end
