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


#import "GaussianGenerator.h"
#include <stdlib.h>
#include <math.h>
#include <mtwist.h>


@implementation GaussianGenerator
- (id)initWithSeed:(unsigned long)seed {
   [super init];
   haveNextNextGaussian = FALSE;
   nextNextGaussian = 0.0;
   mt_goodseed();
   return self;
} // end-initializer

- (id)init {
   return [self initWithSeed:[NSDate timeIntervalSinceReferenceDate]];
} // end-initilizer

- (double)getNextRandom {
   return mt_ldrand();
} // end-initializer

- (double)nextGaussian {
   double v1, v2, s, r1, r2;

   if (haveNextNextGaussian) {
      haveNextNextGaussian = FALSE;
      return nextNextGaussian;
   } else {
      do { 
         r1 = [self getNextRandom];
         r2 = [self getNextRandom];
         
         if (r1<-1.0 || r1>1.0) {
            NSLog(@"The algorithm returned a value for R1 of %.8lf", r1);
         } // end-if
         
         if (r2<-1.0 || r2>1.0) {
            NSLog(@"The algorithm returned a value for R2 of %.8lf", r2);
         } // end-if
         
         v1 = 2 * r1 - 1;   // between -1.0 and 1.0
         v2 = 2 * r2 - 1;   // between -1.0 and 1.0
         s = v1 * v1 + v2 * v2;
      } while (s >= 1 || s == 0);
      double multiplier = sqrt(-2 * log(s)/s);
      nextNextGaussian = v2 * multiplier;
      haveNextNextGaussian = true;
      return v1 * multiplier;
   }
} // end-method

+ (double)calculateNormalProbabilityWith:(double)x {
   return 1.0/2.0*(1.0+erf(x/M_SQRT2));
} // end-method

+ (double)calculateNormalProbabilityForValue:(unsigned int)x
                     inRangeWithMaximumValue:(unsigned int)max {
   // First we need to scale the range down so that it fits within -5..+5.
   double value;
   
   value = x - max/2;         // Puts the value into the range -(max/2)..+(max/2)
   value/=((double)max/10);   // Scales it down to within the range -5..+5 ((max/2)/5)
   
   return [GaussianGenerator calculateNormalProbabilityWith:value];
} // end-method

@end
