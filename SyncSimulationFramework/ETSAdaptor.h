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
#import "SyncProtocol.h"
#import "ServerDatabase.h"
#import "TimeController.h"
#import "CostRecorder.h"
#import "SyncLogicController.h"
#import "GaussianGenerator.h"

#define DAY_DIVISIONS 96

@interface ETSAdaptor : NSObject <SyncProtocol> {
   SyncLogicController *syncController;
   GaussianGenerator *rand;
   unsigned int accessesArray[DAY_DIVISIONS];
   unsigned int lastSyncTime;
   unsigned int k;
}

-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement;

- (void)activateTick:(int)time;
- (void)activateAlarm:(int)time;
- (void)handheldRecordAccessCallback:(int)recordID;

@end
