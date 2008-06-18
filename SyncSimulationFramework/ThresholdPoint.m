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
   // If we're greater than or exactly equal to the upper bound, double.
   if (currentValue >= upperBound) {
      ret.upperBound = 2.0*currentValue;
      ret.currentValue = 2.0*currentValue;
   } else if (upperBound - currentValue <= THRESHOLD_EPSILON) {
      // If however the current value is within epsilon less than the upper bound, do nothing
      return [self copy];
   } else {
      // Otherwise, maintain the existing upper bound, and increase the current value
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
   
   // If the current value is less than or equal to the lower bound, decrease the lower bound by half.
   if (currentValue <= lowerBound) {
      ret.lowerBound = lowerBound/2.0;
   } else if (currentValue-lowerBound <= THRESHOLD_EPSILON) {
      // If we're within the epsilon, simply return without change
      return [self copy];
   } else {
      ret.lowerBound = lowerBound;
   } // end-if

   ret.upperBound = currentValue;
   ret.currentValue = (lowerBound + currentValue)/2.0;
   
   return ret;
} // end-method

- (void)reduceBoundsByTenPercent {
   double val;
   
   // It's not worth reducing the bounds if we're already within the epsilon value.
   if (upperBound-lowerBound <= THRESHOLD_EPSILON) return;
   val = (upperBound - lowerBound)/10.0;
   lowerBound+=val;
   upperBound-=val;
} // end-method

- (NSString *)description {
   return [NSString stringWithFormat:@"Current = %0.2f, Upper Bound = %0.2f, Lower Bound =%0.2f", currentValue, upperBound, lowerBound];
} // end-method

- (id)copyWithZone:(NSZone *)zone {
   return [[ThresholdPoint allocWithZone:zone] initWithUpperBound:self.upperBound andWithLowerBound:self.lowerBound andWithValue:currentValue];
} // end-method

@end
