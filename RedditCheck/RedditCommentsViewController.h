//
//  RedditCommentsViewController.h
//  RedditCheck
//
//  Created by Joe Jones on 5/2/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedditCommentsViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic,strong) NSURL *redditCommentsURL;
@property (weak, nonatomic) IBOutlet UIWebView *redditWebView;
@end
