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


#import "ServerDatabase.h"


@implementation ServerDatabase
@synthesize rand;
@synthesize poisson;

- (id)initWithRecordCount:(int)count
     andPoissonController:(ProbabilityController *)p {
   [super initWithRecordCount:count andAsDatabaseType:DATABASE_TYPE_SERVER];
   rand = [[GaussianGenerator alloc] init];
   poisson = p;
   return self;
} // end-constructor

- (id)initWithRecords:(NSArray *)recs
 andPoissonController:(ProbabilityController *)p {
   [super initWithRecords:recs andAsDatabaseType:DATABASE_TYPE_SERVER];
   rand = [[GaussianGenerator alloc] init];
   poisson = p;
   return self;
} // end-constructor

- (id)initWithRecordCount:(int)count
          withArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals {
   [super initWithRecordCount:count andAsDatabaseType:DATABASE_TYPE_SERVER];
   rand = [[GaussianGenerator alloc] init];
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
      record = (int)([GaussianGenerator calculateNormalProbabilityWith:[rand nextGaussian]]*[self getRecordCount]);

      // If the record goes off the beginning or the end of the database, update it to the beginning or end
      if (record<0) record = 0;
      if (record>=[self getRecordCount]) record = [self getRecordCount]-1;
      
      // Modify the record
      [[self getRecordWithID:record] updateRecord];      
   } // end-for
} // end-method

@end
