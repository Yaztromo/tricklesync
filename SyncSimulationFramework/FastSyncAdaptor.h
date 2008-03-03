//
//  FastSyncAdaptor.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/03/02.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SyncProtocol.h"
#import "ServerDatabase.h"
#import "TimeController.h"
#import "CostRecorder.h"
#import "SyncLogicController.h"
#import "GaussianGenerator.h"

@interface FastSyncAdaptor : NSObject <SyncProtocol> {
   SyncLogicController *syncController;
   GaussianGenerator *rand;
}

-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement;

- (void)activateTick:(int)time;
- (void)activateAlarm:(int)time;

@end
