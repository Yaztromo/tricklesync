//
//  User.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "LocationVector.h"

@implementation User
@synthesize locations;
@synthesize currentLocation;
@synthesize handheldDB;

- (id)initUserWithLocations:(NSArray *)locVects
        andDatabaseWithSize:(unsigned int)size 
           withCostRecorder:(CostRecorder *)cr
      againstServerDatabase:(Database *)sdb {
   [super init];
   currentLocation = 0;
   handheldDB = [[MobileDatabase alloc] initWithRecordCount:size forUser:self withCostRecorder:cr againstServerDatabase:sdb];
   locations = [NSArray arrayWithArray:locVects];
   return self;
} // end-constructor

- (Location *)getCurrentLocation {
   return [(LocationVector *)[locations objectAtIndex:currentLocation] location];
} // end-method

- (BOOL)setLocationWithTime:(unsigned int)time {
   if([locations count]==currentLocation+1) {
      // We're already at the last location, so we can't change to anything.
      return FALSE;
   } else {
      // Check to see if it's time to change to the next location
      if ([(LocationVector *)[locations objectAtIndex:currentLocation+1] doEntryForTime:time]) {
         currentLocation++;
         return TRUE;
      } else {
         return FALSE;
      } // end-if
   } // end-if
} // end-method

// An alarm handler for switching locations
- (void)activateAlarm:(int)time {
   // We switch to the next location when the alarm goes off, if one exists.
   if([locations count]>currentLocation+1) {
      currentLocation++;
   } // end-if
} // end-method


@end
