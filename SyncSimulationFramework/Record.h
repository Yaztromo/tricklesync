//
//  Record.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GaussianGenerator.h"

@interface Record : NSObject <NSCopying> {
   int recordID;
   int recordSizeInBytes;
   int recordVersion;
}
@property(readonly) int recordID;
@property(readonly) int recordSizeInBytes;
@property(readonly) int recordVersion;

- (id)initWithID:(int)idNum
        withSize:(int)size;

- (id)initWithID:(int)idNum
usingDistribution:(GaussianGenerator *)dist;

- (void)updateRecord;

@end
