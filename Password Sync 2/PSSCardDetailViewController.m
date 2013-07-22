//
//  PSSCardDetailViewController.m
//  Password Sync 2
//
//  Created by Remy Vanherweghem on 2013-07-22.
//  Copyright (c) 2013 Pumax. All rights reserved.
//

#import "PSSCardDetailViewController.h"
#import "PSSCreditCardVersion.h"

@interface PSSCardDetailViewController ()

@end

@implementation PSSCardDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)textInNotesCell {
    if (self.isPasscodeUnlocked) {
        return self.detailItem.currentVersion.decryptedNote;
    }
    return NSLocalizedString(@"Locked", nil);
}

#pragma mark - UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // If we have bank contact information, return one more
    if (self.detailItem.currentVersion.issuingBank) {
        
    }
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 5;
    } else if (section==1){
        // Note
        return 1;
    }
    
    return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return NSLocalizedString(@"Notes", nil);
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        // Notes
        
        CGSize constraintSize = CGSizeMake(170.f, CGFLOAT_MAX);
        UIFont *theFont  = [UIFont boldSystemFontOfSize:12.0f];
        CGSize theSize = [[self textInNotesCell] sizeWithFont:theFont
                             constrainedToSize:constraintSize
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        
        CGFloat cellheight = theSize.height + 20;
        if (cellheight<44.) {
            return 44.;
        }
        return cellheight;
        
    }
    
    return 44.;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    
    
    if (indexPath.section == 0) {
        // Top level information
        cell = [tableView dequeueReusableCellWithIdentifier:@"leftDetailCell" forIndexPath:indexPath];
        
        PSSCreditCardVersion * version = self.detailItem.currentVersion;
        
        if (self.isPasscodeUnlocked) {
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.accessoryView = nil;
        } else {
            cell.accessoryView = [self lockedImageAccessoryView];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = NSLocalizedString(@"Locked", nil);
        }
        
        switch (indexPath.row) {
            case 0:
                // Number
                cell.textLabel.text = NSLocalizedString(@"Number", nil);
                if (self.isPasscodeUnlocked)
                    cell.detailTextLabel.text = version.decryptedNumber;
                else
                    cell.detailTextLabel.text = version.unencryptedLastDigits;
                break;
            
            case 1:
                // Expiration
                cell.textLabel.text = NSLocalizedString(@"Expiration", nil);
                if (self.isPasscodeUnlocked) {
                    cell.detailTextLabel.text = version.decryptedExpiryDate;
                }
                break;
            case 2:
                // CCV
                cell.textLabel.text = NSLocalizedString(@"CCV/CVC2", nil);
                if (self.isPasscodeUnlocked) {
                    cell.detailTextLabel.text = version.decryptedVerificationcode;
                }
                break;
            case 3:
                // Type
                cell.textLabel.text = NSLocalizedString(@"Type", nil);
                if (self.isPasscodeUnlocked) {
                    cell.detailTextLabel.text = @"NULL";
                }
                break;
            case 4:
                // Name on card
                cell.textLabel.text = NSLocalizedString(@"Name on card", nil);
                if (self.isPasscodeUnlocked) {
                    cell.detailTextLabel.text = version.decryptedCardholdersName;
                }
                break;
            default:
                break;
        }
        
        
    } else if (indexPath.section == 1){
        // Notes
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell" forIndexPath:indexPath];
        cell.textLabel.numberOfLines = 0;
        if (self.isPasscodeUnlocked) {
            PSSCreditCardVersion * version = self.detailItem.currentVersion;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryView = nil;
            cell.textLabel.text = version.decryptedNote;
        } else {
            cell.accessoryView = [self lockedImageAccessoryView];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.text = NSLocalizedString(@"Locked", nil);
        }

        
    } else if (indexPath.section == 2) {
        // Emergency information
        
    }
    
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    // Offer different options
    
    
}

@end
