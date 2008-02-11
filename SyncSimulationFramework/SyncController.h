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
#import "MobileDatabase.h"
#import "ServerDatabase.h"
#import "LocationVector.h"
#import "TimerProtocols.h"
#import "Network.h"
#import "Location.h"
#import "Record.h"
#import "Database.h"
#import "CostRecorder.h"
#import "User.h"
#import "TimeController.h"
#import "SyncProtocol.h"

@interface SyncController : NSObject {
   User * user;                  // Holds a handle to the synchronization user
   TimeController *timer;        // Holds a handle to the time controller
   CostRecorder *cost;           // Holds a handle to the cost recorder
   id<SyncProtocol> protocol;    // Holds a handle to the sync protocol
   double percentComplete;
}
@property(readonly) User * user;
@property(readonly) TimeController *timer;
@property(readonly) CostRecorder *cost;
@property(readonly) id<SyncProtocol> protocol;
@property(readonly) double percentComplete;


- (id)initWithXMLDocument:(NSXMLDocument *)xmlDoc;
- (id)initWithXMLFile:(NSString *)filename;

- (void)startSimulatedDay;
- (void)resetSimulationForNextDay;
- (void)runSimulationFor:(unsigned int)days;
@end
