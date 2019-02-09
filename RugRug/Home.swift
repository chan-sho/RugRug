//
//  Home.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import ESTabBarController
import GoogleMobileAds


class Home: UIViewController, UITextViewDelegate {

    @IBOutlet weak var news1Title: UILabel!
    @IBOutlet weak var news1Photo: UIImageView!
    @IBOutlet weak var news2Title: UIButton!
    @IBOutlet weak var news3Title: UIButton!
    @IBOutlet weak var event1Title: UIButton!
    @IBOutlet weak var event2Title: UIButton!
    @IBOutlet weak var event3Title: UIButton!
    @IBOutlet weak var RugRugComment: UITextView!
    @IBOutlet weak var guideButton: UIButton!
    @IBOutlet weak var EULAButton: UIButton!
    @IBOutlet weak var managerButton: UIButton!
    
    var news1URL: String?
    var news2URL: String?
    var news3URL: String?
    var event1URL: String?
    var event2URL: String?
    var event3URL: String?
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RugRugComment.delegate = self
        RugRugComment.layer.borderColor = UIColor.lightGray.cgColor
        // 枠の幅
        RugRugComment.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        RugRugComment.layer.cornerRadius = 10.0
        RugRugComment.layer.masksToBounds = true
        
        news1Photo.isUserInteractionEnabled = true
        
