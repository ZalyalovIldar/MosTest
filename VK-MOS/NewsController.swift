//
//  NewsController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class NewsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsFeedModel: NewsFeed?
    var itemsArray: [Item] = []
    var groupsArray: [Group] = []
    var profilesArray: [Profile] = []
    var isNewDataLoading = false
    var activityIndicatorForCollectionView: UIActivityIndicatorView!
    var footerCollectionViewActivityIndicatorView: UIView!
    var refreshControl: UIRefreshControl!
    
    
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
        
        let alertController = UIAlertController(title: "", message: "Exit?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesButton = UIAlertAction(title: "YES", style: .default) { (alertAction: UIAlertAction) -> Void in
            MainUser.removeUser()
            HTTPCookieStorage.removeCookies()
            ScreensSwithcer.switchScreens()
        }
        let noButton = UIAlertAction(title: "NO", style: .destructive) { (alertAction: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Custom methods
    
    /// Adding colors, UI elements, etc. for inition state
    func setUpMainAppereance(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.addTarget(self, action: #selector(loadNews), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView.register(NewsCell.nib(), forCellReuseIdentifier: NewsCell.cellIdentifier())
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 450
    }
    
    ///Getting saved Realm objects from BD
    func getSavedObjects(){
        guard let realm = BDRealm else {fatalError()}
        
        self.newsFeedModel = realm.objects(NewsFeed.self).first
        if let newsFeed = self.newsFeedModel{
            self.itemsArray    = Array(newsFeed.items)
            self.groupsArray   = Array(newsFeed.groups)
            self.profilesArray = Array(newsFeed.profiles)
        }
    }
    ///Using for get first 20 scope of data, if no Intenet connection -> take from Realm BD
    func loadNews(){
        guard let accessToken = MainUser.currentUser()?.token else {return}
        SVProgressHUD.show()
        guard Router.networkReachabilityManager?.isReachable == true else {
            self.getSavedObjects()
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            
            return
        }
        self.task = Router.User.getMainUserNews(userToken:accessToken, start_from: "").request().responseObject({[weak self] (response: DataResponse<RTUserNewsFeedResponse>) in
            switch response.result{
            case .success(let value):
                guard let newsFeed = value.newsFeed  else {return}
                self?.newsFeedModel = newsFeed
                Logger.debug("\nSussess response: \(newsFeed)")
                
                do {
                    guard let realm = BDRealm else {return}
                    try realm.write({
                        realm.delete(realm.objects(NewsFeed.self))
                        realm.add(newsFeed, update: true)
                    })
                    
                } catch let error {
                    Logger.error("\nSaving NewsFeed info Error: \(error)")
                }
                
                self?.itemsArray    = Array(newsFeed.items)
                self?.groupsArray   = Array(newsFeed.groups)
                self?.profilesArray = Array(newsFeed.profiles)
                
                DispatchQueue.main.async(execute: {
                    self?.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                    self?.tableView.reloadData()
                })
            case .failure(let error):
                Logger.error("\nError when getting NewsWall: \(error)")
                DispatchQueue.main.async(execute: {
                    self?.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                })
            }
        })
    }
    /// Using for Pagination. Need send 'nextFrom' from NewsFeed model into 'from'.
    func loadNextNews(from: String){
        guard let accessToken = MainUser.currentUser()?.token else {return}
        self.task = Router.User.getMainUserNews(userToken: accessToken, start_from: from).request().responseObject({[weak self] (response:DataResponse<RTUserNewsFeedResponse>) in
            switch response.result{
            case .success(let value):
                guard let newsFeed = value.newsFeed  else {return}
                self?.newsFeedModel = newsFeed
                self?.isNewDataLoading = false
                Logger.debug("\nSussess response of next scope News: \(newsFeed)")
                
                self?.itemsArray.append(contentsOf: Array(newsFeed.items))
                self?.groupsArray.append(contentsOf: Array(newsFeed.groups))
                self?.profilesArray.append(contentsOf: Array(newsFeed.profiles))
                
                DispatchQueue.main.async(execute: {
                    self?.activityIndicatorForCollectionView.stopAnimating()
                    self?.tableView.reloadData()
                })
            case .failure(let error):
                Logger.error("\nError when getting next scope News: \(error)")
                DispatchQueue.main.async(execute: {
                    self?.activityIndicatorForCollectionView.stopAnimating()
                    SVProgressHUD.dismiss()
                })
            }
        })
    }
    

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
      guard let detailController = segue.destination as? NewsDetailController,
        let indePath = sender as? IndexPath, segue.identifier == "segue"
        else {return}
        
        var pName: String
        var pAvatarUrl: URL
        
        let item = self.itemsArray[indePath.row]
        
        if item.sourceId < 0 {
            let group = self.groupsArray.filter{$0.id == -item.sourceId}.first
            guard let name = group?.name, let url = group?.phtoUrl else {return}
            pName = name
            pAvatarUrl = url
        }else{
            let profile = self.profilesArray.filter{$0.id == item.sourceId}.first
            guard let name = profile?.fullname, let url = profile?.phtoUrl else {return}
            pName = name
            pAvatarUrl = url
        }
        
        detailController.postName = pName
        detailController.postAvatarUrl = pAvatarUrl
        detailController.postItem = item
        
     }
 
    
}
//MARK: UITableView Delegate & DataSource methods
extension NewsController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var group: Group? = nil
        var profile: Profile? = nil
        var item: Item! = nil
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifier(), for: indexPath) as! NewsCell
        cell.delegate = self
        
        item = self.itemsArray[indexPath.row]
        group = self.groupsArray.count > 0 ? self.groupsArray.filter{$0.id == -item.sourceId}.first : nil
        profile = self.profilesArray.count > 0 ? self.profilesArray.filter{$0.id == item.sourceId}.first : nil
        
        if group != nil{
            cell.prepareCellWith(item: item, group: group!)
        }
        
        if profile != nil{
            cell.prepareCellWith(item: item, profile: profile!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segue", sender: indexPath)
         self.tableView.fs_deselectSelectedRow(true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.initTableViewFooter()
    }
    
    func initTableViewFooter() ->UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.fs_width, height: 65))
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

