//
//  Location.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "ProbabilityController.h"

@implementation Location
@synthesize locationName;
@synthesize networks;
@synthesize syncRequestArrivalRate;
@synthesize mobileDatabaseModificationRate;

- (id)initWithName:(NSString *)name
       andNetworks:(NSArray *)nets
   andExpectedSyncsPerHour:(int)syncRate 
andDatabaseModificationsPerHour:(int)modRate {
   [super init];
   locationName = name;
   networks = [NSArray arrayWithArray:nets];
   syncRequestArrivalRate = [ProbabilityController bernoulliProbabilityPerSecondFromEventsPerHour:syncRate];
   mobileDatabaseModificationRate = [ProbabilityController bernoulliProbabilityPerSecondFromEventsPerHour:modRate];
   return self;
} // end-initializer

- (Network *)getLeastExpensiveNetwork {
   Network *least = nil;
   
   for(Network *net in networks) {
      if (least == nil) least = net;
      else if ([net costPerByte] < [least costPerByte]) {
         least = net;
      } // end-if
   } // end-for
   
   return least;
} // end-method

- (Network *)getFastestNetwork {
   Network *ret = nil;
   
   for(Network *net in networks) {
      if (ret == nil) ret = net;
      else if ([net transferRate] > [ret transferRate]) {
         ret = net;
      } // end-if
   } // end-for
   
   return ret;
} // end-method

@end
