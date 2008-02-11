#import "SimulationController.h"

@implementation SimulationController

@synthesize progressCompleted;
@synthesize syncController;

- (id)init {
   [super init];
   syncController = nil;
   return self;
} // end-constructor

- (IBAction)openFile:(id)sender {
   NSMutableArray *types = [NSMutableArray arrayWithObject:@"xml"];
   NSOpenPanel *openPanel = [NSOpenPanel openPanel];
   [openPanel setCanChooseDirectories:FALSE];
   [openPanel setCanChooseFiles:TRUE];
   [openPanel setAllowsMultipleSelection:FALSE];
   
   if ([openPanel runModalForTypes:types]==NSOKButton) {
      syncController = [[SyncController alloc] initWithXMLFile:[openPanel filename]];
   } else {
      return;
   } // end-if
   
   if (syncController!=nil) {
      // Enable all the disabled Step 2 controls
      [daysField setEnabled:TRUE];
      [stepper setEnabled:TRUE];
      [startButton setEnabled:TRUE];
      [openButton setEnabled:FALSE];
   } // end-if
} // end-method

- (IBAction)startSimulation:(id)sender {
   [startButton setEnabled:FALSE];
   [progressBar setUsesThreadedAnimation:TRUE];
   
   // Start the sumulator
   [syncController runSimulationFor:[daysField intValue] withCallback:self];
   
   // Set the results
   [resultBox setEnabled:TRUE];
   [resultBox setStringValue:[[[syncController cost] averageCostOver:[daysField intValue]] description]];
} // end-method

- (void)setPercentCompleted:(double)value {
   [progressBar setDoubleValue:value];
   [progressBar displayIfNeeded];
} // end-method

@end
