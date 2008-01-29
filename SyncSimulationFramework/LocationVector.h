//
//  LocationVector.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

// A location vector is a combination of a location and a time.
// This is useful, as we can be in a single location at multiple times during a day,
// and this provides us with a way of determining hen we need to change from one location
// to another.

@interface LocationVector : NSObject {
   unsigned int entryTime;    // The time we enter this location, expressed in seconds from 0000.
   Location *location;        // The location we enter at the specified time.
}
@property(readonly) unsigned int entryTime;
@property(readonly) Location *location;

- (id)initEntryTime:(int)time
        forLocation:(Location *)loc;

- (BOOL)doEntryForTime:(int)time;

@end
