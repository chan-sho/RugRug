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
    
    @IBOutlet weak var ad1Photo: UIImageView!
    @IBOutlet weak var ad2Photo: UIImageView!
    @IBOutlet weak var ad3Photo: UIImageView!
    @IBOutlet weak var ad4Photo: UIImageView!
    @IBOutlet weak var ad5Photo: UIImageView!
    @IBOutlet weak var ad6Photo: UIImageView!
    @IBOutlet weak var ad7Photo: UIImageView!
    @IBOutlet weak var ad8Photo: UIImageView!
    @IBOutlet weak var ad9Photo: UIImageView!
    
    @IBOutlet weak var ad1Button: UIButton!
    @IBOutlet weak var ad2Button: UIButton!
    @IBOutlet weak var ad3Button: UIButton!
    @IBOutlet weak var ad4Button: UIButton!
    @IBOutlet weak var ad5Button: UIButton!
    @IBOutlet weak var ad6Button: UIButton!
    @IBOutlet weak var ad7Button: UIButton!
    @IBOutlet weak var ad8Button: UIButton!
    @IBOutlet weak var ad9Button: UIButton!
    
    @IBOutlet weak var ad1Title: UILabel!
    @IBOutlet weak var ad2Title: UILabel!
    @IBOutlet weak var ad3Title: UILabel!
    @IBOutlet weak var ad4Title: UILabel!
    @IBOutlet weak var ad5Title: UILabel!
    @IBOutlet weak var ad6Title: UILabel!
    @IBOutlet weak var ad7Title: UILabel!
    @IBOutlet weak var ad8Title: UILabel!
    @IBOutlet weak var ad9Title: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var news1URL: String?
    var news2URL: String?
    var news3URL: String?
    var event1URL: String?
    var event2URL: String?
    var event3URL: String?
    
    var ad1URL: String?
    var ad2URL: String?
    var ad3URL: String?
    var ad4URL: String?
    var ad5URL: String?
    var ad6URL: String?
    var ad7URL: String?
    var ad8URL: String?
    var ad9URL: String?
    
    var GoogleAd: String?
    
    var news1PostType: String?
    var news2PostType: String?
    var news3PostType: String?
    var event1PostType: String?
    var event2PostType: String?
    var event3PostType: String?
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RugRugComment.delegate = self
        RugRugComment.layer.borderColor = UIColor.white.cgColor
        // 枠の幅
        RugRugComment.layer.borderWidth = 0.0
        // 枠を角丸にする場合
        RugRugComment.layer.cornerRadius = 12.0
        RugRugComment.layer.masksToBounds = true
        
        news1Photo.isUserInteractionEnabled = true
        
        ad1Photo.clipsToBounds = true
        ad1Photo.layer.cornerRadius = 5.0
        //* ad1Photo.layer.borderColor = UIColor.gray.cgColor
        //* ad1Photo.layer.borderWidth = 0.5
        
        ad2Photo.clipsToBounds = true
        ad2Photo.layer.cornerRadius = 5.0
        
        ad3Photo.clipsToBounds = true
        ad3Photo.layer.cornerRadius = 5.0
        
        ad4Photo.clipsToBounds = true
        ad4Photo.layer.cornerRadius = 5.0
        
        ad5Photo.clipsToBounds = true
        ad5Photo.layer.cornerRadius = 5.0
        
        ad6Photo.clipsToBounds = true
        ad6Photo.layer.cornerRadius = 5.0
        
        ad7Photo.clipsToBounds = true
        ad7Photo.layer.cornerRadius = 5.0
        
        ad8Photo.clipsToBounds = true
        ad8Photo.layer.cornerRadius = 5.0
        
        ad9Photo.clipsToBounds = true
        ad9Photo.layer.cornerRadius = 5.0
        
        
        //separatorを左端始まりにして、色指定
        tableView.separatorColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        tableView.separatorInset = .zero
        
        // TableViewを再表示する
        self.tableView.reloadData()
        
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
                
                self.news1PostType = "\(value!["News1PostType"] ?? "" as AnyObject)"
                self.news2PostType = "\(value!["News2PostType"] ?? "" as AnyObject)"
                self.news3PostType = "\(value!["News3PostType"] ?? "" as AnyObject)"
                
                let ad1PhotoString = "\(value!["Ad1Photo"] ?? "" as AnyObject)"
                if ad1PhotoString != "" {
                    self.ad1Photo.image = UIImage(data: Data(base64Encoded: ad1PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad2PhotoString = "\(value!["Ad2Photo"] ?? "" as AnyObject)"
                if ad2PhotoString != "" {
                    self.ad2Photo.image = UIImage(data: Data(base64Encoded: ad2PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad3PhotoString = "\(value!["Ad3Photo"] ?? "" as AnyObject)"
                if ad3PhotoString != "" {
                    self.ad3Photo.image = UIImage(data: Data(base64Encoded: ad3PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad4PhotoString = "\(value!["Ad4Photo"] ?? "" as AnyObject)"
                if ad4PhotoString != "" {
                    self.ad4Photo.image = UIImage(data: Data(base64Encoded: ad4PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad5PhotoString = "\(value!["Ad5Photo"] ?? "" as AnyObject)"
                if ad5PhotoString != "" {
                    self.ad5Photo.image = UIImage(data: Data(base64Encoded: ad5PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad6PhotoString = "\(value!["Ad6Photo"] ?? "" as AnyObject)"
                if ad6PhotoString != "" {
                    self.ad6Photo.image = UIImage(data: Data(base64Encoded: ad6PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad7PhotoString = "\(value!["Ad7Photo"] ?? "" as AnyObject)"
                if ad7PhotoString != "" {
                    self.ad7Photo.image = UIImage(data: Data(base64Encoded: ad7PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad8PhotoString = "\(value!["Ad8Photo"] ?? "" as AnyObject)"
                if ad8PhotoString != "" {
                    self.ad8Photo.image = UIImage(data: Data(base64Encoded: ad8PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad9PhotoString = "\(value!["Ad9Photo"] ?? "" as AnyObject)"
                if ad9PhotoString != "" {
                    self.ad9Photo.image = UIImage(data: Data(base64Encoded: ad9PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                self.ad1URL = "\(value!["Ad1URL"] ?? "" as AnyObject)"
                self.ad2URL = "\(value!["Ad2URL"] ?? "" as AnyObject)"
                self.ad3URL = "\(value!["Ad3URL"] ?? "" as AnyObject)"
                self.ad4URL = "\(value!["Ad4URL"] ?? "" as AnyObject)"
                self.ad5URL = "\(value!["Ad5URL"] ?? "" as AnyObject)"
                self.ad6URL = "\(value!["Ad6URL"] ?? "" as AnyObject)"
                self.ad7URL = "\(value!["Ad7URL"] ?? "" as AnyObject)"
                self.ad8URL = "\(value!["Ad8URL"] ?? "" as AnyObject)"
                self.ad9URL = "\(value!["Ad9URL"] ?? "" as AnyObject)"
                
                self.ad1Title.text = "\(value!["Ad1Title"] ?? "" as AnyObject)"
                self.ad2Title.text = "\(value!["Ad2Title"] ?? "" as AnyObject)"
                self.ad3Title.text = "\(value!["Ad3Title"] ?? "" as AnyObject)"
                self.ad4Title.text = "\(value!["Ad4Title"] ?? "" as AnyObject)"
                self.ad5Title.text = "\(value!["Ad5Title"] ?? "" as AnyObject)"
                self.ad6Title.text = "\(value!["Ad6Title"] ?? "" as AnyObject)"
                self.ad7Title.text = "\(value!["Ad7Title"] ?? "" as AnyObject)"
                self.ad8Title.text = "\(value!["Ad8Title"] ?? "" as AnyObject)"
                self.ad9Title.text = "\(value!["Ad9Title"] ?? "" as AnyObject)"
                
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
                
                self.event1PostType = "\(value!["Event1PostType"] ?? "" as AnyObject)"
                self.event2PostType = "\(value!["Event2PostType"] ?? "" as AnyObject)"
                self.event3PostType = "\(value!["Event3PostType"] ?? "" as AnyObject)"
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
        
        //GoogleAd掲載のYES/NO情報を取得
        var refAd: DatabaseReference!
        refAd = Database.database().reference().child("Ad(Google)")
        //  Firebaseからobserveでデータ検索
        refAd.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.GoogleAd = value
        })
        
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        news2Title.isExclusiveTouch = true
        news3Title.isExclusiveTouch = true
        
        event1Title.isExclusiveTouch = true
        event2Title.isExclusiveTouch = true
        event3Title.isExclusiveTouch = true
        
        guideButton.isExclusiveTouch = true
        EULAButton.isExclusiveTouch = true
        managerButton.isExclusiveTouch = true
        
        ad1Button.isExclusiveTouch = true
        ad2Button.isExclusiveTouch = true
        ad3Button.isExclusiveTouch = true
        ad4Button.isExclusiveTouch = true
        ad5Button.isExclusiveTouch = true
        ad6Button.isExclusiveTouch = true
        ad7Button.isExclusiveTouch = true
        ad8Button.isExclusiveTouch = true
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
                
                self.news1PostType = "\(value!["News1PostType"] ?? "" as AnyObject)"
                self.news2PostType = "\(value!["News2PostType"] ?? "" as AnyObject)"
                self.news3PostType = "\(value!["News3PostType"] ?? "" as AnyObject)"
                
                let ad1PhotoString = "\(value!["Ad1Photo"] ?? "" as AnyObject)"
                if ad1PhotoString != "" {
                    self.ad1Photo.image = UIImage(data: Data(base64Encoded: ad1PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad2PhotoString = "\(value!["Ad2Photo"] ?? "" as AnyObject)"
                if ad2PhotoString != "" {
                    self.ad2Photo.image = UIImage(data: Data(base64Encoded: ad2PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad3PhotoString = "\(value!["Ad3Photo"] ?? "" as AnyObject)"
                if ad3PhotoString != "" {
                    self.ad3Photo.image = UIImage(data: Data(base64Encoded: ad3PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad4PhotoString = "\(value!["Ad4Photo"] ?? "" as AnyObject)"
                if ad4PhotoString != "" {
                    self.ad4Photo.image = UIImage(data: Data(base64Encoded: ad4PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad5PhotoString = "\(value!["Ad5Photo"] ?? "" as AnyObject)"
                if ad5PhotoString != "" {
                    self.ad5Photo.image = UIImage(data: Data(base64Encoded: ad5PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad6PhotoString = "\(value!["Ad6Photo"] ?? "" as AnyObject)"
                if ad6PhotoString != "" {
                    self.ad6Photo.image = UIImage(data: Data(base64Encoded: ad6PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad7PhotoString = "\(value!["Ad7Photo"] ?? "" as AnyObject)"
                if ad7PhotoString != "" {
                    self.ad7Photo.image = UIImage(data: Data(base64Encoded: ad7PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad8PhotoString = "\(value!["Ad8Photo"] ?? "" as AnyObject)"
                if ad8PhotoString != "" {
                    self.ad8Photo.image = UIImage(data: Data(base64Encoded: ad8PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                let ad9PhotoString = "\(value!["Ad9Photo"] ?? "" as AnyObject)"
                if ad9PhotoString != "" {
                    self.ad9Photo.image = UIImage(data: Data(base64Encoded: ad9PhotoString, options: .ignoreUnknownCharacters)!)
                }
                
                self.ad1URL = "\(value!["Ad1URL"] ?? "" as AnyObject)"
                self.ad2URL = "\(value!["Ad2URL"] ?? "" as AnyObject)"
                self.ad3URL = "\(value!["Ad3URL"] ?? "" as AnyObject)"
                self.ad4URL = "\(value!["Ad4URL"] ?? "" as AnyObject)"
                self.ad5URL = "\(value!["Ad5URL"] ?? "" as AnyObject)"
                self.ad6URL = "\(value!["Ad6URL"] ?? "" as AnyObject)"
                self.ad7URL = "\(value!["Ad7URL"] ?? "" as AnyObject)"
                self.ad8URL = "\(value!["Ad8URL"] ?? "" as AnyObject)"
                self.ad9URL = "\(value!["Ad9URL"] ?? "" as AnyObject)"
                
                self.ad1Title.text = "\(value!["Ad1Title"] ?? "" as AnyObject)"
                self.ad2Title.text = "\(value!["Ad2Title"] ?? "" as AnyObject)"
                self.ad3Title.text = "\(value!["Ad3Title"] ?? "" as AnyObject)"
                self.ad4Title.text = "\(value!["Ad4Title"] ?? "" as AnyObject)"
                self.ad5Title.text = "\(value!["Ad5Title"] ?? "" as AnyObject)"
                self.ad6Title.text = "\(value!["Ad6Title"] ?? "" as AnyObject)"
                self.ad7Title.text = "\(value!["Ad7Title"] ?? "" as AnyObject)"
                self.ad8Title.text = "\(value!["Ad8Title"] ?? "" as AnyObject)"
                self.ad9Title.text = "\(value!["Ad9Title"] ?? "" as AnyObject)"
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
                
                self.event1PostType = "\(value!["Event1PostType"] ?? "" as AnyObject)"
                self.event2PostType = "\(value!["Event2PostType"] ?? "" as AnyObject)"
                self.event3PostType = "\(value!["Event3PostType"] ?? "" as AnyObject)"
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
        
        //GoogleAd掲載のYES/NO情報を取得
        var refAd: DatabaseReference!
        refAd = Database.database().reference().child("Ad(Google)")
        //  Firebaseからobserveでデータ検索
        refAd.observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.GoogleAd = value
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
        //  広告表示を管理
        if GoogleAd == "YES" {
            self.view.addSubview(admobView)
        }
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
        if news1URL != nil {
            news1URL = news1URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(news1URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func news2Title(_ sender: Any) {
        if news2URL != nil {
            news2URL = news2URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(news2URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func news3Title(_ sender: Any) {
        if news3URL != nil {
            news3URL = news3URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(news3URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func event1Title(_ sender: Any) {
        if event1URL != nil {
            event1URL = event1URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(event1URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func event2Title(_ sender: Any) {
        if event2URL != nil {
            event2URL = event2URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(event2URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func event3Title(_ sender: Any) {
        if event3URL != nil {
            event3URL = event3URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(event3URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad1Button(_ sender: Any) {
        if ad1URL != nil {
            ad1URL = ad1URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad1URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad2Button(_ sender: Any) {
        if ad2URL != nil {
            ad2URL = ad2URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad2URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad3Button(_ sender: Any) {
        if ad3URL != nil {
            ad3URL = ad3URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad3URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad4Button(_ sender: Any) {
        if ad4URL != nil {
            ad4URL = ad4URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad4URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad5Button(_ sender: Any) {
        if ad5URL != nil {
            ad5URL = ad5URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad5URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad6Button(_ sender: Any) {
        if ad6URL != nil {
            ad6URL = ad6URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad6URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad7Button(_ sender: Any) {
        if ad7URL != nil {
            ad7URL = ad7URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad7URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad8Button(_ sender: Any) {
        if ad8URL != nil {
            ad8URL = ad8URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad8URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func ad9Button(_ sender: Any) {
        if ad9URL != nil {
            ad9URL = ad9URL?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let url = URL(string: "\(ad9URL!)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
}
