//
//  MobileDatabase.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MobileDatabase.h"
#import "ProbabilityController.h"

@implementation MobileDatabase

@synthesize user;
@synthesize rand;

- (id)initWithRecordCount:(int)count 
                  forUser:(User *)usr 
         withCostRecorder:(CostRecorder *)cr 
    againstServerDatabase:(Database *)sdb {
   [super initWithRecordCount:count andAsDatabaseType:DATABASE_TYPE_MOBILE];
   user = usr;
   cost = cr;
   serverDB = sdb;
   rand = [[GaussianGenerator alloc] init];
   return self;
} // end-constructor

- (id)initWithRecords:(NSArray *)recs
              forUser:(User *)usr 
     withCostRecorder:(CostRecorder *)cr
againstServerDatabase:(Database *)sdb {
   [super initWithRecords:recs andAsDatabaseType:DATABASE_TYPE_MOBILE];
   user = usr;
   cost = cr;
   serverDB = sdb;
   rand = [[GaussianGenerator alloc] init];
   return self;
} // end-constructor

- (void)activateTick:(int)time {
   int record;
   // Check to see if the user has accessed a record during this tick.
   if ([[user getCurrentLocation] mobileDatabaseModificationRate] >= [rand getNextRandom]) {
      // We need to access a record somewhere.  Select one using a random number in a Guassian distribution.
      record = (int)([rand nextGaussian]*[self getRecordCount]);

      // Did the user access out-of-date data?  Check what the record version is on the server and verify.
      if ([[serverDB getRecordWithID:record] recordID] > [[self getRecordWithID:record] recordID]) {
         // The user accessed out-of-date information.  Increment the ethereal cost by one.
         [cost incrementEtherialCostBy:[cost etherealCostFactor]];
      } // end-if
   } // end-if
} // end-method

@end
