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


#import "ETSAdaptor.h"


@implementation ETSAdaptor
-  (id)initWithController:(SyncLogicController *)controller
        andWithProperties:(NSXMLElement *)syncProtocolElement {
   int i, j;
   
   [super init];
   
   for(i=0;i<DAY_DIVISIONS;i++) syncsArray[i]=FALSE;
   
   for(j=0;j<SYNC_TRACKING_DAYS;j++) {
      for(i=0;i<DAY_DIVISIONS;i++) {
         accessesArray[j][i]=0;
      } // end-for
   } // end-for
   
   lastSyncTime = -1;
   [controller registerHandheldAccessListener:self];
   [controller.timeController addTickListener:self];
   //[controller.timeController addAlarmListener:self withFireTime:0];
   currentDivisionAccesses = 0;
   
   // Add the alarm listeners for the end-of-division maintenence
   for(i=0;i<SECONDS_PER_DAY;i+=DAY_DIVISION_DURATION) {
      [controller.timeController addAlarmListener:self withFireTime:i];
   } // end-for
   
   syncController = controller;
   previousDaysCost = [controller.costRecorder copy];
       
   // Set the threshold point values to some reasonable starting value
   currentThreshold = [[ThresholdPoint alloc] initWithUpperBound:T_UPPER andWithLowerBound:T_LOWER andWithValue:T_UPPER];
   upperThreshold = [currentThreshold getNewUpperThreshold];
   lowerThreshold = [currentThreshold getNewLowerThreshold];
   state = 0;
   //NSLog(@"Initial Threshold Values Selected:\n  Middle (%@)\n  Upper (%@)\n  Lower (%@)\n", currentThreshold, upperThreshold, lowerThreshold);
   syncCount = 0;
   
   // Lastly, we should parse out the value for k from the XML properties
   k = [[[syncProtocolElement attributeForName:@"k"] stringValue] doubleValue];
   //NSLog(@"*** k = %0.4f", k);
   
   return self;
} // end-constructor

- (int)divisionIndexForTime:(int)time {
   return (time/(SECONDS_PER_DAY/DAY_DIVISIONS))%DAY_DIVISIONS;
} // end-method

- (void)handheldRecordAccessCallback:(int)recordID atTime:(int)t {
   currentDivisionAccesses++;
} // end-method

- (NSMutableArray *)getRecordsToSync:(NSArray *)outOfDateRecs {
   // TODO - implement the records to sync retreival system
   // Run through all the records, and remove the ones which don't satisfy the cost equation.
   NSMutableArray *records = [NSMutableArray arrayWithArray:outOfDateRecs];
   NSMutableArray *ret = [NSMutableArray array];
   for(Record *rec in records) {
      if ([syncController costToTransfer:rec],(rec.probability * k 
                                               * ([syncController getServerDBVersionForRecord:rec] - rec.recordVersion))) {
         // Add the record from the return array
         //[records removeObject:rec];
         [ret addObject:rec];
      } // end-if
      
   } // end-for
   return ret;
} // end-method

- (NSMutableArray *)orderRecordsByPriority:(NSMutableArray *)records {
   [records sortUsingSelector:[Record getComparisonSelector]];
   return records;
} // end-method

- (double)probabilityOfUseAtTime:(unsigned int)t {
   int div = [self divisionIndexForTime:t];
   int i, res=0;
   
   for(i=0;i<SYNC_TRACKING_DAYS;i++) {
      if (accessesArray[i][div]>0) res++;
   } // end-for
   
   return (double)res/(double)SYNC_TRACKING_DAYS;
} // end-method

