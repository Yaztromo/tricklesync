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
