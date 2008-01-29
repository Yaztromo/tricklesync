//
//  Database.h
//  SyncSimulationFramework
//
//  Created by Brad Barclay on 2007/12/08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Record.h"

#define DATABASE_TYPE_SERVER 0
#define DATABASE_TYPE_MOBILE 1

@interface Database : NSObject <NSCopying> {
   NSArray *records;
   unsigned int databaseType;
}
@property(readonly) unsigned int databaseType;

- (id)initWithRecordCount:(int)count
        andAsDatabaseType:(unsigned int)type;

- (id)initWithRecords:(NSArray *)recs
    andAsDatabaseType:(unsigned int)type;

// The following method returns all records in db that are a newer revision than in self.
- (NSArray *)compareAgainstDatabase:(Database *)db;
- (Record *)getRecordWithID:(int)idNum;
- (int)getRecordCount;

@end
