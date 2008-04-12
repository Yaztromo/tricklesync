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


#import "ETSAdaptor.h"


@implementation ETSAdaptor
-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement {
   int i, j;
   
   [super init];
   
   for(i=0;i<DAY_DIVISIONS;i++) syncsArray[i]=FALSE;
   
   for(j=0;j<SYNC_TRACKING_DAYS;j++) {
      for(i=0;i<DAY_DIVISIONS;i++) {
         accessesArray[j][i]=0;
      } // end-for
   } // end-for
   
   lastSyncTime = -1;
   [controller registerHandheldAccessListener:self];
   [controller.timeController addAlarmListener:self withFireTime:0];
   currentDivisionAccesses = 0;
   
   // Add the alarm listeners for the end-of-division maintenence
   for(i=0;i<SECONDS_PER_DAY;i+=DAY_DIVISION_DURATION) {
      [controller.timeController addAlarmListener:self withFireTime:i];
   } // end-for
   
   syncController = controller;
       
   // Lastly, we should parse out the value for k from the XML properties
   k = [[[syncProtocolElement attributeForName:@"k"] stringValue] doubleValue];
   NSLog(@"*** k = %0.4f", k);
   
   return self;
} // end-constructor

- (int)divisionIndexForTime:(int)time {
   return time/(SECONDS_PER_DAY/DAY_DIVISIONS);
} // end-method

- (void)handheldRecordAccessCallback:(int)recordID atTime:(int)t {
   currentDivisionAccesses++;
} // end-method

- (NSMutableArray *)getRecordsToSync:(NSArray *)outOfDateRecs {
   // TODO - implement the records to sync retreival system
   // Run through all the records, and remove the ones which don't satisfy the cost equation.
   NSMutableArray *records = [NSMutableArray arrayWithArray:outOfDateRecs];
   for(Record *rec in records) {
      if ([syncController costToTransfer:rec]>=(rec.probability * k 
                                               * ([syncController getServerDBVersionForRecord:rec] - rec.recordVersion))) {
         // Remove the record from the array
         [records removeObject:rec];
      } // end-if
      
   } // end-for
   return records;
} // end-method

- (NSMutableArray *)orderRecordsByPriority:(NSMutableArray *)records {
   [records sortUsingSelector:[Record getComparisonSelector]];
   return records;
} // end-method

- (BOOL)timeForNewSync:(unsigned int)currTime {
   // If we've already synchronized during this interval, don't do so again.
   if (syncsArray[[self divisionIndexForTime:currTime]]) return FALSE;
   
   // TODO -- implement me!
   return FALSE;
} // end-method

- (void)activateTick:(int)time {
   NSMutableArray *records;
   if ([self timeForNewSync:time]) {
      if (![syncController startSynchronizationSessionUsingNetwork:[syncController cheapestNetwork]]) return;
      records = [self orderRecordsByPriority:[self getRecordsToSync:[syncController getModifiedRecordList]]];
      for(Record *rec in records) {
         if(![syncController synchronizeRecord:rec]) break;
      } // end-for
      [syncController endSynchronizationSession];
      lastSyncTime = syncController.timeController.day *SECONDS_PER_DAY + syncController.timeController.time;
      syncsArray[[self divisionIndexForTime:time]] = TRUE;
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   int i;
   if (time==0) { // Midnight
      for(i=0;i<DAY_DIVISIONS;i++) {
         syncsArray[i]=FALSE;
      } // end-if
   } // end-if
   
   if (time%DAY_DIVISION_DURATION==0) {
      // End of division maintenence -- move the currentDivisionAccesses into the current position in the array, and then set it back to zero
      // for the next division
      if (time==0) {
         // We need to do this maintenence for the last division of the previous day, if there is one
         if (syncController.timeController.day!=0) {
            accessesArray[(syncController.timeController.day-1)%SYNC_TRACKING_DAYS][[self divisionIndexForTime:SECONDS_PER_DAY-1]]=currentDivisionAccesses;
         } // end-if
      } else {
         accessesArray[syncController.timeController.day%SYNC_TRACKING_DAYS][[self divisionIndexForTime:time-1]]=currentDivisionAccesses;
      } // end-if
      currentDivisionAccesses = 0;
   } // end-if
} // end-method

@end
