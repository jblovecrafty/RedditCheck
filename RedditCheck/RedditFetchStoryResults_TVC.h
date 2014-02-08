//
//  RedditFetchStoryResults_TVC.h
//  RedditFetch
//
//  Created by Joe Jones on 1/5/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedditFetchStoryResults_TVC : UITableViewController
@property (nonatomic, strong) NSArray *storiesCollection;
@property (nonatomic,strong) NSString * modKey;
@property (nonatomic,strong) NSString *subReddit;
@property int numberOfStories;
@end
