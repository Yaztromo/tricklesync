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
#import "SyncProtocol.h"
#import "ServerDatabase.h"
#import "TimeController.h"
#import "CostRecorder.h"
#import "SyncLogicController.h"
#import "GaussianGenerator.h"
#import "ThresholdPoint.h"
//#import <float.h>

#define DAY_DIVISIONS 96
#define SYNC_TRACKING_DAYS 7
#define DAY_DIVISION_DURATION (SECONDS_PER_DAY/DAY_DIVISIONS)
#define T_UPPER 800000000000000.0
//#define T_UPPER (DBL_MAX/2.0)
#define T_LOWER 0.0

@interface ETSAdaptor : NSObject <SyncProtocol> {
   SyncLogicController *syncController;
   
   unsigned short currentDivisionAccesses;
   unsigned short accessesArray[SYNC_TRACKING_DAYS][DAY_DIVISIONS];
   BOOL syncsArray[DAY_DIVISIONS];
   unsigned int lastSyncTime;
   unsigned int lastAccessTime;
   double k;   // The estimated cost of using an out-of-date record
   
   ThresholdPoint *currentThreshold;
   ThresholdPoint *upperThreshold;
   ThresholdPoint *lowerThreshold;
   unsigned int state;  // A value from [-1..2], where:
                        //    -1 - flag to signify the first run
                        //     0 - flag to signify that we need to evaluate new upper and lower points based on the previous upper/lower results,
                        //         and then run the best of the previous three runs (current, upper, lower)
                        //     1 - flag to signify that we should run the next upper threshold test value
                        //     2 - flag to specify that we should run the next lower threshold test value
   CostRecorder *previousDaysCost;
   unsigned int syncCount;
}

-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement;

- (void)activateTick:(int)time;
- (void)activateAlarm:(int)time;
- (void)handheldRecordAccessCallback:(int)recordID atTime:(int)t;
- (void)resetProtocolData;

@end
