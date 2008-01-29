//
//  TimeController.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TimerProtocols.h"

#define SECONDS_PER_DAY 24*60*60

@interface TimeController : NSObject {
   unsigned int time;
   NSMutableArray *tickListeners;         // A simple array of objects that need to be alerted during every tick.
   NSMutableDictionary *alarmListeners;   // An array of items that need to be alerted at a specific time.
                                          // Note that this is a dictionary of arrays, to permit more than one
                                          // class to have an alarm at the same time.
}
@property(readonly) unsigned int time;

- (id)init;

- (id)initWithTickListeners:(NSArray *)ticks
      andWithAlarmListeners:(NSMutableDictionary *)alarms;

- (void)addTickListener:(id <SimulationTickProtocol>)tl;

- (void)addAlarmListener:(id <SimulationAlarmProtocol>)al
            withFireTime:(unsigned int)time;

- (void)removeAllListeners;

- (void)run;

@end
