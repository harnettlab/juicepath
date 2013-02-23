#import "BatStatViewController.h"
#define LABEL_TAG 1 
#define VALUE_TAG 2 

@implementation BatStatViewController

#pragma mark View Methods


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIDevice *device = [UIDevice currentDevice];
	device.batteryMonitoringEnabled = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:device];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];

}

#pragma mark Table Callbacks


    
    
       
        
    


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;//cindy added 2 for lat and long
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	UILabel *label, *value;
	
	if (cell == nil) {
		CGRect frame = CGRectMake(0, 0, 300, 44); 
		
		cell = [[[UITableViewCell alloc] initWithFrame:frame reuseIdentifier:MyIdentifier] autorelease]; 
		
		label = [[[UILabel alloc] initWithFrame:CGRectMake(5.0, 12.0, 40.0, 25.0)] autorelease];
		label.tag = LABEL_TAG; 
		label.font = [UIFont systemFontOfSize:12.0]; 
		label.textAlignment = UITextAlignmentRight; 
		label.textColor = [UIColor blueColor]; 
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:label]; 
		
		value = [[[UILabel alloc] initWithFrame:CGRectMake(55, 12.0, 225.0, 25.0)] autorelease]; 
		value.tag = VALUE_TAG;
		value.textColor = [UIColor blackColor]; 
		value.lineBreakMode = UILineBreakModeWordWrap; 
		value.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
		[cell.contentView addSubview:value]; 
	} else { 
		label = (UILabel *)[cell.contentView viewWithTag:LABEL_TAG]; 
		value = (UILabel *)[cell.contentView viewWithTag:VALUE_TAG]; 
	} 
	
    
	UIDevice *device = [UIDevice currentDevice];
    
    int degrees = locationManager.location.coordinate.latitude;
    double decimal = fabs(locationManager.location.coordinate.latitude - degrees);
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                     degrees, minutes, seconds];
    degrees = locationManager.location.coordinate.longitude;
    decimal = fabs(locationManager.location.coordinate.longitude - degrees);
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                       degrees, minutes, seconds];

	if (indexPath.row == 0) {
		label.text = @"State";
		switch(device.batteryState) {
			case UIDeviceBatteryStateUnknown:
				value.text = @"Unknown";
				break;
			case UIDeviceBatteryStateUnplugged:
				value.text = @"Unplugged";
				break;
			case UIDeviceBatteryStateCharging:
				value.text = @"Charging";
				break;
			case UIDeviceBatteryStateFull:
				value.text = @"Full";
				break;				
		}					
	} else if (indexPath.row == 1) {
		label.text = @"Charge";
		value.text =  device.batteryState == UIDeviceBatteryStateUnknown ? @"Unknown" : [NSString stringWithFormat:@"%i%%", (int)(device.batteryLevel * 100)];		
	} else if (indexPath.row == 2){
        label.text = @"Latitude";
        value.text = lat;
    } else if (indexPath.row == 3){
        label.text = @"Longitude";
        value.text = longt;
    }
    
    
      else {
		label.text = @"At";
		NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
		[timeFormat setDateFormat:@"h:mm:ss"];			
		value.text =   [NSString stringWithFormat:@"%@", [timeFormat stringFromDate:[NSDate date]]];
		[timeFormat release];
	}
	
    return cell;	
}


#pragma mark Notification Center Callback 

- (void) batteryChanged:(NSNotification *)notification {
	UIDevice *device = [UIDevice currentDevice];
	NSLog(@"State: %i Charge: %f", device.batteryState, device.batteryLevel);
    if (device.batteryState == UIDeviceBatteryStateCharging){
        //get lat and long, and do a http post to my web app
        //int degrees = locationManager.location.coordinate.latitude;
        //double decimal = fabs(locationManager.location.coordinate.latitude - degrees);
        //int minutes = decimal * 60;
        //double seconds = decimal * 3600 - minutes * 60;
        double mylat=locationManager.location.coordinate.latitude;
        //NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                        // degrees, minutes, seconds];
        NSString *lat=[NSString stringWithFormat:@"%1.5f", mylat];
        //degrees = locationManager.location.coordinate.longitude;
        //decimal = fabs(locationManager.location.coordinate.longitude - degrees);
        //minutes = decimal * 60;
        //seconds = decimal * 3600 - minutes * 60;
        double mylong=locationManager.location.coordinate.longitude;
        //NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
        //                   degrees, minutes, seconds];
        NSString *longt=[NSString stringWithFormat:@"%1.5f",mylong];
        NSString *content;
        content = [@"lat=" stringByAppendingString:lat ];
        content = [content stringByAppendingString:@"&long="];
        content = [content stringByAppendingString:longt];
                             
                             NSURL* url = [NSURL URLWithString:@"http://juice-path.appspot.com/newone"];
                             NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
                             [urlRequest setHTTPMethod:@"POST"];
                             //[urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
                             [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
        
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            //receivedData = [[NSMutableData data] retain];  //do nothing yet--Cindy
        } else {
            // Inform the user that the connection failed.
        }

    }
	[batteryTableView reloadData];
}

#pragma mark Housekeeping

- (void)dealloc {
    [super dealloc];
}

@end
