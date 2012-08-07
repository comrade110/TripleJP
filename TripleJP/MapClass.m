//
//  MapClass.m
//  TripleJP
//
//  Created by user on 12-7-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapClass.h"


@implementation MapClass

@synthesize map,mapRect;

- (id)init
{
    self = [super init];
    if (self) {
        map = [CCArray array];
        
        for (int i=0; 1<6; i++) {
            CCArray *line;
            [map addObject:line];
        }
        
    }
    return self;
}



@end
