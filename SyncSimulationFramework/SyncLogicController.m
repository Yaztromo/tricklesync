//
//  SyncLogicController.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/16.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SyncLogicController.h"

@implementation SyncLogicController

@synthesize user;
@synthesize serverDatabase;
@synthesize timeController;
@synthesize costRecorder;
@synthesize currentNetwork;
@synthesize rand;
@synthesize synchronizing;

-  (id)initWithUser:(User *)u
 withServerDatabase:(ServerDatabase *)sd
 withTimeController:(TimeController *)tc
   withCostRecorder:(CostRecorder *)cr {
   [super init];
   user = u;
   serverDatabase = sd;
   timeController = tc;
   costRecorder = cr;
   synchronizing = FALSE;
   currentNetwork = nil;
   rand = [[GaussianGenerator alloc] init];
   return self;
} // end-constructor

- (NSArray *)getModifiedRecordList {
   if (synchronizing) return [[user handheldDB] compareAgainstDatabase:serverDatabase];
   else return nil;
} // end-method

- (void)startSynchronizationSessionUsingNetwork:(Network *)net {
   currentNetwork = net;
   synchronizing = TRUE;
} // end-method

- (void)endSynchronizationSession {
   currentNetwork = nil;
   synchronizing = FALSE;
} // end-method

- (BOOL)synchronizeRecord:(Record *)r {
   double syncTime = 0;
   double probabilityOfLostSync = 0;
   
   // Check to see if we are synchronizing
   if (!synchronizing) return FALSE;
   
   // Determine the amount of time required to transmit this record on the current network
   syncTime = [currentNetwork timeToTransferRecord:r];
   
   // Determine the bernoulli probability that we lose connection during the synchronization of this record
   probabilityOfLostSync = [currentNetwork probabilityOfLostConnection] * syncTime;
   
   // Test whether we have lost the connection during the sync of this record -- if we do, return FALSE immediately.
   if ([rand getNextRandom]<probabilityOfLostSync) return FALSE;
   
   // Synchronize the records by updating the handheld record to match the version number of the server record
   [r updateRecordToRevision:[[serverDatabase getRecordWithID:[r recordID]] recordVersion]];
   
   // Calculate the cost of synchronizing this record and add it to the cost recorder object
   [costRecorder incrementRealCostBy:[currentNetwork costToTransferRecord:r]];
   
   // Update the synchronized record so that it has the same revision number on both the handheld and the server
   [[[user handheldDB] getRecordWithID:[r recordID]] updateRecordToRevision:[r recordVersion]];
   
   // Add the amount of data transferred to the running total
   [costRecorder incrementDataTransferredBy:r.recordSizeInBytes/1024.0];
   
   // Return TRUE.
   return TRUE;
} // end-method

@end
