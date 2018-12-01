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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RugRugComment.delegate = self
        RugRugComment.layer.borderColor = UIColor.white.cgColor
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
        let urlNews1 = news1URL
        let url = URL(string: "\(urlNews1!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
            }
        }
    }
    
    
    @IBAction func news2Title(_ sender: Any) {
        let urlNews2 = news2URL
        let url = URL(string: "\(urlNews2!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
        }
        }
    }
    
    
    @IBAction func news3Title(_ sender: Any) {
        let urlNews3 = news3URL
        let url = URL(string: "\(urlNews3!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
        }
        }
    }
    
    
    @IBAction func event1Title(_ sender: Any) {
        let urlEvent1 = event1URL
        let url = URL(string: "\(urlEvent1!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
        }
        }
    }
    
    
    @IBAction func event2Title(_ sender: Any) {
        let urlEvent2 = event2URL
        let url = URL(string: "\(urlEvent2!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
        }
        }
    }
    
    
    @IBAction func event3Title(_ sender: Any) {
        let urlEvent3 = event3URL
        let url = URL(string: "\(urlEvent3!)")
        if url == nil {
            return
        }
        else {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!)
        }
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
}
