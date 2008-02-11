/*
 *  SimulationCallbackProtocol.h
 *  SyncSimulationFramework
 *
 *  Created by Brad Barclay on 2008/02/11.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include <Carbon/Carbon.h>

@protocol SimulationCallbackProtocol
- (void)setPercentCompleted:(double)value;
@end
