// --------------------------------------------------------------------------
// The Expedient Trickle Sync Project -- Source File.
// Copyright (c) 2008 Brad BARCLAY <bbarclay@jsyncmanager.org>
// --------------------------------------------------------------------------
// OSI Certified Open Source Software
// --------------------------------------------------------------------------
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free 
// Software Foundation; either version 2 of the License, or (at your option) 
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for 
// more details.
//
// You should have received a copy of the GNU General Public License along 
// with this program; if not, write to the Free Software Foundation, Inc., 
// 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
// --------------------------------------------------------------------------


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

- (void)resetLocationToStart {
   currentLocation = 0;
} // end-method

@end
