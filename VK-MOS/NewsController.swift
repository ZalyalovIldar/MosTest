//
//  NewsController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsFeedModel: NewsFeed?
    var itemsArray: [Item] = []
    var groupsArray: [Group] = []
    var profilesArray: [Profile] = []
    var isNewDataLoading = false
    var activityIndicatorForCollectionView: UIActivityIndicatorView!
    var footerCollectionViewActivityIndicatorView: UIView!
    var refreshControl: UIRefreshControl!
    var isOffline = false
    
    
    var task: DataRequest? {
        willSet {
            self.task?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpMainAppereance()
        self.loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Buttons action
    @IBAction func exitPressed(_ sender: Any) {
        SVProgressHUD.show()
        MainUser.removeUser()
        HTTPCookieStorage.removeCookies()
        ScreensSwithcer.switchScreens()
        SVProgressHUD.dismiss()
    }

    //MARK: Custom methods
    
    func setUpMainAppereance(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.addTarget(self, action: #selector(loadNews), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView.register(NewsCell.nib(), forCellReuseIdentifier: NewsCell.cellIdentifier())
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 450
    }
    
    func loadNews(){
        guard let accessToken = MainUser.currentUser()?.token else {return}
        SVProgressHUD.show()
        self.task = Router.User.getMainUserNews(userToken:accessToken, start_from: "").request().responseObject({ (response: DataResponse<RTUserNewsFeedResponse>) in
            switch response.result{
            case .success(let value):
                guard let newsFeed = value.newsFeed  else {return}
                self.newsFeedModel = newsFeed
                Logger.debug("\nSussess response: \(newsFeed)")
        
                self.itemsArray    = Array(newsFeed.items)
                self.groupsArray   = Array(newsFeed.groups)
                self.profilesArray = Array(newsFeed.profiles)
                
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                })
            case .failure(let error):
                Logger.error("\nError when getting NewsWall: \(error)")
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                })
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var group: Group? = nil
        var profile: Profile? = nil
        var item: Item! = nil
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifier(), for: indexPath) as! NewsCell
        
        if self.isOffline == true{
            guard let realm = BDRealm else {fatalError()}
            item = realm.objects(Item.self)[indexPath.row]
            group = realm.object(ofType: Group.self, forPrimaryKey: item.sourceId)
            profile = realm.object(ofType: Profile.self, forPrimaryKey: item.sourceId)
        }else{
            item = self.itemsArray[indexPath.row]
            group = self.groupsArray.count > 0 ? self.groupsArray.filter{$0.id == -item.sourceId}.first : nil
            profile = self.profilesArray.count > 0 ? self.profilesArray.filter{$0.id == item.sourceId}.first : nil
        }
        
        if group != nil{
            cell.prepareCellWith(item: item, group: group!)
        }
        
        if profile != nil{
            cell.prepareCellWith(item: item, profile: profile!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.initCollectionViewFooter()
    }
    
    func initCollectionViewFooter() ->UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.fs_width, height: 55))
        view.backgroundColor = UIColor.clear
        self.activityIndicatorForCollectionView = UIActivityIndicatorView()
        self.activityIndicatorForCollectionView?.color = #colorLiteral(red: 1, green: 0.758528769, blue: 0, alpha: 1)
        self.activityIndicatorForCollectionView?.center = view.center
        self.activityIndicatorForCollectionView?.hidesWhenStopped = true
        if let lActivity = self.activityIndicatorForCollectionView {
            view.addSubview(lActivity)
        }
        return view
    }
}



////    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////        if scrollView == self.collectionView {
////            if ((scrollView.contentOffset.y + scrollView.frame.size.height) + 50 >= scrollView.contentSize.height)
////            {
////                if !self.isNewDataLoading{
////                    guard FSInternetConnectionHelper.checkConnection(showErrorOnView: self.footerCollectionViewActivityIndicatorView) else {return}
////                    let collection = self.camerasCollection
////                    guard let lCamerasCollection = collection else {return}
////                    
////                    self.activityIndicatorForCollectionView?.startAnimating()
////                    
////                    self.isNewDataLoading = true
////                    TBCamera.loadNextCamerasAfter(cameras: lCamerasCollection, result: { [weak self] (collection) in
////                        
////                        self?.activityIndicatorForCollectionView?.stopAnimating()
////                        
////                        self?.isNewDataLoading = false
////                        guard let camerasResource = collection?.resources as? [TBCamera] else {return}
////                        
////                        self?.camerasArray = camerasResource
////                        
////                        self?.camerasCollection = collection
////                        self?.collectionView.reloadData()
////                    })
////                }
////            }
////        }
////        
////    }
//}
