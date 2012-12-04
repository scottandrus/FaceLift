//
//  FLProfileViewController.m
//  FaceLift
//
//  Created by Scott Andrus on 12/2/12.
//
//

#import "FLProfileViewController.h"
#import "SAViewManipulator.h"
#import "UIColor+i7HexColor.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfilePictureImageView:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Instance methods

- (void)customizeUserInterface {
    [SAViewManipulator setGradientBackgroundImageForView:self.view withTopColor:[UIColor colorWithHexString:@"F0F0F0"] andBottomColor:[UIColor colorWithHexString:@"C9C9C9"]];
}

- (void)populateUserInfo {
    self.profilePictureImageView.image = self.person.image;
    self.nameLabel.text = self.person.name;
}

#pragma mark - IBActions

- (IBAction)dismissPressed:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
