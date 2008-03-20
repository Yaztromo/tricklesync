#import "Simulation.h"

@implementation Simulation

@synthesize syncController;

- (id)init {
   [super init];
   syncController = nil;
   disabledGrey = [NSColor colorWithDeviceWhite:76.0/256.0 alpha:1.0];
   enabledBlack = [NSColor blackColor];
   return self;
} // end-constructor

- (IBAction)openFile:(id)sender {
   NSMutableArray *types = [NSMutableArray arrayWithObject:@"xml"];
   NSOpenPanel *openPanel = [NSOpenPanel openPanel];
   [openPanel setCanChooseDirectories:FALSE];
   [openPanel setCanChooseFiles:TRUE];
   [openPanel setAllowsMultipleSelection:FALSE];
   
   if ([openPanel runModalForTypes:types]==NSOKButton) {
      syncController = [[SimulationController alloc] initWithXMLFile:[openPanel filename]];
   } else {
      return;
   } // end-if
   
   if (syncController!=nil) {
      // Disable the Step 1 controls
      [openButton setEnabled:FALSE];
      [step1Header setTextColor:disabledGrey];
      [step1Description setTextColor:disabledGrey];

      // Enable all the disabled Step 2 and 3 controls
      [daysField setEnabled:TRUE];
      [stepper setEnabled:TRUE];
      [iterationsField setEnabled:TRUE];
      [stepperB setEnabled:TRUE];
      [startButton setEnabled:TRUE];
      [step2Header setTextColor:enabledBlack];
      [step2Description setTextColor:enabledBlack];
      [step2DescriptionB setTextColor:enabledBlack];
      
      [step3Header setTextColor:enabledBlack];
      [step3Description setTextColor:enabledBlack];
      [step3ProgressDescription setTextColor:enabledBlack];
   } // end-if
} // end-method

- (IBAction)startSimulation:(id)sender {
   CostRecorder *cost;

   // Disable Step 2
   [step2Header setTextColor:disabledGrey];
   [step2Description setTextColor:disabledGrey];   
   [step2DescriptionB setTextColor:disabledGrey];   
   [startButton setEnabled:FALSE];
   [daysField setEnabled:FALSE];
   [stepper setEnabled:FALSE];
   [iterationsField setEnabled:FALSE];
   [stepperB setEnabled:FALSE];
   [step2Header displayIfNeeded];
   [step2Description displayIfNeeded];
   [startButton displayIfNeeded];
   [daysField displayIfNeeded];
   [stepper displayIfNeeded];
   [step2DescriptionB displayIfNeeded];
   [iterationsField displayIfNeeded];
   [stepperB displayIfNeeded];
   
   [progressBar setUsesThreadedAnimation:TRUE];
   
   // Start the simulator
   [syncController runSimulationFor:[daysField intValue] withIterations:[iterationsField intValue] withCallback:self];

   // Disable all the Step 3 controls, and enable the step 4 controls
   [step3Header setTextColor:disabledGrey];
   [step3Description setTextColor:disabledGrey];
   [step3ProgressDescription setTextColor:disabledGrey];
   
   [step4Header setTextColor:enabledBlack];
   [step4Description setTextColor:enabledBlack];
   [resultBox setTextColor:enabledBlack];
   [dataResultDescription setTextColor:enabledBlack];
   [dataResultBox setTextColor:enabledBlack];
   [step4VarianceLabel setTextColor:enabledBlack];
   [step4Variance setTextColor:enabledBlack];
   
   // Set the results
   [resultBox setEnabled:TRUE];
   
   NSBeep();
   cost = [[syncController cost] averageCostOver:[daysField intValue]*[iterationsField intValue]];
   [resultBox setStringValue:[cost description]];
   [step4Variance setStringValue:[syncController.S description]];
   [dataResultBox setStringValue:[NSString stringWithFormat:@"%0.3f KB", [cost kilobytesTransferred]]];
} // end-method

- (void)setPercentCompleted:(double)value {
   [progressBar setDoubleValue:value];
   [progressBar displayIfNeeded];
} // end-method

@end
