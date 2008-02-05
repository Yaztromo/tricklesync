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

// A class that represents a network object.
@interface Network : NSObject {
   NSString *networkName;
   double costPerByte;     // Expressed in cents per byte
   double transferRate;    // Expressed in bytes per second
}
@property(readonly) NSString *networkName;
@property(readonly) double costPerByte;
@property(readonly) double transferRate;

- (id)initWithName:(NSString *)name
           andCost:(double)cost
   andTransferRate:(double)rate;

- (int)costToTransfer:(int)bytes;
- (int)timeToTransfer:(int)bytes;
- (NSString *)description;

@end
