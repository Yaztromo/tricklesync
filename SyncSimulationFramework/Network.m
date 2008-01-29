//
//  Network.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Network.h"


@implementation Network
@synthesize networkName;
@synthesize costPerByte;
@synthesize transferRate;

- (id)initWithName:(NSString *)name
           andCost:(double)cost
   andTransferRate:(double)rate {
   
   [super init];
   networkName = name;
   costPerByte = cost;
   transferRate = rate;
   return self;
} // end-initializer

- (int)costToTransfer:(int)bytes {
   return (int)(bytes*costPerByte);
} // end-method

- (int)timeToTransfer:(int)bytes {
   return (int)(bytes*transferRate);
} // end-method

@end
