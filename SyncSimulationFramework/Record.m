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


#import "Record.h"

@implementation Record
@synthesize recordID;
@synthesize recordSizeInBytes;
@synthesize recordVersion;

- (id)initWithID:(int)idNum
        withSize:(int)size
     withVersion:(int)version {
   [super init];
   recordID = idNum;
   recordSizeInBytes = size;
   recordVersion = version;
   return self;
} // end-initializer

- (id)initWithID:(int)idNum
        withSize:(int)size {
   return [self initWithID:idNum withSize:size withVersion:0];
} // end-initializer

- (id)initWithID:(int)idNum 
usingDistribution:(GaussianGenerator *)dist {
   // Calculate the size
   int size=([dist nextGaussian]+10)*1024;      // Ramdom size based on a distribution
   return [self initWithID:idNum withSize:size withVersion:0];
} // end-initializer

- (void)updateRecord {
   recordVersion++;
} // end-initializer

- (id)copyWithZone:(NSZone *)zone {
   return [[Record allocWithZone:zone] initWithID:recordID withSize:recordSizeInBytes withVersion:recordVersion];
} // end-method

- (void)updateRecordToRevision:(int)ver {
   recordVersion = ver;
} // end-method

@end
