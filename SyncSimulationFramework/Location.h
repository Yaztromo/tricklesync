//
//  Location.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Network.h"

@interface Location : NSObject {
   NSString *locationName;
   NSArray *networks;
   double syncRequestArrivalRate;         // as expected number of synchronizations per second
   double mobileDatabaseModificationRate; // as probability of record modification per second
}
@property(readonly) NSString *locationName;
@property(readonly) NSArray *networks;
@property(readonly) double syncRequestArrivalRate;
@property(readonly) double mobileDatabaseModificationRate;

- (id)initWithName:(NSString *)name
       andNetworks:(NSArray *)nets
   andExpectedSyncsPerHour:(int)syncRate
   andDatabaseModificationsPerHour:(int)modRate;

- (Network *)getLeastExpensiveNetwork;
- (Network *)getFastestNetwork;

@end
