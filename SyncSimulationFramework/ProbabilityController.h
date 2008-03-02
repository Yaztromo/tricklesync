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
#import "GaussianGenerator.h"

@interface ProbabilityController : NSObject {
   double arrivalRate;
   unsigned int timeIntervalInSeconds;
   NSArray *probabilities;
   GaussianGenerator *distController;
}
@property(readonly) double arrivalRate;
@property(readonly) unsigned int timeIntervalInSeconds;

+ (double)bernoulliProbabilityPerSecondFromEventsPerHour:(double)ratePerHour;
+ (double)factorial:(long)x;
+ (double)poissonProbabilityWithArrivalRate:(double)rate
                           withTimeInterval:(int)t
                       withNumberOfArrivals:(int)n;

- (id)initWithArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals;

- (unsigned int)getArrivalsSample;

@end
