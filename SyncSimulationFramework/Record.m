//
//  Record.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize recordID;
@synthesize recordSizeInBytes;
@synthesize recordVersion;

- (id)initWithID:(int)idNum
        withSize:(int)size
     withVersion:(int)version {
   [super init];
   recordID = idNum;
   recordSizeInBytes = size;
   recordVersion = version;
   return self;
} // end-initializer

- (id)initWithID:(int)idNum
        withSize:(int)size {
   return [self initWithID:idNum withSize:size withVersion:0];
} // end-initializer

- (id)initWithID:(int)idNum 
usingDistribution:(GaussianGenerator *)dist {
   // Calculate the size
   int size=([dist nextGaussian]+10)*1024;      // Ramdom size based on a distribution
   return [self initWithID:idNum withSize:size withVersion:0];
} // end-initializer

- (void)updateRecord {
   recordVersion++;
} // end-initializer

- (id)copyWithZone:(NSZone *)zone {
   return [[Record allocWithZone:zone] initWithID:recordID withSize:recordSizeInBytes withVersion:recordVersion];
} // end-method

@end
