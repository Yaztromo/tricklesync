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


#import "Degree2Poly.h"


@implementation Degree2Poly

@synthesize x_squared;
@synthesize x;
@synthesize constant;

- (id)init {
   return [self initWithFirstTerm:0.0 andSecondTerm:0.0 andConstant:0.0];
} // end-constructor

- (id)initWithFirstTerm:(double)termA
          andSecondTerm:(double)termB
            andConstant:(double)termC {
   [super init];
   x_squared = termA;
   x = termB;
   constant = termC;
   return self;
} // end-constructor

- (id)initFromPolyA:(CostRecorder *)polyA
           andPolyB:(CostRecorder *)polyB {
   return [self initWithFirstTerm:polyA.etherialCost * polyB.etherialCost
                    andSecondTerm:polyA.etherialCost * polyB.realCost + polyB.etherialCost * polyA.realCost
                      andConstant:polyA.realCost * polyB.realCost];
} // end-method

- (void)add:(Degree2Poly *)value {
   x_squared+=value.x_squared;
   x+=value.x;
   constant+=value.constant;
} // end-method

- (void)divide:(int)value {
   x_squared/=(double)value;
   x/=(double)value;
   constant/=(double)value;
} // end-method

+ (Degree2Poly *)multiplyCostRecorder:(CostRecorder *)a
                     withCostRecorder:(CostRecorder *)b {
   return [[Degree2Poly alloc] initFromPolyA:a andPolyB:b];
} // end-static-method

- (NSString *)description {
   return [NSString stringWithFormat:@"y=%.3fx^2%+.3fx%+.3f", x_squared, x, constant];
} // end-method

@end
