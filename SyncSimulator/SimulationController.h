#import <Cocoa/Cocoa.h>
#import <SyncSimulationFramework/SyncSimulationFramework.h>

@interface SimulationController : NSObject <SimulationCallbackProtocol> {
   SyncController *syncController;
   IBOutlet NSTextField *daysField;
   IBOutlet NSStepper *stepper;
   IBOutlet NSProgressIndicator *progressBar;
   IBOutlet NSTextField *resultBox;
   IBOutlet NSButton *startButton;
   IBOutlet NSButton *openButton;
}
@property double progressCompleted;
@property (retain) SyncController *syncController;

- (IBAction)openFile:(id)sender;
- (IBAction)startSimulation:(id)sender;
- (void)setPercentCompleted:(double)value;

@end
