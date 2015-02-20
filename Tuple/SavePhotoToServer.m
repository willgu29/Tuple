//
//  SavePhotoToServer.m
//  Tuple
//
//  Created by William Gu on 2/19/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "SavePhotoToServer.h"
#import <Parse/Parse.h>

@implementation SavePhotoToServer

+(void)sendImageToServer:(UIImage *)image
{
    UIImage *yourImage= [UIImage imageNamed:@"image.png"];
    NSData *imageData = UIImagePNGRepresentation(yourImage);
    NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];
    
    NSString *username = [PFUser user].username;
    NSString *urlString = [NSString stringWithFormat:@"http://tupleapp.com/postPic/username=%@", username];
    // Init the URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:imageData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        // response data of the request
    }
}

@end
