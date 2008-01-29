//
//  CostRecorder.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/11.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CostRecorder.h"


@implementation CostRecorder
@synthesize realCost;
@synthesize etherialCost;
@synthesize etherealCostFactor;

- (id)init {
   [super init];
   realCost = 0.0;
   etherialCost = 0.0;
   etherealCostFactor = 1.0;
   return self;
} // end-initializer

- (void)incrementRealCostBy:(double)value {
   realCost+=value;
} // end-method

- (void)incrementEtherialCostBy:(double)value {
   etherialCost+=value;
} // end-method

@end
