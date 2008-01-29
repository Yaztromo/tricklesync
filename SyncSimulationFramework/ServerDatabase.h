//
//  ServerDatabase.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/01/19.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Database.h"
#import "ProbabilityController.h"
#import "GaussianGenerator.h"
#import "TimerProtocols.h"

@interface ServerDatabase : Database <SimulationTickProtocol> {
   GaussianGenerator *rand;
   ProbabilityController *poisson;
}

@property(readonly) GaussianGenerator *rand;
@property(readonly) ProbabilityController *poisson;

- (id)initWithRecordCount:(int)count
     andPoissonController:(ProbabilityController *)p;

- (id)initWithRecords:(NSArray *)recs
 andPoissonController:(ProbabilityController *)p;

- (id)initWithRecordCount:(int)count
       withArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals;

- (void)activateTick:(int)time;

@end
