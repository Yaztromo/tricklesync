//
//  LocationVector.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LocationVector.h"


@implementation LocationVector
@synthesize entryTime;
@synthesize location;

- (id)initEntryTime:(int)time
        forLocation:(Location *)loc {
   [super init];
   entryTime = time;
   location = loc;
   return self;
} // end-method

- (BOOL)doEntryForTime:(int)time {
   return time==entryTime;
} // end-method

@end
