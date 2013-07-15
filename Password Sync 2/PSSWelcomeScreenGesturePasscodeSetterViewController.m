//
//  PSSWelcomeScreenGesturePasscodeSetterViewController.m
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-07-03.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import "PSSWelcomeScreenGesturePasscodeSetterViewController.h"
#import "SPLockScreen.h"
#import "PSSPasscodeVerifyerViewController.h"

@interface PSSWelcomeScreenGesturePasscodeSetterViewController ()
@property (weak, nonatomic) IBOutlet SPLockScreen *lockScreen;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIView *lockScreenSubview;
@property (strong) NSString * currentPasscode;
@property PSSGesturePasscodeStatus passcodeStatus;

@end

@implementation PSSWelcomeScreenGesturePasscodeSetterViewController

-(void)savePasscodeAndContinueWithSegue{
    
    PSSPasscodeVerifyerViewController * passcodeVerifyer = [[PSSPasscodeVerifyerViewController alloc] init];
    
    [passcodeVerifyer savePasscode:self.currentPasscode withType:PSSPasscodeTypeGestureBased];
    
    [self performSegueWithIdentifier:@"userFinishedSettingGesturePasscodeSegue" sender:self];
}

-(void)refreshLabel{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.instructionsLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        switch (self.passcodeStatus) {
            case PSSGesturePasscodeStatusUndefined:
                self.instructionsLabel.text = NSLocalizedString(@"Draw your custom gesture pattern", nil);
                break;
            case PSSGesturePasscodeStatusInvalid:
                self.instructionsLabel.text = NSLocalizedString(@"Oops! Your gesture is invalid (repeating circles, overlapping or squiggly lines, too simple gesture, etc). Try again!", nil);
                break;
            case PSSGesturePasscodeStatusNotMatching:
                self.instructionsLabel.text = NSLocalizedString(@"Oops! Your gesture is different this time. Try again from scratch!", nil);
                self.passcodeStatus = PSSGesturePasscodeStatusUndefined;
                self.currentPasscode = nil;
                break;
            case PSSGesturePasscodeStatusValid:
                self.instructionsLabel.text = NSLocalizedString(@"Excellent! Now repeat your gesture!", nil);
                break;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.instructionsLabel setAlpha:1.0];
        }];
        
        
        
    }];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lockScreen.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    SPLockScreen * lockScreen = [[SPLockScreen alloc] initWithFrame:CGRectMake(0, 0, self.lockScreenSubview.frame.size.width, self.lockScreenSubview.frame.size.height)];
    
    [self.lockScreenSubview addSubview:lockScreen];
    
    lockScreen.delegate = self;
    self.lockScreen = lockScreen;
    
}

#pragma mark - LockScreenDelegate

-(void)rejectInvalidPasscode {
    self.passcodeStatus = PSSGesturePasscodeStatusInvalid;
    [self refreshLabel];
}

-(void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber{
    
    // First, let's make sure the pattern number is positive. Negative values are not accepted.
    // We take the long long value as the patterns can be long ass numbers
    if ([patternNumber longLongValue] < 0) {
        [self rejectInvalidPasscode];
        return;
    }
    
    
    // We must parse the chosen passcode to look for repetitions. Theoretically, no number should be repeated.
    NSString * chosenPasscode = [patternNumber stringValue];
    
    NSMutableArray * arrayOfNumbers = [NSMutableArray arrayWithCapacity:[chosenPasscode length]];
    BOOL shouldRejectRepeteaingNumber = NO;
    for (int counter = 0; counter < [chosenPasscode length]; counter++) {
        
        unichar character = [chosenPasscode characterAtIndex:counter];
        NSNumber * numberForCharacter = @(character); // ASCII decimal character (ex.: @"1" = 49)
        
        BOOL alreadyInArray = NO;
        for (NSNumber *number in arrayOfNumbers) {
            if ([number isEqualToNumber:numberForCharacter]) {
                alreadyInArray = YES;
            }
        }
        if (!alreadyInArray) {
            [arrayOfNumbers addObject:numberForCharacter];
        } else {
            shouldRejectRepeteaingNumber = YES;
        }
    }
    
    
    if (shouldRejectRepeteaingNumber) {
        [self rejectInvalidPasscode];
        return;
    }
    
    
    // Now set the passcode
    if (!self.currentPasscode) {
        self.currentPasscode = chosenPasscode;
        self.passcodeStatus = PSSGesturePasscodeStatusValid;
        [self refreshLabel];
    } else {
        if ([chosenPasscode isEqualToString:self.currentPasscode]) {
            
            // We can now proceed, the passcodes are identical!
            
            [self savePasscodeAndContinueWithSegue];
        } else {
            
            self.passcodeStatus = PSSGesturePasscodeStatusNotMatching;
            [self refreshLabel];
            
        }
    }
    
    
    
}

@end