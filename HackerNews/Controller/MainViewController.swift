//
//  ViewController.swift
//  HackerNews
//
//  Created by Muhammad Adam on 2/14/19.
//  Copyright © 2019 Muhammad Adam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var pageSelection: UISegmentedControl!
    @IBOutlet weak var storiesTableView: UITableView!
    @IBOutlet weak var checkingUpdatesProgress: UIProgressView!
    
    private var storyIdList = [Int]()
    private var storyObjects = [Story]()
    private let batchSize = 20
    private let pagesTitles = ["Top", "New"]
    
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        checkingUpdatesProgress.setProgress(0, animated: true)
        for i in pagesTitles.indices{
            pageSelection.setTitle(pagesTitles[i], forSegmentAt: i)
        }
        API.requestList(url: API.EndPoint.topStories.url) { (list, error) in
            self.storyIdList = list
            self.requestNewBatch(isNewList: true)
        }
    }

    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        let urls = [API.EndPoint.topStories.url, API.EndPoint.newStories.url]
        switch pageSelection.selectedSegmentIndex {
        case let urlIndex where urlIndex < urls.count:
            API.requestList(url: urls[urlIndex]) { (IdsList, error) in
                self.storyIdList = IdsList
                self.requestNewBatch(isNewList: true)
            }
            scrollToFirstRow(animated: false)
        default:
            break
        }
    }
   
    
    /// Requests new batch of the fetched id list
    ///
    /// - Parameter isNewList: Does the reqested new batch from the same list or not ?
    fileprivate func requestNewBatch(isNewList: Bool) {
        if isNewList {
            storyObjects.removeAll()
        }
        let currentSize = storyObjects.count
        storyObjects += Array(repeating: Story(), count: batchSize)
        var loadedStories = 0
        for i in 0..<batchSize where i+storyObjects.count < storyIdList.count{
            API.requestStory(storyUrl: API.EndPoint.item(self.storyIdList[i+currentSize]).url, completionHandler: { (story, error) in
                guard let story = story else {
                    return
                }
                loadedStories += 1
                self.storyObjects[currentSize+i] = story
                DispatchQueue.main.sync {
                    self.storiesTableView.reloadData()
                    self.updateCheckingUpdatesProgress(value: loadedStories,fromFullSize: self.batchSize-1)
                }
            })
        }
    }
    
    
    /// Handles list request for the first time
    ///
    /// - Parameter ListType: The type of requested list
    fileprivate func handleRequestList(listType: API.EndPoint) -> Void {
        API.requestList(url: listType.url) { (list, error) in
            self.storyIdList = list
            self.requestNewBatch(isNewList: true)
        }
    }
    
    
    /// Updates progress bar based on value percent of the fullsize
    ///
    /// - Parameters:
    ///   - value: The filled part's actual value of the full size
    ///   - size: Full size
    fileprivate func updateCheckingUpdatesProgress(value: Int ,fromFullSize size: Int){
        let newProgress = size != 0 ? Float(value)/Float(size) : 0
        if newProgress <= 1 {
            self.checkingUpdatesProgress.setProgress(newProgress, animated: true)
            self.checkingUpdatesProgress.isHidden = false
        }else{
            DispatchQueue.main.async() {
                self.checkingUpdatesProgress.setProgress(0.0, animated: false)
                self.checkingUpdatesProgress.isHidden = true
            }
        }
    }
    
    
    /// Gets the passed time since fromTime
    ///
    /// - Parameter unixTime: The start  time in the unix integer value
    /// - Returns: The time difference's value and unit
    fileprivate func getPassedTime(fromTime unixTime: Int) -> (Int,String){
        let difference = Int(Date().timeIntervalSince1970) - unixTime
        var result = (Int,String)(0,"second")
        let minuteSeconds:Int = 60
        let hourSeconds:Int = 60 * minuteSeconds
        let daySeconds:Int = 24 * hourSeconds
        let monthSeconds:Int = 30 * daySeconds
        
        if difference < minuteSeconds {
            result = (difference,"second")
        }else if difference < hourSeconds && difference >= minuteSeconds{
            result = (difference/minuteSeconds, "mintue")
        }else if difference < daySeconds && difference >= hourSeconds{
            result = (difference/hourSeconds, "hour")
        }else if difference < monthSeconds && difference >= daySeconds{
            result = (difference/daySeconds, "day")
        }
        
        if result.0 != 1 {
            result.1.append("s")
        }
        return result
    }
    
    
    /// Gets an attributen text from the domain name of full url string
    ///
    /// - Parameter urlString: the full url string
    /// - Returns: Attributed string of the domain name
    fileprivate func getAttributedDomainName(urlString: String) -> NSMutableAttributedString{
        let url = URL(string: urlString)
        let urlDomainName = url?.host?.replacingOccurrences(of: "www.", with: "") ?? ""
        let cellHostPartOfTitleTextAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) ]
        return NSMutableAttributedString(string: " (\(urlDomainName))", attributes: cellHostPartOfTitleTextAttributes)
    }
}



// MARK: - Table view delegate, data source and related functions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyObjects.count//storyIdList.count > 20 ? 20 : storyIdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storiesTableView.dequeueReusableCell(withIdentifier: "storiesTableViewCell")!
        
        if let by = storyObjects[indexPath.row].by,
            let score = storyObjects[indexPath.row].score,
            let urlString = storyObjects[indexPath.row].url,
            let time = storyObjects[indexPath.row].time{
            let cellTitle = NSMutableAttributedString(string: "\(indexPath.row+1).  \(storyObjects[indexPath.row].title ?? "")")
                cellTitle.append(getAttributedDomainName(urlString: urlString))
                cell.textLabel?.attributedText = cellTitle
                let timeResult = getPassedTime(fromTime: time)
                cell.detailTextLabel?.text = "\(score)" + " points\tby: " + by + "\t\(timeResult.0) \(timeResult.1) ago"
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = storyObjects[indexPath.row].url{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let storyUrlController = storyboard.instantiateViewController(withIdentifier: "StoryWebsiteController") as? StoryWebsiteController else{
                return
            }
            storyUrlController.urlString = urlString
            self.present(storyUrlController, animated: true, completion: nil)
        }
    }
    
    
    /// Loads more data while dragging the scroll view
    ///
    /// - Parameter scrollView: Tableview's scroll view
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let lastIndexPath = storiesTableView.indexPathsForVisibleRows?.last, lastIndexPath.row == storyObjects.count-1{
            requestNewBatch(isNewList: false)
        }
    }
    
    
    /// Scrolls to the first row of the table view
    fileprivate func scrollToFirstRow(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.storiesTableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
