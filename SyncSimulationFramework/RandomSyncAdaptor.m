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


#import "RandomSyncAdaptor.h"

@implementation RandomSyncAdaptor
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
   NSMutableArray *recs;
   int k, n, val1=0, val2=0, i;
   id temp;
   BOOL b;
   
   // Determine if we should synchronize during this tick.
   if ([[syncController.user getCurrentLocation] syncRequestArrivalRate]!=0.0 && 
       [rand getNextRandom] < [[syncController.user getCurrentLocation] syncRequestArrivalRate]) {
      
      // Pick a random network k from all currently available networks.
      k = [rand getNextRandom] * ([[[[syncController.user getCurrentLocation] location] networks] count]-1);
      
      if(![syncController startSynchronizationSessionUsingNetwork:[[[[syncController.user getCurrentLocation] location] networks] objectAtIndex:k]]) return;
      
      // Get a copy of all the records on the handheld
      recs = [NSMutableArray arrayWithArray:[[syncController.user handheldDB] records]];
      
      // Select a random number of records (n) to sync
      n = [rand getNextRandom] * [recs count];
   
      // Randomize the records
      for(i=0;i<2*[recs count];i++) {
         // Pick two random numbers between 0 and [recs count]-1, ensuring they are different
         while(val1==val2) {
            val1 = [rand getNextRandom] * ([recs count]-1);
            val2 = [rand getNextRandom] * ([recs count]-1);            
         } // end-while
         
         // Swap these two elements in the array
         temp = [recs objectAtIndex:val2];
         [recs replaceObjectAtIndex:val2 withObject:[recs objectAtIndex:val1]];
         [recs replaceObjectAtIndex:val1 withObject:temp];
         
         // Reset val1 and val2 for the next iteration
         val1=0;val2=0;
      } // end-for
   
      // Synchronize the first n records
      for(i=0;i<n;i++) {
         b = [syncController synchronizeRecord:[recs objectAtIndex:i]];
         if (!b) {
            NSLog(@"The sync was interrupted at record %d!", i);
            break;
         } // end-if
      } // end-for
      
      // Done!
      [syncController endSynchronizationSession];
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   // This adaptor doesn't process alarms, so do nothing.
} // end-method

- (void)handheldRecordAccessCallback:(int)recordID atTime:(int)t {
   // This adaptor doesn't require record access callbacks.
} // end-method

@end
