//
//  PSSSettingsTableViewController.m
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-08-14.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import "PSSPasscodeSettingsTableViewController.h"
#import "PSSPasswordSyncOneDataImporter.h"
#import "PSSAppDelegate.h"
#import "Appirater.h"

@interface PSSPasscodeSettingsTableViewController ()

@end

@implementation PSSPasscodeSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.title = NSLocalizedString(@"Settings", nil);
    }
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80.;
    }
    
    return 44.;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedString(@"Passcode", nil);
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        // Checkboxes
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"settingsSubtitleTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (indexPath.section == 0) {
            // Passcode
            
            UISwitch * accessorySwitch = [[UISwitch alloc] init];
            
            cell.accessoryView = accessorySwitch;
            
            if (indexPath.row == 0) {
                // Prompt on launch
                
                if ([[userDefaults objectForKey:PSSUserSettingsPromptForPasscodeAtEveryLaunch] boolValue]) {
                    [accessorySwitch setOn:YES animated:NO];
                } else {
                    [accessorySwitch setOn:NO animated:NO];
                }
                
                [accessorySwitch addTarget:self action:@selector(promptForPasscodeOnLaunchHandler:) forControlEvents:UIControlEventValueChanged];
                
                
                cell.textLabel.text = NSLocalizedString(@"Prompt on launch", nil);
                cell.detailTextLabel.text = NSLocalizedString(@"When on, will ask for a passcode every time the app launches.", nil);
                
            } else if (indexPath.row == 1) {
                
                
                // Prompt for every item
                if ([[userDefaults objectForKey:PSSUserSettingsPromptForPasscodeForEveryUnlockedEntry] boolValue]) {
                    [accessorySwitch setOn:YES animated:NO];
                } else {
                    [accessorySwitch setOn:NO animated:NO];
                }
                
                [accessorySwitch addTarget:self action:@selector(promptForPasscodeOnEveryEntry:) forControlEvents:UIControlEventValueChanged];
                
                
                cell.textLabel.text = NSLocalizedString(@"Prompt for every entry", nil);
                cell.detailTextLabel.text = NSLocalizedString(@"When on, will ask for a passcode for every unlocked website's password, card, location and document.", nil);
                
                
                
            }
            
        }
        
        
        return cell;
        
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISwitch handlers

-(void)promptForPasscodeOnLaunchHandler:(UISwitch*)sender{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:[NSNumber numberWithBool:sender.isOn] forKey:PSSUserSettingsPromptForPasscodeAtEveryLaunch];
    [standardUserDefaults synchronize];
}

-(void)promptForPasscodeOnEveryEntry:(UISwitch*)sender{
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:[NSNumber numberWithBool:sender.isOn] forKey:PSSUserSettingsPromptForPasscodeForEveryUnlockedEntry];
    [standardUserDefaults synchronize];
}

@end