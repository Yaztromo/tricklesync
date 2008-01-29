//
//  MobileDatabase.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Database.h"
#import "TimerProtocols.h"
#import "GaussianGenerator.h"
#import "User.h"
#import "CostRecorder.h"

@class User;

@interface MobileDatabase : Database <SimulationTickProtocol> {
   User *user;
   GaussianGenerator *rand;
   CostRecorder *cost;
   Database *serverDB;
}
@property(readonly) User *user;
@property(readonly) GaussianGenerator *rand;

- (id)initWithRecordCount:(int)count
                  forUser:(User *)usr
         withCostRecorder:(CostRecorder *)cr
    againstServerDatabase:(Database *)sdb;

- (id)initWithRecords:(NSArray *)recs
              forUser:(User *)usr
     withCostRecorder:(CostRecorder *)cr
againstServerDatabase:(Database *)sdb;

- (void)activateTick:(int)time;

@end
