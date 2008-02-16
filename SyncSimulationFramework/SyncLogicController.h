//
//  SyncLogicController.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/16.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"
#import "TimerProtocols.h"
#import "ServerDatabase.h"
#import "TimeController.h"
#import "CostRecorder.h"
#import "Network.h"

@interface SyncLogicController : NSObject {
   User *user;
   ServerDatabase *serverDatabase;
   TimeController *timeController;
   CostRecorder *costRecorder;
   BOOL synchronizing;
   Network *currentNetwork;
   GaussianGenerator *rand;
}
@property(readonly) User *user;
@property(readonly) ServerDatabase *serverDatabase;
@property(readonly) TimeController *timeController;
@property(readonly) CostRecorder *costRecorder;
@property(readonly) BOOL synchronizing;
@property(readonly) Network *currentNetwork;
@property(readonly) GaussianGenerator *rand;

-  (id)initWithUser:(User *)u
 withServerDatabase:(ServerDatabase *)sd
 withTimeController:(TimeController *)tc
   withCostRecorder:(CostRecorder *)cr;

- (NSArray *)getModifiedRecordList;

- (void)startSynchronizationSessionUsingNetwork:(Network *)net;
- (void)endSynchronizationSession;

// Returns TRUE if the record synchronized, FALSE if the connection was lost (or we lacked a connection in the first place).
- (BOOL)synchronizeRecord:(Record *)r;

@end
