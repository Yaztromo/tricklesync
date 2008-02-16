#import <Cocoa/Cocoa.h>
#import <SyncSimulationFramework/SyncSimulationFramework.h>

@interface SimulationController : NSObject <SimulationCallbackProtocol> {
   SyncController *syncController;
   
   IBOutlet NSTextField *step1Header;
   IBOutlet NSTextField *step2Header;
   IBOutlet NSTextField *step3Header;
   IBOutlet NSTextField *step4Header;

   IBOutlet NSTextField *step1Description;
   IBOutlet NSTextField *step2Description;
   IBOutlet NSTextField *step3Description;
   IBOutlet NSTextField *step4Description;

   IBOutlet NSTextField *step3ProgressDescription;
   IBOutlet NSTextField *resultBox;
   IBOutlet NSTextField *dataResultDescription;
   IBOutlet NSTextField *dataResultBox;

   IBOutlet NSTextField *daysField;
   IBOutlet NSStepper *stepper;
   IBOutlet NSProgressIndicator *progressBar;
   IBOutlet NSButton *startButton;
   IBOutlet NSButton *openButton;
   
   NSColor *disabledGrey;
   NSColor *enabledBlack;
}
@property double progressCompleted;
@property (retain) SyncController *syncController;

- (IBAction)openFile:(id)sender;
- (IBAction)startSimulation:(id)sender;
- (void)setPercentCompleted:(double)value;

@end
