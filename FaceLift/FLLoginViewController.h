//
//  FLLoginViewController.h
//  FaceLift
//
//  Created by Lane on 11/8/12.
//
//

#import <UIKit/UIKit.h>

@interface FLLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)facebookLogin:(id)sender;
- (void)loginFailed;

@end
