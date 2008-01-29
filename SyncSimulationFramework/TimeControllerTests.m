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
