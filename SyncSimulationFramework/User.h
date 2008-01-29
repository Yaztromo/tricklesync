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
#import "MobileDatabase.h"
#import "Database.h"
#import "Location.h"
#import "CostRecorder.h"
#import "TimerProtocols.h"

@class MobileDatabase;

@interface User : NSObject <SimulationAlarmProtocol> {
   NSArray *locations;           // A LocationVector Array.
   unsigned int currentLocation; // The index into the current location vector
   MobileDatabase *handheldDB;   // The handheld database that follows the user
}
@property(readonly) NSArray *locations;
@property(readonly) unsigned int currentLocation;
@property(readonly) MobileDatabase *handheldDB;

- (id)initUserWithLocations:(NSArray *)locVects
        andDatabaseWithSize:(unsigned int)size
           withCostRecorder:(CostRecorder *)cr
      againstServerDatabase:(Database *)sdb;

- (Location *)getCurrentLocation;

// This method will return TRUE if the location was updated, false otherwise.
- (BOOL)setLocationWithTime:(unsigned int)time;

// An alarm handler for switching locations
- (void)activateAlarm:(int)time;

@end
