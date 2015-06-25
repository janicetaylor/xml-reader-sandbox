//
//  ArticleTableViewController.m
//  xmlreader-sandbox
//
//  Created by Janice Taylor on 6/25/15.
//  Copyright (c) 2015 Janice Taylor. All rights reserved.
//

#import "ArticleTableViewController.h"
#import "ArticleTableViewCell.h"
#import "DataSource.h"
#import "Article.h" 
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *xmlUrl = @"http://www.cbc.ca/cmlink/rss-topstories";

@interface ArticleTableViewController ()

@property (nonatomic) NSMutableArray *articles;

@end

@implementation ArticleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.articles = [@[] mutableCopy];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createArticles];
    
}


- (void)createArticles
{
    DataSource *datasource = [DataSource masterDataSource];
    
    NSURL *url = [NSURL URLWithString:xmlUrl];
    NSDictionary *xmlDictionary = [datasource loadXMLWithUrl:url];
    
    NSDictionary *channelDictionary = xmlDictionary[@"channel"];
    
    NSArray *titles = [channelDictionary valueForKeyPath:@"item.title"];
    NSArray *links = [channelDictionary valueForKeyPath:@"item.link"];
    NSArray *pubdates = [channelDictionary valueForKeyPath:@"item.pubDate"];
    NSArray *authors = [channelDictionary valueForKeyPath:@"item.author"];
    NSArray *descriptions = [channelDictionary valueForKeyPath:@"item.description"];

    for(int i=0; i<titles.count; i++) {
        
        Article *article = [Article new];
        article.title = titles[i];
        article.pubDate = pubdates[i];
        article.author = authors[i];
        article.articleUrl = [NSURL URLWithString:links[i]];
        
        NSString *str = descriptions[i];
        NSArray *output = [str componentsSeparatedByString:@"src='"];
        NSArray *output2 = [output[1] componentsSeparatedByString:@"' />"];
        article.imageURL = output2[0];
        
        [self.articles addObject:article];
    }
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"Cell";
    
    ArticleTableViewCell *cell = (ArticleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    NSString *thumbnailURL = [NSString stringWithFormat:@"%@", self.thumbnailUrlArray[indexPath.row]];
//    NSString *captionString = [NSString stringWithFormat:@"%@ from %@", self.captionArray[indexPath.row], self.userArray[indexPath.row]];
    
//    cell.thumbnailView.image = [self getImageFromURL:thumbnailURL];
//    cell.captionLabel.text = captionString;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    Article *article = self.articles[indexPath.row];
    cell.titleLabel.text = article.title;
    cell.pubDateLabel.text = article.pubDate;
    cell.authorLabel.text = article.author;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:article.imageURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
    
}


- (UIImage *)getImageFromURL:(NSString *)fileURL
{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    else {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

@end
