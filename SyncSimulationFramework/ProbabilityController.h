//
//  ProbabilityController.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/11.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GaussianGenerator.h"

@interface ProbabilityController : NSObject {
   double arrivalRate;
   unsigned int timeIntervalInSeconds;
   NSArray *probabilities;
   GaussianGenerator *distController;
}
@property(readonly) double arrivalRate;
@property(readonly) unsigned int timeIntervalInSeconds;

+ (double)bernoulliProbabilityPerSecondFromEventsPerHour:(int)ratePerHour;
+ (double)factorial:(long)x;
+ (double)poissonProbabilityWithArrivalRate:(double)rate
                           withTimeInterval:(int)t
                       withNumberOfArrivals:(int)n;

- (id)initWithArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals;

- (unsigned int)getArrivalsSample;

@end
