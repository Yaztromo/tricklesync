// --------------------------------------------------------------------------
// The Expedient Trickle Sync Project -- Source File.
// Copyright (c) 2008 Brad BARCLAY <bbarclay@jsyncmanager.org>
// --------------------------------------------------------------------------
// OSI Certified Open Source Software
// --------------------------------------------------------------------------
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free 
// Software Foundation; either version 2 of the License, or (at your option) 
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for 
// more details.
//
// You should have received a copy of the GNU General Public License along 
// with this program; if not, write to the Free Software Foundation, Inc., 
// 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
// --------------------------------------------------------------------------


#import "TimeController.h"


@implementation TimeController
@synthesize time;
@synthesize day;

- (id)init {
   [super init];
   time = 0;
   day = 0;
   tickListeners = [NSMutableArray array];
   alarmListeners = [NSMutableDictionary dictionary];
   return self;
} // end-constructor

- (id)initWithTickListeners:(NSArray *)ticks
      andWithAlarmListeners:(NSMutableDictionary *)alarms {
   [super init];
   time = 0;
   day = 0;
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
      // Activate the alarms, if any
      if ((alarms=[alarmListeners objectForKey:[NSNumber numberWithInt:time]])!=nil) {
         for(i=0;i<[alarms count];i++) {
            [[alarms objectAtIndex:i] activateAlarm:time];
         } // end-for
      } // end-if
      
      // Call the tick listeners
      for(i=0;i<[tickListeners count];i++) {
         [[tickListeners objectAtIndex:i] activateTick:time];
      } // end-for
      
      time++;
   } // end-while
   
   // The simulation has completed.
   
} // end-method

- (void)removeAllListeners {
   tickListeners = [NSMutableArray array];
   alarmListeners = [NSMutableDictionary dictionary];   
} // end-method

- (void)reset {
   time = 0;
   day++;
} // end-method

@end
