//
//  RedditFetchWebViewController.h
//  RedditFetch
//
//  Created by Joe Jones on 1/6/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedditFetchWebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic,strong) NSURL *redditStoryURL;
@property (nonatomic,strong) NSURL *redditCommentsURL;
@property (weak, nonatomic) IBOutlet UIWebView *redditWebView;
@end
