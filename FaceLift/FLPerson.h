//
//  FLPerson.h
//  FaceLift
//
//  Created by Lane on 11/14/12.
//
//

#import <Foundation/Foundation.h>

@interface FLPerson : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *pictureUrl;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *coverUrl;

@end
