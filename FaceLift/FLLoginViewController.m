//
//  FLLoginViewController.m
//  FaceLift
//
//  Created by Lane on 11/8/12.
//
//

#import "FLLoginViewController.h"
#import "AppDelegate.h"
#import "SAViewManipulator.h"
#import "UIColor+i7HexColor.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FLLoginViewController ()

@end

@implementation FLLoginViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:SessionStateChangedNotification
                                               object:nil];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.view withTopColor:[UIColor colorWithHexString:@"F0F0F0"] andBottomColor:[UIColor colorWithHexString:@"C9C9C9"]];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.loginButton withTopColor:[UIColor colorWithRed:0.231 green:0.349 blue:0.592 alpha:1] /*#1c306d*/ andBottomColor:[UIColor colorWithRed:0.11 green:0.188 blue:0.427 alpha:1] /*#3b5997*/]; 
    [SAViewManipulator addBorderToView:self.loginButton withWidth:.5 color:[UIColor blackColor] andRadius:10];
    self.loginButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogin:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithLoginUI:YES];
}

- (void)loginFailed
{
    NSLog(@"Login failed!");
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [super viewDidUnload];
}
@end
