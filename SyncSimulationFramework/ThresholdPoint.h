//
//  ThresholdPoint.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/05/26.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CostRecorder.h"

#define THRESHOLD_EPSILON 0.25

@class ThresholdPoint;

@interface ThresholdPoint : NSObject <NSCopying> {
   double upperBound;
   double lowerBound;
   double currentValue;
   CostRecorder *cost;
}
@property double upperBound;
@property double lowerBound;
@property double currentValue;
@property(copy) CostRecorder *cost;

- (id)initWithUpperBound:(double)upper
       andWithLowerBound:(double)lower
            andWithValue:(double)val;

- (ThresholdPoint *)getNewUpperThreshold;
- (ThresholdPoint *)getNewLowerThreshold;
- (void)reduceBoundsByTenPercent;

@end
