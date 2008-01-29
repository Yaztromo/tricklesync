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


#import "CostRecorder.h"


@implementation CostRecorder
@synthesize realCost;
@synthesize etherialCost;
@synthesize etherealCostFactor;

- (id)init {
   [super init];
   realCost = 0.0;
   etherialCost = 0.0;
   etherealCostFactor = 1.0;
   return self;
} // end-initializer

- (void)incrementRealCostBy:(double)value {
   realCost+=value;
} // end-method

- (void)incrementEtherialCostBy:(double)value {
   etherialCost+=value;
} // end-method

@end
