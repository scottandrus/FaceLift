//
//  FLProfileViewController.h
//  FaceLift
//
//  Created by Scott Andrus on 12/2/12.
//
//

#import <UIKit/UIKit.h>

#import "FLPerson.h"

@interface FLProfileViewController : UIViewController

@property (strong, nonatomic) FLPerson *person;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UIButton *matchButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;

- (IBAction)viewFBPressed:(id)sender;

@end
