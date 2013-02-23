#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BatStatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
	IBOutlet UITableView *batteryTableView;
    CLLocationManager *locationManager;
}

- (void) batteryChanged:(NSNotification *)notification;

@end

