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


#import "DatabaseTests.h"
#import "Database.h"

#include <stdlib.h>

@implementation DatabaseTests

- (void)testDatabaseCreation {
   // Create a database
   int c0 = 25000, c1, i, j, k;
   Database *d1 = [[Database alloc] initWithRecordCount:c0 andAsDatabaseType:DATABASE_TYPE_MOBILE];
   Database *d2;
   NSArray *diffs;
   
   // Ensure the correct number of records were generated
   c1 = [d1 getRecordCount];
   STAssertEquals(c1, c0, @"The number of generated records doesn't match the requested number of records (%d != %d)", c1, c0);
   
   // Ensure all sizes are within the valid range
   for(i=0;i<c0;i++) {
      STAssertTrue([d1 getRecordWithID:i].recordSizeInBytes>0, @"A record was found with a negative size (%d)!", [d1 getRecordWithID:i].recordSizeInBytes);
   } // end-for

   // Copy the database
   d2 = [d1 copy];
   
   // Update some random elements in the copy
   srandom([NSDate timeIntervalSinceReferenceDate]);
   j = (int)(random()/2147483.647);
   for(i=0;i<j;i++) {
      // Pick a random element and update it
      k = (int)(random()/85899.34588);
      while ([d2 getRecordWithID:k].recordVersion>0) {
         // We've already modified this record, so we'll pick again
         k = (int)(random()/85899.34588);
      } // end-while
      
      [[d2 getRecordWithID:k] updateRecord];

      // Ensure the new modification number is one greater than the old modification number
      STAssertEquals([d2 getRecordWithID:k].recordVersion, [d1 getRecordWithID:k].recordVersion+1, @"Record %d did not update correctly (was %d, now %d)", k, [d1 getRecordWithID:k].recordVersion, [d2 getRecordWithID:k].recordVersion);
   } // end-for
   
   // Compare the two databases
   diffs = [d1 compareAgainstDatabase:d2];
   
   // Ensure the number of changes matches our random value
   STAssertEquals((int)[diffs count], j, @"The number of updated records (%d) did not match the number of modifications (%d)", [diffs count], j);

   // Check to see if the data in the records matches that in the original database
   for(Record *r in diffs) {
      STAssertEquals(r.recordID, [d1 getRecordWithID:r.recordID].recordID, @"Record ID mismatch for record ID %d", r.recordID);
      STAssertEquals(r.recordSizeInBytes, [d1 getRecordWithID:r.recordID].recordSizeInBytes, @"Record size mismatch for record ID %d", r.recordID);
      STAssertTrue(r.recordVersion > [d1 getRecordWithID:r.recordID].recordVersion, @"A modified record (ID #%d) has a version number less than its unmodified original!", r.recordID);
   } // end-for
} // end-method

@end
