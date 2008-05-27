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


#import "LocationVector.h"
#import "ProbabilityController.h"


@implementation LocationVector
@synthesize entryTime;
@synthesize location;
@synthesize syncRequestArrivalRate;
@synthesize mobileDatabaseAccessRate;

- (id)initEntryTime:(int)time
        forLocation:(Location *)loc 
andExpectedSyncsPerHour:(double)syncRate 
andDatabaseModificationsPerHour:(double)modRate {
   [super init];
   entryTime = time;
   location = loc;
   syncRequestArrivalRate = [ProbabilityController bernoulliProbabilityPerSecondFromEventsPerHour:syncRate];
   //NSLog(@"$$$ The expected arrival rate is now %.12lf (was %.12lf)", syncRequestArrivalRate, syncRate);
   mobileDatabaseAccessRate = [ProbabilityController bernoulliProbabilityPerSecondFromEventsPerHour:modRate];
   //NSLog(@"$$$ The expected access rate is now %.12lf", mobileDatabaseAccessRate);
   return self;
} // end-method

- (BOOL)doEntryForTime:(int)time {
   return time==entryTime;
} // end-method

- (NSString *)description {
   return [location description];
} // end-method

@end
