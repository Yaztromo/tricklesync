//
//  Network.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// A class that represents a network object.
@interface Network : NSObject {
   NSString *networkName;
   double costPerByte;     // Expressed in cents per byte
   double transferRate;    // Expressed in bytes per second
}
@property(readonly) NSString *networkName;
@property(readonly) double costPerByte;
@property(readonly) double transferRate;

- (id)initWithName:(NSString *)name
           andCost:(double)cost
   andTransferRate:(double)rate;

- (int)costToTransfer:(int)bytes;
- (int)timeToTransfer:(int)bytes;

@end
