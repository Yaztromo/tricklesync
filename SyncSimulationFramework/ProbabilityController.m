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


#import "ProbabilityController.h"


@implementation ProbabilityController
@synthesize arrivalRate;
@synthesize timeIntervalInSeconds;

+ (double)bernoulliProbabilityPerSecondFromEventsPerHour:(double)ratePerHour {
   return ((double)ratePerHour)/3600.0;  // Divide the hourly rate by the number of seconds in an hour
} // end-method

+ (double)factorial:(long)x {
   int temp = 1, i;
   for(i = x; i > 0; i--)
      temp *= i;
   
   return (double)temp;   
} // end-method

+ (double)poissonProbabilityWithArrivalRate:(double)rate
                           withTimeInterval:(int)t
                       withNumberOfArrivals:(int)n {
   return (pow(rate * t, (double)n) / [ProbabilityController factorial:n]) * exp(-rate * t);
} // end-method

- (id)initWithArrivalRate:(double)rate
             withInterval:(double)interval
           andMaxArrivals:(unsigned int)maxArrivals {
   unsigned int i;
   double next = 0.0;
   NSMutableArray *tempProbabilities = [[NSMutableArray alloc] initWithCapacity:maxArrivals+1];
   
   [super init];
   
   arrivalRate = rate;
   timeIntervalInSeconds = interval;

   for(i=0;i<maxArrivals+1;i++) {
      next += [ProbabilityController poissonProbabilityWithArrivalRate:rate withTimeInterval:interval withNumberOfArrivals:i];
      [tempProbabilities addObject:[[NSNumber alloc] initWithDouble:next]];
   } // end-for
   
   probabilities = [NSArray arrayWithArray:tempProbabilities];
   distController = [[GaussianGenerator alloc] init];
   
   return self;
} // end-initializer

- (unsigned int)getArrivalsSample {
   unsigned int i;
   // Pick a random number
   double rand = [distController getNextRandom];
   
   // Find the last element in the probability array that the random value is strictly less than
   for(i=0;i<[probabilities count];i++) {
      // Return the array index found
      if ([[probabilities objectAtIndex:i] doubleValue]>rand) return i;
   } // end-for

   // We didn't find something bigger than our random number, return the largest possible number of arrivals
   return [probabilities count]-1;
} // end-method

@end
