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


#import <Cocoa/Cocoa.h>
#import "Record.h"

#define DATABASE_TYPE_SERVER 0
#define DATABASE_TYPE_MOBILE 1

@interface Database : NSObject <NSCopying> {
   NSArray *records;
   unsigned int databaseType;
}
@property(readonly) unsigned int databaseType;
@property(readonly) NSArray *records;

- (id)initWithRecordCount:(int)count
        andAsDatabaseType:(unsigned int)type;

- (id)initWithRecords:(NSArray *)recs
    andAsDatabaseType:(unsigned int)type;

// The following method returns all records in db that are a newer revision than in self.
- (NSArray *)compareAgainstDatabase:(Database *)db;
- (Record *)getRecordWithID:(int)idNum;
- (int)getRecordCount;

@end
