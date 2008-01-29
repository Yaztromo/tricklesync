//
//  NetworkTest.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NetworkTest.h"


@implementation NetworkTest
- (void)testTimeCalc {
   STAssertEquals([testObject timeToTransfer:10], 100, @"The Network object time to transfer calculation failed!");
}

- (void)testCostCalc {
   STAssertEquals([testObject costToTransfer:10], 25, @"The Network object cost to transfer calculation failed!");   
}

- (void)setUp {
   testObject = [[Network alloc] initWithName:@"Test Network" andCost:2.5 andTransferRate:10];
}

- (void)tearDown {
}

@end