        //Newsの情報取得
        var refNews: DatabaseReference!
        refNews = Database.database().reference().child("News")
        //  Firebaseからobserveでデータ抽出
        refNews.observe(DataEventType.value, with: { (snapshot) in
            var value = snapshot.value as? [ String : AnyObject ]
            //中身の確認
            if value != nil{
                let news1PhotoString = "\(value!["News1Photo"] ?? "" as AnyObject)"
                if news1PhotoString != "" {
                    self.news1Photo.image = UIImage(data: Data(base64Encoded: news1PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                self.news1Title.text = "\(value!["News1Title"] ?? "1位:（※データ読み込みエラー）" as AnyObject)"
                self.news2Title.setTitle("\(value!["News2Title"] ?? "2位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.news3Title.setTitle("\(value!["News3Title"] ?? "3位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                
                self.news1URL = "\(value!["News1URL"] ?? "" as AnyObject)"
                self.news2URL = "\(value!["News2URL"] ?? "" as AnyObject)"
                self.news3URL = "\(value!["News3URL"] ?? "" as AnyObject)"
            }
            else {
                SVProgressHUD.showError(withStatus: "申し訳ありません！\nホーム画面の読み込みにエラーが発生しました。\nお手数ですが、アプリの再起動をお願い致します。")
                return
            }
        })
        
        
        //Eventの情報取得
        var refEvent: DatabaseReference!
        refEvent = Database.database().reference().child("Event")
        //  Firebaseからobserveでデータ抽出
        refEvent.observe(DataEventType.value, with: { (snapshot) in
            var value = snapshot.value as? [ String : AnyObject ]
            //中身の確認
            if value != nil{
                self.event1Title.setTitle("\(value!["Event1Title"] ?? "1位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.event2Title.setTitle("\(value!["Event2Title"] ?? "2位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.event3Title.setTitle("\(value!["Event3Title"] ?? "3位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                
                self.event1URL = "\(value!["Event1URL"] ?? "" as AnyObject)"
                self.event2URL = "\(value!["Event2URL"] ?? "" as AnyObject)"
                self.event3URL = "\(value!["Event3URL"] ?? "" as AnyObject)"
            }
            else {
                SVProgressHUD.showError(withStatus: "申し訳ありません！\nホーム画面の読み込みにエラーが発生しました。\nお手数ですが、アプリの再起動をお願い致します。")
                return
            }
        })
        
        
        //RugRug管理人からのご連絡
        var ref: DatabaseReference!
        ref = Database.database().reference().child("RugRug")
        //  Firebaseからobserveでデータ検索
        ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.RugRugComment.text = value
        })
    }

    
    override func viewWillAppear(_ animated: Bool) {
        //Newsの情報取得
        var refNews: DatabaseReference!
        refNews = Database.database().reference().child("News")
        //  Firebaseからobserveでデータ抽出
        refNews.observe(DataEventType.value, with: { (snapshot) in
            var value = snapshot.value as? [ String : AnyObject ]
            //中身の確認
            if value != nil{
                let news1PhotoString = "\(value!["News1Photo"] ?? "" as AnyObject)"
                if news1PhotoString != "" {
                    self.news1Photo.image = UIImage(data: Data(base64Encoded: news1PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                self.news1Title.text = "\(value!["News1Title"] ?? "1位:（※データ読み込みエラー）" as AnyObject)"
                self.news2Title.setTitle("\(value!["News2Title"] ?? "2位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.news3Title.setTitle("\(value!["News3Title"] ?? "3位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                
                self.news1URL = "\(value!["News1URL"] ?? "" as AnyObject)"
                self.news2URL = "\(value!["News2URL"] ?? "" as AnyObject)"
                self.news3URL = "\(value!["News3URL"] ?? "" as AnyObject)"
            }
            else {
                SVProgressHUD.showError(withStatus: "申し訳ありません！\nホーム画面の読み込みにエラーが発生しました。\nお手数ですが、アプリの再起動をお願い致します。")
                return
            }
        })
        
        
        //Eventの情報取得
        var refEvent: DatabaseReference!
        refEvent = Database.database().reference().child("Event")
        //  Firebaseからobserveでデータ抽出
        refEvent.observe(DataEventType.value, with: { (snapshot) in
            var value = snapshot.value as? [ String : AnyObject ]
            //中身の確認
            if value != nil{
                self.event1Title.setTitle("\(value!["Event1Title"] ?? "1位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.event2Title.setTitle("\(value!["Event2Title"] ?? "2位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                self.event3Title.setTitle("\(value!["Event3Title"] ?? "3位:（※データ読み込みエラー）" as AnyObject)", for: .normal)
                
                self.event1URL = "\(value!["Event1URL"] ?? "" as AnyObject)"
                self.event2URL = "\(value!["Event2URL"] ?? "" as AnyObject)"
                self.event3URL = "\(value!["Event3URL"] ?? "" as AnyObject)"
            }
            else {
                SVProgressHUD.showError(withStatus: "申し訳ありません！\nホーム画面の読み込みにエラーが発生しました。\nお手数ですが、アプリの再起動をお願い致します。")
                return
            }
        })
        
        
        //RugRug管理人からのご連絡
        var ref: DatabaseReference!
        ref = Database.database().reference().child("RugRug")
        //  Firebaseからobserveでデータ検索
        ref.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.RugRugComment.text = value
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews(){
        //  広告インスタンス作成
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        //  広告位置設定
        let safeArea = self.view.safeAreaInsets.bottom
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - safeArea - admobView.frame.height - 2 )
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        
        //  広告ID設定
        //  *広告ID = ca-app-pub-1267337188810870/3636401993
        //  テスト広告ID = ca-app-pub-3940256099942544/2934735716
        admobView.adUnitID = "ca-app-pub-1267337188810870/3636401993"
        
        //  広告表示
        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }
    
    @IBAction func EULAButton(_ sender: Any) {
        //プライバシーポリシー・利用規約のページをSafariで開くアクション
        let url = URL(string: "https://chan-sho.github.io/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func managerButton(_ sender: Any) {
        let userAddress = Auth.auth().currentUser!.email
        
        if userAddress == "shoyukimiukanae@gmail.com" || userAddress == "shoyukikanae@i.softbank.jp" {
            self.performSegue(withIdentifier: "toManager", sender: nil)
        }
    }
    
    
    @IBAction func news1PhotoTapped(_ sender: Any) {
        print("Tap!!")
        //対象の投稿ID
        let urlNews1 = news1URL
        
        if urlNews1 != "" {
            userDefaults.set(urlNews1, forKey: "RequestedPostID")
            userDefaults.synchronize()
        
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func news2Title(_ sender: Any) {
        let urlNews2 = news2URL
        
        if urlNews2 != "" {
            userDefaults.set(urlNews2, forKey: "RequestedPostID")
            userDefaults.synchronize()
            
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func news3Title(_ sender: Any) {
        let urlNews3 = news3URL
        
        if urlNews3 != "" {
            userDefaults.set(urlNews3, forKey: "RequestedPostID")
            userDefaults.synchronize()
            
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func event1Title(_ sender: Any) {
        let urlEvent1 = event1URL
        
        if urlEvent1 != "" {
            userDefaults.set(urlEvent1, forKey: "RequestedPostID")
            userDefaults.synchronize()
            
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func event2Title(_ sender: Any) {
        let urlEvent2 = event2URL
        
        if urlEvent2 != "" {
            userDefaults.set(urlEvent2, forKey: "RequestedPostID")
            userDefaults.synchronize()
            
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func event3Title(_ sender: Any) {
        let urlEvent3 = event3URL
        
        if urlEvent3 != "" {
            userDefaults.set(urlEvent3, forKey: "RequestedPostID")
            userDefaults.synchronize()
            
            let tabBarController = parent as! ESTabBarController
            tabBarController.setSelectedIndex(1, animated: false)
            for viewController in tabBarController.children {
                if viewController is Post {
                    let post = viewController as! Post
                    post.handleCheckedPost()
                    break
                }
            }
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
}
