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


#import "Location.h"
#import "ProbabilityController.h"

@implementation Location
@synthesize locationName;
@synthesize networks;

- (id)initWithName:(NSString *)name
       andNetworks:(NSArray *)nets {
   [super init];
   locationName = name;
   networks = [NSArray arrayWithArray:nets];
   return self;
} // end-initializer

- (Network *)getLeastExpensiveNetwork {
   Network *least = nil;
   
   for(Network *net in networks) {
      if (least == nil) least = net;
      else if ([net costPerByte] < [least costPerByte]) {
         least = net;
      } // end-if
   } // end-for
   
   return least;
} // end-method

- (Network *)getFastestNetwork {
   Network *ret = nil;
   
   for(Network *net in networks) {
      if (ret == nil) ret = net;
      else if ([net transferRate] > [ret transferRate]) {
         ret = net;
      } // end-if
   } // end-for
   
   return ret;
} // end-method

- (NSString *)description {
   return locationName;
} // end-method

@end
