//
//  NewsController.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
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

        self.collectionView.register(NewsCell.nib(), forCellWithReuseIdentifier: NewsCell.cellIdentifier())
        
        self.refreshControl = UIRefreshControl() 
//        self.collectionView.addPullToRefreshTo(scrollView: self.collectionView, triggeringMethodName: "endRefreshing")
        let refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(loadNews), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        
        self.loadNews()
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
    
    func endRefreshing(){
        self.loadNews()
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

extension NewsController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.cellIdentifier(), for: indexPath) as! NewsCell
//        cell.configureWithCamera(camera: self.camerasArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.fs_width - 20, height:  CGFloat(438))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.fs_width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "activity indicator", for: indexPath)
        self.footerCollectionViewActivityIndicatorView  = self.initCollectionViewFooter()
        footerView.addSubview(self.footerCollectionViewActivityIndicatorView)
        
        return footerView
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
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView == self.collectionView {
//            if ((scrollView.contentOffset.y + scrollView.frame.size.height) + 50 >= scrollView.contentSize.height)
//            {
//                if !self.isNewDataLoading{
//                    guard FSInternetConnectionHelper.checkConnection(showErrorOnView: self.footerCollectionViewActivityIndicatorView) else {return}
//                    let collection = self.camerasCollection
//                    guard let lCamerasCollection = collection else {return}
//                    
//                    self.activityIndicatorForCollectionView?.startAnimating()
//                    
//                    self.isNewDataLoading = true
//                    TBCamera.loadNextCamerasAfter(cameras: lCamerasCollection, result: { [weak self] (collection) in
//                        
//                        self?.activityIndicatorForCollectionView?.stopAnimating()
//                        
//                        self?.isNewDataLoading = false
//                        guard let camerasResource = collection?.resources as? [TBCamera] else {return}
//                        
//                        self?.camerasArray = camerasResource
//                        
//                        self?.camerasCollection = collection
//                        self?.collectionView.reloadData()
//                    })
//                }
//            }
//        }
//        
//    }
}
