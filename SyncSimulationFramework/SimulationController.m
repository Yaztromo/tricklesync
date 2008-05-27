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


#import "SimulationController.h"

@implementation SimulationController

@synthesize user;
@synthesize timer;
@synthesize cost;
@synthesize protocol;
@synthesize percentComplete;
@synthesize syncLogic;
@synthesize mean;
@synthesize S;

- (id)initWithXMLDocument:(NSXMLDocument *)xmlDoc {
   NSArray *arr, *temp;
   NSMutableArray *locationVects, *nets;
   NSMutableDictionary *networks, *locations;
   NSError *err=nil;
   ServerDatabase *sdb;
   int dbSize = 0;
   NSString *protocolName;
   Class protocolClass;
   
   [super init];
   //NSLog(@"Attempting to initialize with a valid XML document.");
   
   // Start by verifying that this is an etssimulation document
   if (![[[xmlDoc rootElement] name] isEqualToString:@"etssimulation"]) {
      NSLog(@"The document passed is not a valid ETS Simulation document!");
      return nil;
   } // end-if
   
   // ........................................................................................
   
   //NSLog(@"Finding the networks:");
   
   // Find the 'networks' element, and read each 'network' element entry
   arr = [xmlDoc nodesForXPath:@"/etssimulation/networks/network" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find any networks/network elements!");
      return nil;
   } // end-if
   
   networks = [NSMutableDictionary dictionaryWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      [networks setObject: [[Network alloc] initWithName:[[elem attributeForName:@"name"] stringValue] 
                                                 andCost:[[[elem attributeForName:@"cost"] stringValue] doubleValue]
                                         andTransferRate:[[[elem attributeForName:@"xferrate"] stringValue] doubleValue]*1024
                          andProbabilityOfLostConnection:[[[elem attributeForName:@"expecteddisocnnectsperhour"] stringValue] doubleValue]/3600.0]
                   forKey: [[elem attributeForName:@"name"] stringValue]];
      //NSLog(@"   - Got network %@ with cost %@ and transfer rate of %@, and P(lostConnection) %@", [[elem attributeForName:@"name"] stringValue], [[elem attributeForName:@"cost"] stringValue], [[elem attributeForName:@"xferrate"] stringValue], [elem attributeForName:@"expecteddisocnnectsperhour"]);
   } // end-for
   
   // ........................................................................................
   
   // Find the 'locations' element, and read each 'location' element entry
   
   //NSLog(@"Finding the locations:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/locations/location" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find any locations/location elements!");
      return nil;
   } // end-if

   locations = [NSMutableDictionary dictionaryWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      nets = [NSMutableArray array];
      temp = [elem children];
      
      // Read what networks this entry has in it, and add them to the array
      for(NSXMLElement *elem2 in temp) {
         [nets addObject:[networks objectForKey:[elem2 stringValue]]];
      } // end-for
      
      //NSLog(@"   - Got location with name %@ and networks %@", [[elem attributeForName:@"name"] stringValue], nets);
      [locations setObject: [[Location alloc] initWithName:[[elem attributeForName:@"name"] stringValue]
                                               andNetworks:nets]
                    forKey:[[elem attributeForName:@"name"] stringValue]];
   } // end-for
   
   // ........................................................................................
   
   // Find the 'userschedule' element and read each 'entry' element entry
   //NSLog(@"Finding the location change events:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/userschedule/entry" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find any userschedule/entry elements!");
      return nil;
   } // end-if
   
   locationVects = [NSMutableArray arrayWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      //NSLog(@"   - Found event at time %d for location %@", [[[elem attributeForName:@"time"] stringValue] intValue], [[elem attributeForName:@"locname"] stringValue]);
      [locationVects addObject: [[LocationVector alloc] initEntryTime:[[[elem attributeForName:@"time"] stringValue] intValue]
                                                          forLocation:[locations objectForKey:[[elem attributeForName:@"locname"] stringValue]]
                                              andExpectedSyncsPerHour:[[[elem attributeForName:@"expectedsyncs"] stringValue] doubleValue]
                                      andDatabaseModificationsPerHour:[[[elem attributeForName:@"expectedaccesses"] stringValue] doubleValue]]];

       } // end-for
   
   // ........................................................................................
   
   // Find the database element
   // 	<database numrecords="1" arrivalrate="1.0" interval="1.0" maxarrivals="1.0"/>
   //NSLog(@"Finding the database element:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/database" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find the database element!");
      return nil;
   } // end-if   
   
   dbSize = [[[[arr objectAtIndex:0] attributeForName:@"numrecords"] stringValue] intValue];
   //NSLog(@"   - Found database entry with record count %d, arrival rate %f, interval %d, and max arrivals %d.", dbSize, [[[[arr objectAtIndex:0] attributeForName:@"arrivalrate"] stringValue] doubleValue], [[[[arr objectAtIndex:0] attributeForName:@"interval"] stringValue] intValue], [[[[arr objectAtIndex:0] attributeForName:@"maxarrivals"] stringValue] intValue]);
   sdb = [[ServerDatabase alloc] initWithRecordCount:dbSize
                                     withArrivalRate:[[[[arr objectAtIndex:0] attributeForName:@"arrivalrate"] stringValue] doubleValue]/[[[[arr objectAtIndex:0] attributeForName:@"interval"] stringValue] intValue]
                                        withInterval:1
                                      andMaxArrivals:[[[[arr objectAtIndex:0] attributeForName:@"maxarrivals"] stringValue] intValue]];
   
   // ........................................................................................
   
   // Create the cost and user objects
   cost = [[CostRecorder alloc] init];
   user = [[User alloc] initUserWithLocations:locationVects
                          andDatabaseWithSize:dbSize
                             withCostRecorder:cost
                        againstServerDatabase:sdb];
   timer = [[TimeController alloc] init];

   // ........................................................................................
   
   // Initialize the tick listeners
   [timer addTickListener:[user handheldDB]];
   [timer addTickListener:sdb];
   for(LocationVector *locV in locationVects) {
      [timer addAlarmListener:user withFireTime:[locV entryTime]];
   } // end-for
   
   // ........................................................................................
   
   // Find the syncprotocol element
   //NSLog(@"Finding the sync protocol:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/syncprotocol" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find the syncprotocol element!");
      return nil;
   } // end-if
   
   protocolName = [[[arr objectAtIndex:0] attributeForName:@"name"] stringValue];
   //NSLog(@"   - Got sync protocol name: %@", protocolName);
   
   protocolClass = NSClassFromString(protocolName);
   if (protocolClass==nil) {
      NSLog(@"We were unable to find the sync protocol with class name %@!", protocolName);
      return nil;
   } // end-if   

   // ........................................................................................
   
   syncLogic = [[SyncLogicController alloc] initWithUser:user
                                      withServerDatabase:sdb
                                      withTimeController:timer
                                        withCostRecorder:cost];
   
   protocol = [[protocolClass alloc] initWithController:syncLogic
                                      andWithProperties:[arr objectAtIndex:0]];
      
   if(protocol==nil) {
      NSLog(@"We were unable to instantiate the specified sync protocol!");
      return nil;
   } // end-if
   
   mean = [[CostRecorder alloc] init];
   S = [[Degree2Poly alloc] init];
   
   //NSLog(@"Done!");
   
   percentComplete = 0.0;
   return self;
} // end-constructor

