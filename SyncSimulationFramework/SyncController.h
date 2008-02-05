//
//  SyncController.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MobileDatabase.h"
#import "ServerDatabase.h"
#import "LocationVector.h"
#import "TimerProtocols.h"
#import "Network.h"
#import "Location.h"
#import "Record.h"
#import "Database.h"
#import "CostRecorder.h"
#import "User.h"
#import "TimeController.h"
#import "SyncProtocol.h"

@interface SyncController : NSObject {
   User * user;                  // Holds a handle to the synchronization user
   TimeController *timer;        // Holds a handle to the time controller
   CostRecorder *cost;           // Holds a handle to the cost recorder
   id<SyncProtocol> protocol;    // Holds a handle to the sync protocol
}
@property(readonly) User * user;
@property(readonly) TimeController *timer;
@property(readonly) CostRecorder *cost;
@property(readonly) id<SyncProtocol> protocol; 


- (id)initWithXMLDocument:(NSXMLDocument *)xmlDoc;
- (id)initWithXMLFile:(NSString *)filename;

- (void)startSimulation;

@end
