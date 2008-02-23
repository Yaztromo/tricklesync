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


#import <Cocoa/Cocoa.h>
#import "Location.h"

// A location vector is a combination of a location and a time.
// This is useful, as we can be in a single location at multiple times during a day,
// and this provides us with a way of determining hen we need to change from one location
// to another.

@interface LocationVector : NSObject {
   unsigned int entryTime;    // The time we enter this location, expressed in seconds from 0000.
   Location *location;        // The location we enter at the specified time.
   double syncRequestArrivalRate;         // as expected number of synchronizations per second
   double mobileDatabaseModificationRate; // as probability of record modification per second
}
@property(readonly) unsigned int entryTime;
@property(readonly) Location *location;
@property(readonly) double syncRequestArrivalRate;
@property(readonly) double mobileDatabaseModificationRate;

- (id)initEntryTime:(int)time
        forLocation:(Location *)loc
andExpectedSyncsPerHour:(int)syncRate
andDatabaseModificationsPerHour:(int)modRate;

- (BOOL)doEntryForTime:(int)time;

@end
