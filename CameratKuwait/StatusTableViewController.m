//
//  StatusTableViewController.m
//  CameratKuwait
//
//  Created by Osama Rabie on 6/4/15.
//  Copyright (c) 2015 Osama Rabie. All rights reserved.
//

#import "StatusTableViewController.h"

@interface StatusTableViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation StatusTableViewController
{
    NSMutableArray* dataSource;
    NSURLConnection* getStatusConnection;
    UIRefreshControl* refresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self
                            action:@selector(getLatestStatuses)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    [self getLatestStatuses];

}

- (IBAction)addNew:(id)sender {
    NSLog(@"Do something..");
}

-(void)getLatestStatuses
{
    
    [refresh beginRefreshing];
    
    NSString *urlString = @"http://moh2013.com/arabDevs/Q8Camera/getCameras.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *printData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dataSource = [NSJSONSerialization JSONObjectWithData:printData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Upload Image %@",[[NSString alloc] initWithData:printData encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [refresh endRefreshing];
            [self.tableView reloadData];
            [self.tableView setNeedsDisplay];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (dataSource.count <= indexPath.row)return cell;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [dataSource mutableCopy];
    
    [(UILabel*)[cell viewWithTag:1] setText:[@"الشارع: " stringByAppendingString:[[dict objectForKey:@"0"] objectForKey:@"street"]]];
    [(UILabel*)[cell viewWithTag:2] setText:[@"الحالة: " stringByAppendingString:[[dict objectForKey:@"0"] objectForKey:@"status"]]];
    [(UILabel*)[cell viewWithTag:3] setText:[dict objectForKey:@"clock"]];
    
    return cell;
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

@end
