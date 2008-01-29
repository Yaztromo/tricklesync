//
//  CostRecorder.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/11.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CostRecorder : NSObject {
   double realCost;
   double etherialCost;
   double etherealCostFactor;
}
@property(readonly) double realCost;
@property(readonly) double etherialCost;
@property double etherealCostFactor;

- (id)init;
- (void)incrementRealCostBy:(double)value;
- (void)incrementEtherialCostBy:(double)value;

@end
