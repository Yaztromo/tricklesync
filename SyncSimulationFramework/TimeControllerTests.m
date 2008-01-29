//
//  TimeControllerTests.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/23.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TimeControllerTests.h"


@implementation TimeControllerTests
- (void)setUp {
   controller = [[TimeController alloc] init];
   result = 0;
} // end-method

- (void)tearDown {
   controller = nil;
} // end-method

- (void)testTickListener {
   [controller addTickListener:self];
   [controller run];
   STAssertEquals(result, SECONDS_PER_DAY, @"The tick listener test did not count the proper number of ticks! (%d != %d)", result, SECONDS_PER_DAY);
   [controller removeAllListeners];
   result = 0;
} // end-method

- (void)testAlarmListener {
   [controller addAlarmListener:self withFireTime:10000];
   [controller addAlarmListener:self withFireTime:20000];
   [controller addAlarmListener:self withFireTime:40000];
   [controller addAlarmListener:self withFireTime:80000];
   [controller run];
   
   STAssertEquals(result, 4, @"The alarm listener test did not count the proper number of alarms! (%d != 4)", result);
   
   [controller removeAllListeners];
   result=0;
} // end-method

- (void)activateAlarm:(int)time {
   result++;
} // end-method

- (void)activateTick:(int)time {
   result++;
} // end-method

@end
