//
//  NetworkTest.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Network.h"

@interface NetworkTest : SenTestCase {
   Network *testObject;
}

- (void)testTimeCalc;
- (void)testCostCalc;
- (void)setUp;
- (void)tearDown;

@end