- (id)initWithXMLFile:(NSString *)filename {
   NSXMLDocument *xmlDoc;
   NSError *err=nil;
   NSURL *furl = [NSURL fileURLWithPath:filename];
   if (!furl) {
      NSLog(@"Can't create a URL from file %@.", filename);
      return nil;
   }
   xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl
                                                 options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                   error:&err];
   if (xmlDoc == nil) {
      NSLog(@"Unable to load XML document due to %@.", err);
      return nil;
   } else {
      return [self initWithXMLDocument:xmlDoc];
   } // end-if
} // end-constructor

- (void)startSimulatedDay {
   [timer run];
} // end-method

- (void)resetSimulationForNextDay {
   // Hint for Garbage collector
   [[NSGarbageCollector defaultCollector] collectIfNeeded];

   [timer reset];
   [user resetLocationToStart];
   
   yesterday = [cost copy];
} // end-method

- (void)runSimulationFor:(unsigned int)days
          withIterations:(unsigned int)x
            withCallback:(id<SimulationCallbackProtocol>)callback {
   int i, j, k=0;
   CostRecorder *today, *delta;
   CFAbsoluteTime end, start=CFAbsoluteTimeGetCurrent();
   percentComplete = 0.0;

   for(j=0;j<x;j++) {
      for(i=0;i<days;i++) {
         [self resetSimulationForNextDay];
         [self startSimulatedDay];
         k++;
         percentComplete = (double)k /((double)days*x) * 100.0;
         
         // Calculate todays cost
         today = [CostRecorder subtractWithValueA:cost andValueB:yesterday];
         // NSLog(@"The results for day n = %d is %@ (total = %@, yesterday = %@)", i, today, cost, yesterday);
         
         // Update the mean, and S
         delta = [CostRecorder subtractWithValueA:today andValueB:mean];
         [mean add:[delta averageCostOver:k]];
         [S add:[Degree2Poly multiplyCostRecorder:delta withCostRecorder:[today subtract:mean]]];
         
         if (callback!=nil) [callback setPercentCompleted:percentComplete];
      } // end-for
      
      NSLog(@"######################### [ ITERATION %03d COMPLETE ] #########################", j+1);
      // One iteration is complete.  Reset the databases and run the next iteation
      // Firstly, reset the server database, and ensure that all objects which use it are updated to reflect the change
      [syncLogic.serverDatabase generateNewRecordSet];
      
      // Copy the changes into the mobile database
      [user.handheldDB reinitializeRecordsFromServerDB];
      
      // Reset the protocol for th next run.
      [protocol resetProtocolData];
   } // end-for
   
   [S divide:k-1];
   
   end=CFAbsoluteTimeGetCurrent();
   [callback setPercentCompleted:100.0];
   
   CFGregorianUnits units = CFAbsoluteTimeGetDifferenceAsGregorianUnits (end, start, NULL, (kCFGregorianUnitsHours | kCFGregorianUnitsMinutes | kCFGregorianUnitsSeconds));
   NSLog(@"Simulation run covering %d days in %d iterations completed in %02d:%02d:%07.4f with an average cost function %@ (%@), and variance function %@.", days, x, units.hours, units.minutes, units.seconds, [cost averageCostOver:k], mean, S);
} // end-method

@end
