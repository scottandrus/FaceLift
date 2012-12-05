//
//  FLProfileViewController.m
//  FaceLift
//
//  Created by Scott Andrus on 12/2/12.
//
//

#import "FLProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+i7HexColor.h"
#import "UIView+Frame.h"
#import "SAViewManipulator.h"
#import "UIImageView+AFNetworking.h"

@interface FLProfileViewController ()

@end

@implementation FLProfileViewController

#pragma mark - View Lifecycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self populateUserInfo];
    [self customizeUserInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfilePictureImageView:nil];
    [self setNameLabel:nil];
    [self setBackgroundView:nil];
    [self setMatchButton:nil];
    [self setFbButton:nil];
    [self setCoverPhotoImageView:nil];
    [super viewDidUnload];
}

#pragma mark - Instance methods

- (void)customizeUserInterface {
    [SAViewManipulator setGradientBackgroundImageForView:self.backgroundView withTopColor:[UIColor colorWithHexString:@"F0F0F0"] andBottomColor:[UIColor colorWithHexString:@"C9C9C9"]];
    
    // Customize buttons
    [SAViewManipulator setGradientBackgroundImageForView:self.matchButton withTopColor:[UIColor colorWithHexString:@"FFA81C"] andBottomColor:[UIColor colorWithHexString:@"FF7B1C"]];
    [SAViewManipulator addBorderToView:self.matchButton withWidth:.5 color:[UIColor blackColor] andRadius:10];
    self.matchButton.clipsToBounds = YES;
    
    [SAViewManipulator setGradientBackgroundImageForView:self.fbButton withTopColor:[UIColor colorWithRed:0.11 green:0.188 blue:0.427 alpha:1] /*#1c306d*/ andBottomColor:[UIColor colorWithRed:0.231 green:0.349 blue:0.592 alpha:1] /*#3b5997*/];
    [SAViewManipulator addBorderToView:self.fbButton withWidth:.5 color:[UIColor blackColor] andRadius:10];
    self.fbButton.clipsToBounds = YES;
    
    [SAViewManipulator addBorderToView:self.profilePictureImageView withWidth:.5 color:[UIColor blackColor] andRadius:8];
    
}

- (void)populateUserInfo {
    self.profilePictureImageView.image = self.person.image;
    
    [self.coverPhotoImageView setImageWithURL:self.person.coverUrl];
    
    self.nameLabel.text = self.person.name;
}

#pragma mark - IBActions

- (IBAction)dismissPressed:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)viewFBPressed:(id)sender
{
    NSURL *link = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", self.person.uid]];
    if ([[UIApplication sharedApplication] canOpenURL:link]) {
        [[UIApplication sharedApplication] openURL:link];
    } else {
        link = [NSURL URLWithString:[NSString stringWithFormat:@"http://facebook.com/%@", self.person.uid]];
    }
    
    [[UIApplication sharedApplication] openURL:link];
}
@end