- (BOOL)timeForNewSync:(unsigned int)t {
   ThresholdPoint *testPoint;
   BOOL ret = FALSE;
   
   // If we've already synchronized during this interval, don't do so again.
   if (syncsArray[[self divisionIndexForTime:t]]) {
      return FALSE;
   } // end-if
   
   switch(state) {
      case 0:     testPoint = currentThreshold;
                  break;
      case 1:     testPoint = upperThreshold;
                  break;
      case 2:     testPoint = lowerThreshold;
                  break;
      default:    NSLog(@"Error in state.  State = %d", state);
   } // end-switch
   
   ret = (((8.0/15.0*[self probabilityOfUseAtTime:t+1*DAY_DIVISION_DURATION]
           +4.0/15.0*[self probabilityOfUseAtTime:t+2*DAY_DIVISION_DURATION]
           +2.0/15.0*[self probabilityOfUseAtTime:t+3*DAY_DIVISION_DURATION]
           +1.0/15.0*[self probabilityOfUseAtTime:t+4*DAY_DIVISION_DURATION])
           *((syncController.timeController.day *SECONDS_PER_DAY + t) - lastSyncTime))
          /[[syncController cheapestNetwork] costPerByte]) > testPoint.currentValue;
   
/*   if(ret) {
      // We're going to synchronize -- let's dump out the individual values for verification
      NSLog(@"((%0.3f + %0.3f + %0.3f + %0.3f) * %d) / %0.3f",    (8.0/15.0*[self probabilityOfUseAtTime:t+1*DAY_DIVISION_DURATION]),
                                                                  (4.0/15.0*[self probabilityOfUseAtTime:t+2*DAY_DIVISION_DURATION]),
                                                                  (2.0/15.0*[self probabilityOfUseAtTime:t+3*DAY_DIVISION_DURATION]),
                                                                  (1.0/15.0*[self probabilityOfUseAtTime:t+4*DAY_DIVISION_DURATION]),
                                                                  ((syncController.timeController.day *SECONDS_PER_DAY + t) - lastSyncTime),
                                                                  [[syncController cheapestNetwork] costPerByte]);
      NSLog(@"   = %0.3f / %0.3f",     (8.0/15.0*[self probabilityOfUseAtTime:t+1*DAY_DIVISION_DURATION]) +
                                       (4.0/15.0*[self probabilityOfUseAtTime:t+2*DAY_DIVISION_DURATION]) +
                                       (2.0/15.0*[self probabilityOfUseAtTime:t+3*DAY_DIVISION_DURATION]) +
                                       (1.0/15.0*[self probabilityOfUseAtTime:t+4*DAY_DIVISION_DURATION]) +
                                       ((syncController.timeController.day *SECONDS_PER_DAY + t) - lastSyncTime),
                                       [[syncController cheapestNetwork] costPerByte]);
      NSLog(@"   = %0.3f", (((8.0/15.0*[self probabilityOfUseAtTime:t+1*DAY_DIVISION_DURATION]
                             +4.0/15.0*[self probabilityOfUseAtTime:t+2*DAY_DIVISION_DURATION]
                             +2.0/15.0*[self probabilityOfUseAtTime:t+3*DAY_DIVISION_DURATION]
                             +1.0/15.0*[self probabilityOfUseAtTime:t+4*DAY_DIVISION_DURATION])*((syncController.timeController.day *SECONDS_PER_DAY + t) - lastSyncTime))
                            /[[syncController cheapestNetwork] costPerByte]));
      
                                                            
   } // end-if
*/
   
   return ret;
} // end-method

- (void)activateTick:(int)time {
   NSMutableArray *records;
   BOOL flag = TRUE;
   if ([self timeForNewSync:time]) {
      //NSLog(@"Synchronizing at time %d", time);
      if (![syncController startSynchronizationSessionUsingNetwork:[syncController cheapestNetwork]]) return;
      syncCount++;
      records = [self orderRecordsByPriority:[self getRecordsToSync:[syncController getModifiedRecordList]]];
      for(Record *rec in records) {
         if(![syncController synchronizeRecord:rec]) {
            // The transfer was aborted due to a network disconnection.
            NSLog(@"*** Encountered a network disconnection event!");
            flag = FALSE;
            break;
         } // end-if
      } // end-for
      [syncController endSynchronizationSession];
      lastSyncTime = syncController.timeController.day *SECONDS_PER_DAY + syncController.timeController.time;
      syncsArray[[self divisionIndexForTime:time]] = flag;  // If the sync wasn't successful, we can retry immediately
   } // end-if
} // end-method

