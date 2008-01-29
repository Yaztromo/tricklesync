/*
 *  TimerProtocols.h
 *  SyncSimulationFramework
 *
 *  Created by Brad Barclay on 2007/12/08.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

@protocol SimulationAlarmProtocol
- (void)activateAlarm:(int)time;
@end

@protocol SimulationTickProtocol
- (void)activateTick:(int)time;
@end
