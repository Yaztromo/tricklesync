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


#import "Database.h"
#import "GaussianGenerator.h"

@implementation Database
@synthesize databaseType;
@synthesize records;

- (id)initWithRecordCount:(int)count 
        andAsDatabaseType:(unsigned int)type {
   int i;
   Record *r;
   
   [super init];
   databaseType = type;
   NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
   GaussianGenerator *d = [[GaussianGenerator alloc] init];
   
   for(i=0;i<count;i++) {
      r = [[Record alloc] initWithID:i usingDistribution:d];
      [tempArray addObject:r];
   } // end-for
   
   // This is done to ensure the resulting array is immutable
   records = [NSArray arrayWithArray:tempArray];
   return self;
} // end-initializer

- (id)initWithRecords:(NSArray *)recs
    andAsDatabaseType:(unsigned int)type {
   [super init];
   records = [NSArray arrayWithArray:recs];
   databaseType = type;
   return self;
} // end-initializer

- (NSArray *)compareAgainstDatabase:(Database *)db {
   int i;
   NSMutableArray *results = [[NSMutableArray alloc] init];
   for(i=0;i<[records count];i++) {
      if ([db getRecordWithID:i].recordVersion > [self getRecordWithID:i].recordVersion) {
         // Add this element to our results
         [results addObject:[self getRecordWithID:i]];
      } // end-if
   } // end-for
   return [NSArray arrayWithArray:results];
} // end-method

- (Record *)getRecordWithID:(int)idNum {
   return [records objectAtIndex:idNum];
} // end-method

- (int)getRecordCount {
   return [records count];
} // end-method

- (id)copyWithZone:(NSZone *)zone {
   NSMutableArray *recs = [[NSMutableArray allocWithZone:zone] initWithCapacity:[records count]];
   for (Record *next in records) {
      [recs addObject:[next copy]];
   } // end-for
   
   return [[Database allocWithZone:zone] initWithRecords:recs andAsDatabaseType:databaseType];
} // end-method

- (void)generateNewRecordSet {
   NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[records count]];
   GaussianGenerator *d = [[GaussianGenerator alloc] init];
   Record *r;
   int i;
   
   for(i=0;i<[records count];i++) {
      r = [[Record alloc] initWithID:i usingDistribution:d];
      [tempArray addObject:r];
   } // end-for
   
   // This is done to ensure the resulting array is immutable
   records = [NSArray arrayWithArray:tempArray];
} // end-method

@end
