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
#import "SVProgressHUD.h"
#import "JSSlidingViewController.h"
#import "FLViewController.h"
#import "AppDelegate.h"

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setProfilePictureImageView:nil];
    [self setFbNameLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    }
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Demo Mode";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Logout";
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.shadowColor = [UIColor darkTextColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, 1);
    return cell;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AppDelegate *delegate = (AppDelegate *)self.appDelegate;
        JSSlidingViewController *slidingVC = (JSSlidingViewController *)[delegate viewController];
        
        [slidingVC closeSlider:YES completion:^{
            if ([[delegate frontVC] demoMode]) {
                [delegate frontVC].demoMode = NO;
                [SVProgressHUD showErrorWithStatus:@"Demo Mode deactivated!"];
                
            } else {
                [delegate frontVC].demoMode = YES;
                [SVProgressHUD showSuccessWithStatus:@"Demo Mode activated!"];
            }
            
            
        }];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
