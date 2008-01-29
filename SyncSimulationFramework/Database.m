//
//  Database.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "GaussianGenerator.h"

@implementation Database
@synthesize databaseType;

- (id)initWithRecordCount:(int)count 
        andAsDatabaseType:(unsigned int)type {
   int i;
   [super init];
   databaseType = type;
   NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
   GaussianGenerator *d = [[GaussianGenerator alloc] init];
   
   for(i=0;i<count;i++) [tempArray addObject:[[Record alloc] initWithID:i usingDistribution:d]];
   
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
         [results addObject:[db getRecordWithID:i]];
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

@end
