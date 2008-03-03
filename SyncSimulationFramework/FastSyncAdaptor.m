//
//  FastSyncAdaptor.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/03/02.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FastSyncAdaptor.h"


@implementation FastSyncAdaptor
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
   
   // Determine if we should synchronize during this tick.
   if ([[syncController.user getCurrentLocation] syncRequestArrivalRate]!=0.0 && 
       [rand getNextRandom] < [[syncController.user getCurrentLocation] syncRequestArrivalRate]) {
      
      // Start the synchronization session, choosing the least expensive network currently available
      [syncController startSynchronizationSessionUsingNetwork:[[[syncController.user getCurrentLocation] location] getLeastExpensiveNetwork]];
      
      // If so, synchronize all the records, one at a time
      for(Record *rec in [syncController getModifiedRecordList]) {
         b = [syncController synchronizeRecord:rec];
         if (!b) break;
      } // end-for
      
      // Finalize the synchronization
      [syncController endSynchronizationSession];
      
      // Done!
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   // This adaptor doesn't process alarms, so do nothing.
} // end-method

@end
