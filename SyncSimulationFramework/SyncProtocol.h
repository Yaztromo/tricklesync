/*
 *  SyncProtocol.h
 *  SyncSimulationFramework
 *
 *  Created by Brad Barclay on 2008/01/28.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#import "User.h"
#import "TimerProtocols.h"

@protocol SyncProtocol <SimulationTickProtocol, SimulationAlarmProtocol>
-  (id)initWithUser:(User *)u
 withServerDatabase:(ServerDatabase *):sd
 withTimeController:(TimeController *)tc
andWithCostRecorder:(CostRecorder *)cr;

- (void)activateAlarm:(int)time;
- (void)activateTick:(int)time;

@end
