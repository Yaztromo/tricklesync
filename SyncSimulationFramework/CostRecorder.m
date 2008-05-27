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
@synthesize kilobytesTransferred;

- (id)init {
   [super init];
   realCost = 0.0;
   etherialCost = 0.0;
   kilobytesTransferred = 0.0;
   return self;
} // end-initializer

- (void)incrementRealCostBy:(double)value {
   realCost+=value;
} // end-method

- (void)incrementEtherialCostBy:(double)value {
   etherialCost+=value;
} // end-method

- (CostRecorder *)averageCostOver:(unsigned int)days {
   CostRecorder *ret = [[CostRecorder alloc] init];
   [ret incrementRealCostBy:realCost/days];
   [ret incrementEtherialCostBy:etherialCost/days];
   [ret incrementDataTransferredBy:kilobytesTransferred/days];
   return ret;
} // end-method

- (void)incrementDataTransferredBy:(double)value {
   kilobytesTransferred+=value;
} // end-method

- (NSString *)description {
   return [NSString stringWithFormat:@"y=%.8fx+%.8f", etherialCost, realCost];
} // end-method

- (double)getKilobytesTransferred {
   return kilobytesTransferred;
} // end-method

+ (CostRecorder *)subtractWithValueA:(CostRecorder *)opA
                           andValueB:(CostRecorder *)opB {
   CostRecorder *ret = [[CostRecorder alloc] init];
   ret.realCost = opA.realCost - opB.realCost;
   ret.etherialCost = opA.etherialCost - opB.etherialCost;
   ret.kilobytesTransferred = opA.kilobytesTransferred - opB.kilobytesTransferred;
   return ret;
} // end-static-method

- (id)copyWithZone:(NSZone *)zone {
   CostRecorder *ret = [[CostRecorder allocWithZone:zone] init];
   ret.realCost = realCost;
   ret.etherialCost = etherialCost;
   ret.kilobytesTransferred = kilobytesTransferred;
   return ret;
} // end-method

- (void)add:(CostRecorder *)value {
   realCost+=value.realCost;
   etherialCost+=value.etherialCost;
} // end-method

- (CostRecorder *)subtract:(CostRecorder *)value {
   realCost-=value.realCost;
   etherialCost-=value.etherialCost;
   return self;
} // end-method

- (double)evaluateWith:(double)k {
   return etherialCost*k+realCost;
} // end-method

@end
