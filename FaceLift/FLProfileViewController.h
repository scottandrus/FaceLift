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
- (IBAction)matchFacePressed:(id)sender;
- (IBAction)friendRequestPressed:(id)sender;
- (IBAction)viewFBPressed:(id)sender;

@end
