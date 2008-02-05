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
   int i=0;
   [super init];
   
   // Start by verifying that this is an etssimulation document
   if (![[[xmlDoc rootElement] name] isEqualToString:@"etssimulation"]) {
      NSLog(@"The document passed is not a valid ETS Simulation document!");
      return nil;
   } // end-if
   
   // Find the 'networks' element, and read each 'network' element entry
   arr = [xmlDoc nodesForXPath:@"/etssimulation/networks/network" error:&err];
   networks = [NSMutableDictionary dictionaryWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      [networks setObject: [[Network alloc] initWithName:[[elem attributeForName:@"name"] stringValue] 
                                                 andCost:[[[elem attributeForName:@"cost"] objectValue] doubleValue]
                                         andTransferRate:[[[elem attributeForName:@"xferrate"] objectValue] doubleValue]]
                   forKey: [[elem attributeForName:@"name"] stringValue]];
   } // end-for
   
   // Find the 'locations' element, and read each 'location' element entry
   arr = [xmlDoc nodesForXPath:@"/etssimulation/locations/location" error:&err];
   locations = [NSMutableDictionary dictionaryWithCapacity:[arr count]];
   for(NSXMLElement *elem in arr) {
      nets = [NSMutableArray array];
      temp = [elem children];
      
      // Read what networks this entry has in it, and add them to the array
      for(NSXMLElement *elem2 in temp) {
         [nets addObject:[networks objectForKey:[elem2 stringValue]]];
      } // end-for
      
      [locations setObject: [[Location alloc] initWithName:[[elem attributeForName:@"name"] stringValue]
                                               andNetworks:nets 
                                   andExpectedSyncsPerHour:[[[elem attributeForName:@"expectedsyncs"] objectValue] intValue]
                           andDatabaseModificationsPerHour:[[[elem attributeForName:@"expectedacesses"] objectValue] intValue]]
                    forKey:[[elem attributeForName:@"name"] stringValue]];
   } // end-for
   
   // Find the 'userschedule' element and read each 'entry' element entry
   
   // Find the database element
   
   // Find the syncprotocol element
   
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
