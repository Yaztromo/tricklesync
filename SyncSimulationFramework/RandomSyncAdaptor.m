//
//  RandomSyncAdaptor.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/03/02.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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
      
      [syncController startSynchronizationSessionUsingNetwork:[[[[syncController.user getCurrentLocation] location] networks] objectAtIndex:k]];
      
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

@end
