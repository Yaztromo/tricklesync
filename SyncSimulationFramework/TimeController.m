//
//  TimeController.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TimeController.h"


@implementation TimeController
@synthesize time;

- (id)init {
   [super init];
   time = 0;
   tickListeners = [NSMutableArray array];
   alarmListeners = [NSMutableDictionary dictionary];
   return self;
} // end-constructor

- (id)initWithTickListeners:(NSArray *)ticks
      andWithAlarmListeners:(NSMutableDictionary *)alarms {
   [super init];
   time = 0;
   tickListeners = [NSMutableArray arrayWithArray:ticks];   
   alarmListeners = [NSMutableDictionary dictionaryWithDictionary:alarms];
   return self;
} // end-constructor

- (void)addTickListener:(id <SimulationTickProtocol>)tl {
      [tickListeners addObject:tl];
} // end-method

- (void)addAlarmListener:(id <SimulationAlarmProtocol>)al
            withFireTime:(unsigned int)t {
   // First check to see if a dictionary entry already exists for this fire time
   NSNumber *key;
   NSMutableArray *arr;

   key = [NSNumber numberWithInt:t];
   arr = [alarmListeners objectForKey:key];
   
   if (arr!=nil) {
      [arr addObject:al];
   } else {
      // We need to instantiate a new array, add the listener to it, and add the array to the dictionary.
      arr = [NSMutableArray arrayWithCapacity:2];
      [arr addObject:al];
      [alarmListeners setObject:arr forKey:key];
   } // end-if
} // end-method

- (void)run {
   int i;
   NSArray *alarms;
   
   // In a loop increment the time, call all the tick listeners, then call any alarm listeners regstered for this time.
   while (time<SECONDS_PER_DAY) {
      // Call the tick listeners
      for(i=0;i<[tickListeners count];i++) {
         [[tickListeners objectAtIndex:i] activateTick:time];
      } // end-for
      
      // Activate the alarms, if any
      if ((alarms=[alarmListeners objectForKey:[NSNumber numberWithInt:time]])!=nil) {
         for(i=0;i<[alarms count];i++) {
            [[alarms objectAtIndex:i] activateAlarm:time];
         } // end-for
      } // end-if
      
      time++;
   } // end-while
   
   // The simulation has completed.
   
} // end-method

- (void)removeAllListeners {
   tickListeners = [NSMutableArray array];
   alarmListeners = [NSMutableDictionary dictionary];   
} // end-method

@end
