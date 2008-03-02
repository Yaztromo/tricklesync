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

#import "Network.h"


@implementation Network
@synthesize networkName;
@synthesize costPerByte;
@synthesize transferRate;
@synthesize probabilityOfLostConnection;

- (id)initWithName:(NSString *)name
           andCost:(double)cost
   andTransferRate:(double)rate
andProbabilityOfLostConnection:(double)prob {

   [super init];
   
   networkName = name;
   costPerByte = cost;
   transferRate = rate;
   probabilityOfLostConnection = prob;

   return self;
} // end-initializer

- (double)costToTransfer:(int)bytes {
   return bytes*costPerByte;
} // end-method

- (double)timeToTransfer:(int)bytes {
   return ((double)bytes)*(1.0/transferRate);
} // end-method

- (double)costToTransferRecord:(Record *)r {
   return [self costToTransfer:[r recordSizeInBytes]];
} // end-method

- (double)timeToTransferRecord:(Record *)r {
   return [self timeToTransfer:[r recordSizeInBytes]];   
} // end-method

- (NSString *)description {
   return [NSString stringWithFormat:@"This is the network object with name \"%@\", cost per byte %f and transfer rate %f", networkName, costPerByte, transferRate];
} // end-method

@end
