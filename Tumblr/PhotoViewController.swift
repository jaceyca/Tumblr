//
//  PhotoViewController.swift
//  Tumblr
//
//  Created by Jessica Choi on 6/16/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [NSDictionary] = []
    
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                }
            }
            self.tableView.reloadData()
        });
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary]{
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            let imageUrl = NSURL(string: imageUrlString!)!
            cell.tumblrImage.setImageWithURL(imageUrl)
        } else{
            
        }
        
        tableView.rowHeight = 240;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("deselect")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // NSLog("prepare for segue")
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        
        
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        // let cell = sender as! PhotoCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        let post = posts[indexPath!.row]
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary]{
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            let imageUrl = NSURL(string: imageUrlString!)!
            cell.tumblrImage.setImageWithURL(imageUrl)
        }
        
        
        vc.image = cell.tumblrImage.image
        
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
