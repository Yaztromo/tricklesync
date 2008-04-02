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
   int i;
   
   [super init];
   
   for(i=0;i<DAY_DIVISIONS;i++) accessesArray[i]=0;
   lastSyncTime = -1;
   [controller registerHandheldAccessListener:self];
    
   return self;
} // end-constructor

- (void)handheldRecordAccessCallback:(int)recordID {
   accessesArray[recordID/DAY_DIVISIONS]++;
} // end-method

- (NSMutableArray *)getRecordsToSync:(NSArray *)outOfDateRecs {
   // TODO - implement the records to sync retreival system
   return NULL;
} // end-method

- (NSMutableArray *)orderRecordsByPriority:(NSMutableArray *)records {
   [records sortUsingSelector:[Record getComparisonSelector]];
   return records;
} // end-method

- (BOOL)timeForNewSync:(unsigned int)currTime {
   // TODO -- implement me!
   return FALSE;
} // end-method

- (void)activateTick:(int)time {
   NSMutableArray *records;
   if ([self timeForNewSync:time]) {
      [syncController startSynchronizationSessionUsingNetwork:[syncController cheapestNetwork]];
      records = [self orderRecordsByPriority:[self getRecordsToSync:[syncController getModifiedRecordList]]];
      for(Record *rec in records) {
         if(![syncController synchronizeRecord:rec]) break;
      } // end-for
      [syncController endSynchronizationSession];
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   // This adaptor currently isn't using alarms, but this might change in the future.
} // end-method

@end
