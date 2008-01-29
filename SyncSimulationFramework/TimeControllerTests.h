//
//  TimeControllerTests.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/23.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TimerProtocols.h"
#import "TimeController.h"

@interface TimeControllerTests : SenTestCase <SimulationTickProtocol, SimulationAlarmProtocol> {
   TimeController *controller;
   int result;
}

- (void)setUp;
- (void)tearDown;
- (void)testTickListener;
- (void)testAlarmListener;
- (void)activateAlarm:(int)time;
- (void)activateTick:(int)time;

@end
