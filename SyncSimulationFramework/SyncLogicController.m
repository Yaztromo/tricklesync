// --------------------------------------------------------------------------
// The Expedient Trickle Sync Project -- Source File.
// Copyright (c) 2008 Brad BARCLAY <bbarclay@jsyncmanager.org>
// --------------------------------------------------------------------------
// OSI Certified Open Source Software
// --------------------------------------------------------------------------
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free 
// Software Foundation; either version 2 of the License, or (at your option) 
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for 
// more details.
//
// You should have received a copy of the GNU General Public License along 
// with this program; if not, write to the Free Software Foundation, Inc., 
// 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
// --------------------------------------------------------------------------


#import "SyncLogicController.h"
#include <math.h>

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
   noSyncUntilTime = -1;
   noSyncUntilDay = -1;
   syncSessionTime = 0;
   return self;
} // end-constructor

- (NSArray *)getModifiedRecordList {
   if (synchronizing) return [[user handheldDB] compareAgainstDatabase:serverDatabase];
   else return nil;
} // end-method

- (BOOL)startSynchronizationSessionUsingNetwork:(Network *)net {
   // Don't permit the sync if it's too close to a previous sync session, or if the network is nil.
   if(((int)timeController.day<noSyncUntilDay && (int)timeController.time<noSyncUntilTime) || net==nil) return FALSE;
   
   currentNetwork = net;
   synchronizing = TRUE;
   syncSessionTime = 0;
   noSyncUntilTime = -1;
   return TRUE;
} // end-method

- (void)endSynchronizationSession {
   currentNetwork = nil;
   synchronizing = FALSE;
   noSyncUntilTime = timeController.time+(int)ceil(syncSessionTime);
   if (noSyncUntilTime>=86400) {
      noSyncUntilDay = timeController.day+1;
      noSyncUntilTime %=86400;
   } else {
      noSyncUntilDay = timeController.day;
   } // end-if
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
   if ([rand getNextRandom]<probabilityOfLostSync) {
      [self endSynchronizationSession];
      return FALSE;
   } // end-if
   
   // Synchronize the records by updating the handheld record to match the version number of the server record
   // [r updateRecordToRevision:[[serverDatabase getRecordWithID:[r recordID]] recordVersion]];
   
   // Calculate the cost of synchronizing this record and add it to the cost recorder object
   [costRecorder incrementRealCostBy:[currentNetwork costToTransferRecord:r]];
   
   // Update the synchronized record so that it has the same revision number on both the handheld and the server
   [r updateRecordToRevision:[[serverDatabase getRecordWithID:[r recordID]] recordVersion]];
   
   // Add the amount of data transferred to the running total
   [costRecorder incrementDataTransferredBy:r.recordSizeInBytes/1024.0];
   
   // Add the time it took to sync this record to the session time
   syncSessionTime += [currentNetwork timeToTransferRecord:r];
   
   // Return TRUE.
   return TRUE;
} // end-method

- (void)registerHandheldAccessListener:(id<SyncProtocol>)listener {
   [[user handheldDB] registerAccessListener:listener];
} // end-method

- (Network *)fastestNetwork {
   return [[[user getCurrentLocation] location] getFastestNetwork];
} // end-method

- (Network *)cheapestNetwork {
   return [[[user getCurrentLocation] location] getLeastExpensiveNetwork];
} // end-method

- (Network *)mostExpensiveNetwork {
   return [[[user getCurrentLocation] location] getMostExpensiveNetwork];
} // end-method

- (double)costToTransfer:(Record *)rec {
   return [currentNetwork costToTransferRecord:rec];
} // end-method

- (unsigned int)getServerDBVersionForRecord:(Record *)r {
   return [[serverDatabase getRecordWithID:[r recordID]] recordVersion];
} // end-method

@end
