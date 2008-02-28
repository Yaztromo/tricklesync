//
//  Degree2Poly.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/27.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Degree2Poly.h"


@implementation Degree2Poly

@synthesize x_squared;
@synthesize x;
@synthesize constant;

- (id)init {
   return [self initWithFirstTerm:0.0 andSecondTerm:0.0 andConstant:0.0];
} // end-constructor

- (id)initWithFirstTerm:(double)termA
          andSecondTerm:(double)termB
            andConstant:(double)termC {
   [super init];
   x_squared = termA;
   x = termB;
   constant = termC;
   return self;
} // end-constructor

- (id)initFromPolyA:(CostRecorder *)polyA
           andPolyB:(CostRecorder *)polyB {
   return [self initWithFirstTerm:polyA.etherialCost * polyB.etherialCost
                    andSecondTerm:polyA.etherialCost * polyB.realCost + polyB.etherialCost * polyA.realCost
                      andConstant:polyA.realCost * polyB.realCost];
} // end-method

- (void)add:(Degree2Poly *)value {
   x_squared+=value.x_squared;
   x+=value.x;
   constant+=value.constant;
} // end-method

- (void)divide:(int)value {
   x_squared/=(double)value;
   x/=(double)value;
   constant/=(double)value;
} // end-method

+ (Degree2Poly *)multiplyCostRecorder:(CostRecorder *)a
                     withCostRecorder:(CostRecorder *)b {
   return [[Degree2Poly alloc] initFromPolyA:a andPolyB:b];
} // end-static-method

- (NSString *)description {
   return [NSString stringWithFormat:@"y=%.3fx^2+%.3fx+%.3f", x_squared, x, constant];
} // end-method

@end
