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


#import <Cocoa/Cocoa.h>
#import "TimerProtocols.h"

#define SECONDS_PER_DAY 24*60*60

@interface TimeController : NSObject {
   unsigned int time;
   unsigned int day;
   NSMutableArray *tickListeners;         // A simple array of objects that need to be alerted during every tick.
   NSMutableDictionary *alarmListeners;   // An array of items that need to be alerted at a specific time.
                                          // Note that this is a dictionary of arrays, to permit more than one
                                          // class to have an alarm at the same time.
}
@property(readonly) unsigned int time;
@property(readonly) unsigned int day;

- (id)init;

- (id)initWithTickListeners:(NSArray *)ticks
      andWithAlarmListeners:(NSMutableDictionary *)alarms;

- (void)addTickListener:(id <SimulationTickProtocol>)tl;

- (void)addAlarmListener:(id <SimulationAlarmProtocol>)al
            withFireTime:(unsigned int)time;

- (void)removeAllListeners;

- (void)run;

- (void)reset;

@end
