//
//  ServerDatabase.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ServerDatabase.h"


@implementation ServerDatabase
@synthesize rand;
@synthesize poisson;

- (id)initWithRecordCount:(int)count
     andPoissonController:(ProbabilityController *)p {
   [super initWithRecordCount:count andAsDatabaseType:DATABASE_TYPE_SERVER];
   poisson = p;
   return self;
} // end-constructor

- (id)initWithRecords:(NSArray *)recs
 andPoissonController:(ProbabilityController *)p {
   [super initWithRecords:recs andAsDatabaseType:DATABASE_TYPE_SERVER];
   poisson = p;
   return self;
} // end-constructor

- (id)initWithRecordCount:(int)count
          withArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals {
   [super initWithRecordCount:count andAsDatabaseType:DATABASE_TYPE_SERVER];
   poisson = [[ProbabilityController alloc] initWithArrivalRate:rate withInterval:interval andMaxArrivals:maxArrivals];
   return self;
} // end-constructor

- (void)activateTick:(int)time {
   unsigned int sample, i, record;
   // Test to see if one or more events occurred during this tick.
   sample = [poisson getArrivalsSample];
   
   for(i=0;i<sample;i++) {
      // For each modification, find a random Gaussian record and modify it.
      // We need to modify a record somewhere.  Select one using a random in a Guassian distribution.
      record = (int)([rand nextGaussian]*[self getRecordCount]);

      // If the record goes off the beginning or the end of the database, update it to the beginning or end
      if (record<0) record = 0;
      if (record>=[self getRecordCount]) record = [self getRecordCount]-1;
      
      // Modify the record
      [[self getRecordWithID:record] updateRecord];      
   } // end-for
} // end-method

@end