- (void)activateAlarm:(int)time {
   int i;
   double Tuppercost, Tlowercost, Tcurrcost;
   if (time==0) { // Midnight
      // Reset the synchronization array
      for(i=0;i<DAY_DIVISIONS;i++) {
         syncsArray[i]=FALSE;
      } // end-if

      // Get the cost of the just ended day (if day > 0) and copy it to the just tested threshold
      //NSLog(@"We synchronized %d times today.", syncCount);
      syncCount = 0;
      
      if (syncController.timeController.day % 3 == 0) {
         switch(state) {
            case 0:
               // When we get here, we have just finished running the current bound.
               state = 1;
               //NSLog(@"===== State is now %d on day %d", state, syncController.timeController.day);
               //NSLog(@"Subtracting costs: (%@, %@)", syncController.costRecorder, previousDaysCost);
               currentThreshold.cost = [CostRecorder subtractWithValueA:syncController.costRecorder andValueB:previousDaysCost];
               //NSLog(@"Current threshold cost is now %@", currentThreshold.cost);
               previousDaysCost = [syncController.costRecorder copy];
               //NSLog(@"Previous Days cost is now %@", previousDaysCost);
               break;
               
            case 1:
               // We get here when we have just completed testing the upper bound.
               state = 2;
               //NSLog(@"===== State is now %d on day %d", state, syncController.timeController.day);
               //NSLog(@"Subtracting costs: (%@, %@)", syncController.costRecorder, previousDaysCost);
               upperThreshold.cost = [CostRecorder subtractWithValueA:syncController.costRecorder andValueB:previousDaysCost];
               //NSLog(@"Upper threshold cost is now %@", upperThreshold.cost);
               previousDaysCost = [syncController.costRecorder copy];
               //NSLog(@"Previous Days cost is now %@", previousDaysCost);
               break;
               
            case 2:
               // We get here whenever we're just finished running the lower threshold.  We need to compare the costs and generate
               // new current, upper, and lower thresholds based on the results.
               state = 0;
               //NSLog(@"===== State is now %d on day %d", state, syncController.timeController.day);

               //NSLog(@"Subtracting costs: (%@, %@)", syncController.costRecorder, previousDaysCost);
               lowerThreshold.cost = [CostRecorder subtractWithValueA:syncController.costRecorder andValueB:previousDaysCost];
               //NSLog(@"Lower threshold cost is now %@", lowerThreshold.cost);
               previousDaysCost = [syncController.costRecorder copy];
               //NSLog(@"Previous Days cost is now %@", previousDaysCost);
               
               Tuppercost = [upperThreshold.cost evaluateWith:k]/3.0;
               Tlowercost = [lowerThreshold.cost evaluateWith:k]/3.0;
               Tcurrcost  = [currentThreshold.cost evaluateWith:k]/3.0;
               
               //NSLog(@"Upper Cost = %0.8f, Lower Cost = %0.8f, Current Cost = %0.8f", Tuppercost, Tlowercost, Tcurrcost);
               //NSLog(@"Upper Cost = %@, , Lower Cost = %@, Current Cost = %@", upperThreshold.cost, lowerThreshold.cost, currentThreshold.cost);
               
               if (Tuppercost < Tcurrcost && Tuppercost < Tlowercost) {
                  // The upper value is lowest
                  //NSLog(@"Selecting upper boundry");
                  currentThreshold = upperThreshold;
                  upperThreshold = [currentThreshold getNewUpperThreshold];
                  lowerThreshold = [currentThreshold getNewLowerThreshold];
               } else if (Tlowercost <= Tcurrcost && Tlowercost <= Tuppercost) {
                  // The lower value is the lowest
                  //NSLog(@"Selecting lower boundry");
                  currentThreshold = lowerThreshold;
                  upperThreshold = [currentThreshold getNewUpperThreshold];
                  lowerThreshold = [currentThreshold getNewLowerThreshold];
               } else {
                  // Tcurrcost must be the lowest.  We'll stick with it, but should scale upper and lower
                  // accordingly so we don't keep testing the same points
                  //NSLog(@"Maintaining current boundry");
                  [currentThreshold reduceBoundsByTenPercent];
                  upperThreshold = [currentThreshold getNewUpperThreshold];
                  lowerThreshold = [currentThreshold getNewLowerThreshold];
               } // end-if
               
               //NSLog(@"New Threshold Values Selected:\n  Middle (%@)\n  Upper (%@)\n  Lower (%@)\n", currentThreshold, upperThreshold, lowerThreshold);
               break;
               
            default:
               // We should never get here!
               NSLog(@"*** Got to default case when it shouldn't be possible.  state = %d", state);
         } // end-switch
      } // end-if
   } // end-if
   
   if (time%DAY_DIVISION_DURATION==0) {
      // End of division maintenence -- move the currentDivisionAccesses into the current position in the array, and then set it back to zero
      // for the next division
      if (time==0) {
         // We need to do this maintenence for the last division of the previous day, if there is one
         if (syncController.timeController.day!=0) {
            accessesArray[(syncController.timeController.day-1)%SYNC_TRACKING_DAYS][[self divisionIndexForTime:SECONDS_PER_DAY-1]]=currentDivisionAccesses;
         } // end-if
      } else {
         accessesArray[syncController.timeController.day%SYNC_TRACKING_DAYS][[self divisionIndexForTime:time-1]]=currentDivisionAccesses;
      } // end-if
      currentDivisionAccesses = 0;
   } // end-if
} // end-method

- (void)resetProtocolData {
   int i, j;
   
   for(i=0;i<DAY_DIVISIONS;i++) syncsArray[i]=FALSE;
   
   for(j=0;j<SYNC_TRACKING_DAYS;j++) {
      for(i=0;i<DAY_DIVISIONS;i++) {
         accessesArray[j][i]=0;
      } // end-for
   } // end-for
   
   lastSyncTime = -1;
   currentDivisionAccesses = 0;
   
   previousDaysCost = [[CostRecorder alloc] init];
   
   // Set the threshold point values to some reasonable starting value
   currentThreshold = [[ThresholdPoint alloc] initWithUpperBound:T_UPPER andWithLowerBound:T_LOWER andWithValue:T_UPPER];
   upperThreshold = [currentThreshold getNewUpperThreshold];
   lowerThreshold = [currentThreshold getNewLowerThreshold];
   state = 0;
   //NSLog(@"Initial Threshold Values Selected:\n  Middle (%@)\n  Upper (%@)\n  Lower (%@)\n", currentThreshold, upperThreshold, lowerThreshold);
   syncCount = 0;   
} // end-method

@end
