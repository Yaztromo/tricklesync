//
//  ThresholdPoint.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/05/26.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ThresholdPoint.h"


@implementation ThresholdPoint
@synthesize upperBound;
@synthesize lowerBound;
@synthesize currentValue;
@synthesize cost;

- (id)init {
   [super init];
   return self;
} // end-constructor

- (id)initWithUpperBound:(double)upper
       andWithLowerBound:(double)lower
            andWithValue:(double)val {
   [super init];
   upperBound = upper;
   lowerBound = lower;
   currentValue = val;
   return self;
} // end-constructor

- (ThresholdPoint *)getNewUpperThreshold {
   ThresholdPoint *ret = [[ThresholdPoint alloc] init];
   
   // First calculate the new upper bound.
   // If we're within epsilon of the upper bound, double the current and upper boundries.
   if (currentValue + THRESHOLD_EPSILON >= upperBound) {
   //if (currentValue == upperBound) {
      ret.upperBound = 200.0*currentValue;
      ret.currentValue = 200.0*currentValue;
   } else {
      // Otherwise, maintain the existing upper bound
      ret.upperBound = upperBound;
      ret.currentValue = (upperBound + currentValue)/2.0;
   } // end-if
   
   // Set the lower bound to the previous current value
   ret.lowerBound = currentValue;
   
   // Return.
   return ret;
} // end-method

- (ThresholdPoint *)getNewLowerThreshold {
   ThresholdPoint *ret = [[ThresholdPoint alloc] init];
   
   if (currentValue - THRESHOLD_EPSILON <= lowerBound) {
      ret.lowerBound = lowerBound/2.0;
   } else {
      ret.lowerBound = lowerBound;
   } // end-if

   ret.upperBound = currentValue;
   ret.currentValue = (lowerBound + currentValue)/2.0;
   
   return ret;
} // end-method

- (void)reduceBoundsByTenPercent {
   double val = (upperBound - lowerBound)/10.0;
   lowerBound+=val;
   upperBound-=val;
   if (lowerBound<0) lowerBound = 0;
} // end-method

- (NSString *)description {
   return [NSString stringWithFormat:@"Current = %0.2f, Upper Bound = %0.2f, Lower Bound =%0.2f", currentValue, upperBound, lowerBound];
} // end-method

@end