//MARK: VKItemTableViewCell Delegate method
extension NewsController: VKItemTableViewCellDelegate{
    func didTapLikeFor(item: Item, withButton: UIButton, andLabel: UILabel){
        guard let user = MainUser.currentUser() else {return}
        
        if withButton.isSelected == false{
            self.addLikeTo(item: item, withButton: withButton, andLabel: andLabel, andToken: user.token)
        }else{
            self.deleteLikeFrom(item: item, withButton: withButton, andLabel: andLabel, andToken: user.token)
        }
        
    }
    
    //MARK: Helpers methods
    
    /// Add like to item and update Like count of model
    func addLikeTo(item: Item, withButton: UIButton, andLabel: UILabel, andToken: String){
        self.task = Router.User.addLikeToItem(withId: item.postId, type: item.type, userToken: andToken, ownerId:item.sourceId).request().responseObject({(response:DataResponse<RTEmptyResponse>) in
            
            switch response.result{
            case .success(let value):
                guard let LResponseCount = value.response?.responseCount  else {return}
                
                Logger.debug("\nPost liked successfully: \(LResponseCount)")
                guard let realm = BDRealm else {return}
                do{
                    try! realm.write {
                        item.likes?.count = LResponseCount
                        item.likes?.userLikes = true
                    }
                }
                DispatchQueue.main.async(execute: {
                    withButton.isSelected = true
                    andLabel.text = "\(LResponseCount)"
                })
            case .failure(let error):
                Logger.error("\nError when adding like: \(error)")
            }
        })
    }
    ///Remove like from Item and update likes count of model
    func deleteLikeFrom(item: Item, withButton: UIButton, andLabel: UILabel, andToken: String){
        self.task = Router.User.deleteLikeFromItem(withId: item.postId, type: item.type, userToken: andToken, ownerId:item.sourceId).request().responseObject({(response:DataResponse<RTEmptyResponse>) in
            
            switch response.result{
            case .success(let value):
                guard let LResponseCount = value.response?.responseCount  else {return}
                
                Logger.debug("\nPost like removed successfully: \(LResponseCount)")
                guard let realm = BDRealm else {return}
                do{
                    try! realm.write {
                        item.likes?.count = LResponseCount
                        item.likes?.userLikes = false
                    }
                }
                DispatchQueue.main.async(execute: {
                    withButton.isSelected = false
                    andLabel.text = "\(LResponseCount)"
                })
            case .failure(let error):
                Logger.error("\nError when removing post like: \(error)")
            }
        })
    }
}
//MARK: ScrollView delegate method
extension NewsController{
    /// Checking if we scrolled to end and triger pagination methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) + 150 >= scrollView.contentSize.height)
            {
                if !self.isNewDataLoading{
                    guard Router.networkReachabilityManager?.isReachable == true else {return}
                    
                    guard self.itemsArray.count > 0, let newsFeed = self.newsFeedModel
                        else {return}
                    
                    self.activityIndicatorForCollectionView?.startAnimating()
                    
                    self.isNewDataLoading = true
                    self.loadNextNews(from: newsFeed.nextFrom)
                }
            }
        }
    }
    
}

