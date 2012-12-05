//
//  FLMenuViewController.m
//  FaceLift
//
//  Created by Scott Andrus on 11/15/12.
//
//

#import "FLMenuViewController.h"
#import "SAViewManipulator.h"
#import "UIColor+i7HexColor.h"
#import "UIImageView+AFNetworking.h"

@interface FLMenuViewController ()

@end

@implementation FLMenuViewController

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
    
    [SAViewManipulator setGradientBackgroundImageForView:self.view withTopColor:[UIColor colorWithHexString:@"4F4F4F"] andBottomColor:[UIColor colorWithHexString:@"2B2B2B"]];
    
    // Round the view
    [SAViewManipulator addBorderToView:self.view withWidth:.5 color:[UIColor blackColor] andRadius:10];
    self.view.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfilePictureImageView:nil];
    [self setFbNameLabel:nil];
    [super viewDidUnload];
}

@end
