//
//  SyncController.m
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2008/02/04.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SyncController.h"


@implementation SyncController

@synthesize user;
@synthesize timer;
@synthesize cost;
@synthesize protocol;

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
   NSLog(@"Attempting to initialize with a valid XML document.");
   
   // Start by verifying that this is an etssimulation document
   if (![[[xmlDoc rootElement] name] isEqualToString:@"etssimulation"]) {
      NSLog(@"The document passed is not a valid ETS Simulation document!");
      return nil;
   } // end-if
   
   NSLog(@"Finding the networks:");
   
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
                                         andTransferRate:[[[elem attributeForName:@"xferrate"] stringValue] doubleValue]]
                   forKey: [[elem attributeForName:@"name"] stringValue]];
      NSLog(@"   - Got network %@ with cost %@ and transfer rate of %@", [[elem attributeForName:@"name"] stringValue], [[elem attributeForName:@"cost"] stringValue], [[elem attributeForName:@"xferrate"] stringValue]);
   } // end-for
   
   // Find the 'locations' element, and read each 'location' element entry
   
   NSLog(@"Finding the locations:");
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
      
      NSLog(@"   - Got location with name %@ and networks %@ and expected syncs %@ and modrate %@", [[elem attributeForName:@"name"] stringValue], nets, [[elem attributeForName:@"expectedsyncs"] stringValue], [[elem attributeForName:@"expectedaccesses"] stringValue]);
      [locations setObject: [[Location alloc] initWithName:[[elem attributeForName:@"name"] stringValue]
                                               andNetworks:nets 
                                   andExpectedSyncsPerHour:[[[elem attributeForName:@"expectedsyncs"] stringValue] intValue]
                           andDatabaseModificationsPerHour:[[[elem attributeForName:@"expectedaccesses"] stringValue] intValue]]
                    forKey:[[elem attributeForName:@"name"] stringValue]];
   } // end-for
   
   // Find the 'userschedule' element and read each 'entry' element entry
   NSLog(@"Finding the location change events:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/userschedule/entry" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find any userschedule/entry elements!");
      return nil;
   } // end-if
   
   locationVects = [NSMutableArray arrayWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      NSLog(@"   - Found event at time %d for location %@", [[[elem attributeForName:@"time"] stringValue] intValue], [[elem attributeForName:@"locname"] stringValue]);
      [locationVects addObject: [[LocationVector alloc] initEntryTime:[[[elem attributeForName:@"time"] stringValue] intValue]
                                                          forLocation:[locations objectForKey:[[elem attributeForName:@"locname"] stringValue]]]];
       } // end-for
   
   // Find the database element
   // 	<database numrecords="1" arrivalrate="1.0" interval="1.0" maxarrivals="1.0"/>
   NSLog(@"Finding the database element:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/database" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find the database element!");
      return nil;
   } // end-if   
   
   dbSize = [[[[arr objectAtIndex:0] attributeForName:@"numrecords"] stringValue] intValue];
   NSLog(@"   - Found database entry with record count %d, arrival rate %f, interval %d, and max arrivals %d.", dbSize, [[[[arr objectAtIndex:0] attributeForName:@"arrivalrate"] stringValue] doubleValue], [[[[arr objectAtIndex:0] attributeForName:@"interval"] stringValue] intValue], [[[[arr objectAtIndex:0] attributeForName:@"maxarrivals"] stringValue] intValue]);
   sdb = [[ServerDatabase alloc] initWithRecordCount:dbSize
                                     withArrivalRate:[[[[arr objectAtIndex:0] attributeForName:@"arrivalrate"] stringValue] doubleValue] 
                                        withInterval:[[[[arr objectAtIndex:0] attributeForName:@"interval"] stringValue] intValue]
                                      andMaxArrivals:[[[[arr objectAtIndex:0] attributeForName:@"maxarrivals"] stringValue] intValue]];
   
   // Create the cost and user objects
   cost = [[CostRecorder alloc] init];
   user = [[User alloc] initUserWithLocations:locationVects
                          andDatabaseWithSize:dbSize
                             withCostRecorder:cost
                        againstServerDatabase:sdb];
   timer = [[TimeController alloc] init];
   
   // Find the syncprotocol element
   NSLog(@"Finding the sync protocol:");
   arr = [xmlDoc nodesForXPath:@"/etssimulation/syncprotocol" error:&err];
   if (arr==nil) {
      NSLog(@"We were unable to find the syncprotocol element!");
      return nil;
   } // end-if
   
   protocolName = [[[arr objectAtIndex:0] attributeForName:@"name"] stringValue];
   NSLog(@"   - Got sync protocol name: %@", protocolName);
   
   protocolClass = NSClassFromString(protocolName);
   if (protocolClass==nil) {
      NSLog(@"We were unable to find the sync protocol with class name %@!", protocolName);
      return nil;
   } // end-if   
   
   protocol = [[protocolClass alloc] initWithUser:user
                               withServerDatabase:sdb
                               withTimeController:timer
                                 withCostRecorder:cost
                                andWithProperties:[arr objectAtIndex:0]];   

   if(protocol==nil) {
      NSLog(@"We were unable to instantiate the specified sync protocol!");
      return nil;
   } // end-if
   
   NSLog(@"Done!");
   return self;
} // end-constructor

- (id)initWithXMLFile:(NSString *)filename {
   NSXMLDocument *xmlDoc;
   NSError *err=nil;
   NSURL *furl = [NSURL fileURLWithPath:filename];
   if (!furl) {
      NSLog(@"Can't create an URL from file %@.", filename);
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

- (void)startSimulation {
   [timer run];
} // end-constructor

@end
