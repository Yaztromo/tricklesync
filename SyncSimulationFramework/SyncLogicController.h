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


#import <Cocoa/Cocoa.h>

#import "User.h"
#import "TimerProtocols.h"
#import "ServerDatabase.h"
#import "TimeController.h"
#import "CostRecorder.h"
#import "Network.h"
#import "SyncProtocol.h"

@protocol SyncProtocol;
@class User;

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

- (void)registerHandheldAccessListener:(id<SyncProtocol>)listener;
- (Network *)fastestNetwork;
- (Network *)cheapestNetwork;

@end
