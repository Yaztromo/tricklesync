//
//  SyncControllerTests.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/05.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SyncControllerTests.h"
#import "SyncController.h"

@implementation SyncControllerTests

- (void)testXMLParser {
   SyncController *sc;
   
   sc = [[SyncController alloc] initWithXMLFile:@"sample.xml"];
   
   STAssertNotNil(sc, @"The SyncController initializer returned nil!");
} // end-unit-test-method

@end
