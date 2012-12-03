//
//  ProfileViewController.m
//  FaceLift
//
//  Created by Scott Andrus on 12/2/12.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    self.profilePictureImageView.image = self.person.image;
    self.nameLabel.text = self.person.name;
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

- (IBAction)dismissPressed:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
