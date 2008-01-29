//
//  User.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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
