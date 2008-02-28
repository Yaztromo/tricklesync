//
//  Degree2Poly.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/27.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CostRecorder.h"

@interface Degree2Poly : NSObject {
   double x_squared;
   double x;
   double constant;
}
@property(readonly) double x_squared;
@property(readonly) double x;
@property(readonly) double constant;

- (id)init;

- (id)initWithFirstTerm:(double)termA
          andSecondTerm:(double)termB
            andConstant:(double)termC;

- (id)initFromPolyA:(CostRecorder *)polyA
           andPolyB:(CostRecorder *)polyB;

- (void)add:(Degree2Poly *)value;
- (void)divide:(int)value;

+ (Degree2Poly *)multiplyCostRecorder:(CostRecorder *)a
                     withCostRecorder:(CostRecorder *)b;
@end
