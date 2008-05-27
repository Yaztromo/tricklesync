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


@interface CostRecorder : NSObject <NSCopying> {
   double realCost;
   double etherialCost;
   double kilobytesTransferred;
}
@property double realCost;
@property double etherialCost;
@property double kilobytesTransferred;

- (id)init;
- (void)incrementRealCostBy:(double)value;
- (void)incrementEtherialCostBy:(double)value;
- (void)incrementDataTransferredBy:(double)value;
- (CostRecorder *)averageCostOver:(unsigned int)days;
- (void)add:(CostRecorder *)value;
- (CostRecorder *)subtract:(CostRecorder *)value;

+ (CostRecorder *)subtractWithValueA:(CostRecorder *)opA
                           andValueB:(CostRecorder *)opB;

- (double)evaluateWith:(double)k;

@end
