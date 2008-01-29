//
//  GaussianGenerator.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GaussianGenerator : NSObject {
   BOOL haveNextNextGaussian;
   double nextNextGaussian;
}

- (id)initWithSeed:(unsigned long)seed;
- (id)init;
- (double)nextGaussian;
- (double)getNextRandom;
+ (double)calculateNormalProbabilityWith:(double)x;
+ (double)calculateNormalProbabilityForValue:(unsigned int)x
                     inRangeWithMaximumValue:(unsigned int)max;

@end
