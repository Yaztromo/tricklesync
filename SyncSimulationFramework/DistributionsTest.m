//
//  DistributionsTest.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "DistributionsTest.h"
#import "GaussianGenerator.h"
#import "ProbabilityController.h"

@implementation DistributionsTest
- (void)testFactorial {
   STAssertEquals([ProbabilityController factorial:12], 479001600.0, @"Factorial (12!) test failed!");
} // end-test

- (void)testGaussians {
   double largest = -10000.0;
   double smallest = 10000.0;
   GaussianGenerator *d = [[GaussianGenerator alloc] init];
   int i;
   double g;
   for(i=0;i<1000000;i++) {
      g = [d nextGaussian];
      if (g<smallest) smallest = g;
      if (g>largest) largest = g;
      STAssertTrue(g>-10, @"Generated bad Gaussian: %f", g);
      STAssertTrue(g<10, @"Generated bad Gaussian: %f", g);
   } // end-for
} // end-test

@end
