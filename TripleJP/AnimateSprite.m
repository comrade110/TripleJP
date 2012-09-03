//
//  AnimateSprite.m
//  TripleJP
//
//  Created by user on 12-8-31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnimateSprite.h"


@implementation AnimateSprite

-(void) removeSprite:(id)sender 
{
    [self removeChild:sender cleanup:YES];
}
- (id)init
{
    self = [super init];
    if (self) {
        
        
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        NSMutableArray *frames = [[NSMutableArray array] retain];
        // 构造每一个帧的实际图像数据
        for (int i = 1; i <= BOMB_SPRITE_SHEET_CAPACITY; i++) {
            NSString *frameName = [NSString stringWithFormat:@"bomb%02d.png", i];
            CCSpriteFrame *frame = [cache spriteFrameByName:frameName];
            [frames addObject:frame];
        }
        
        NSString *firstFrameName = [NSString stringWithFormat:@"bomb%02d.png", 1];
        id sprite = [CCSprite spriteWithSpriteFrameName:firstFrameName];
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:1.0f / 20];
        CCRepeat *repeat = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1];
        CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
        CCSequence *seq = [CCSequence actions:repeat,remove, nil];
        [sprite runAction:seq];

        
        // 将构造好的动画加入显示列表
        [self addChild:sprite];
        
    }
    return self;
}


@end
