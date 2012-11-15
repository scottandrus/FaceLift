//
//  FLLoginViewController.m
//  FaceLift
//
//  Created by Lane on 11/8/12.
//
//

#import "FLLoginViewController.h"
#import "AppDelegate.h"
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

@end
