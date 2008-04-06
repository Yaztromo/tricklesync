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


#import "SlowSyncAdaptor.h"


@implementation SlowSyncAdaptor
-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement {
   [super init];
   syncController = controller;
   rand = [[GaussianGenerator alloc] init];
   
   // Register ourselves as a tick listener
   [syncController.timeController addTickListener:self];
   
   // Nothing to parse for the XML
   return self;
} // end-constructor

- (void)activateTick:(int)time {
   BOOL b;
   NSArray *modifiedRecs;
   
   // Determine if we should synchronize during this tick.
   if ([[syncController.user getCurrentLocation] syncRequestArrivalRate]!=0.0 && 
       [rand getNextRandom] < [[syncController.user getCurrentLocation] syncRequestArrivalRate]) {
   
      // Start the synchronization session, choosing the least expensive network currently available
      if(![syncController startSynchronizationSessionUsingNetwork:[syncController cheapestNetwork]]) return;
      
      // Get the modified records list, so we know which records to transmit twice
      modifiedRecs = [syncController getModifiedRecordList];
   
      // If so, synchronize all the records, one at a time
      for(Record *rec in syncController.user.handheldDB.records) {
         b = [syncController synchronizeRecord:rec];
         if (!b) break;
         if ([modifiedRecs containsObject:rec]) {
            b = [syncController synchronizeRecord:rec];
            if (!b) break;
         } // end-if
      } // end-for
      
      // Finalize the synchronization
      [syncController endSynchronizationSession];
      
      // Done!
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   // This adaptor doesn't process alarms, so do nothing.
} // end-method

- (void)handheldRecordAccessCallback:(int)recordID atTime:(int)t {
   // This adaptor doesn't require record access callbacks.
} // end-method

@end
