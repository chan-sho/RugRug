//
//  AJAlertController.Swift
//  AJAlertController
//
//  Created by Arpit Jain on 13/12/17.
//  Copyright © 2017 Arpit Jain. All rights reserved.
//
// 【UserDefaults管理】"EULACheckFlag"= プライバシーポリシー・利用規約のページをきちんと開いた事を確認するFlag
// 【UserDefaults管理】"EULAagreement"= 利用規約に同意したかどうかの判定
// 【UserDefaults管理】"AccountDeleteFlag"= アカウント削除ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectDataFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectDataId"= 投稿画面で「リジェクト／管理」を押した投稿のID
// 【UserDefaults管理】"RejectIdArray"= 投稿画面で「リジェクト／管理」を押した投稿のIDをまとめた配列
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataId"= 投稿画面で「報告」を押した投稿のID
// 【UserDefaults管理】"UserPhotoURLFlag"= 投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"UserPhotoURL"= 投稿者のFacebookページを検索するためのURL
// 【UserDefaults管理】"UserPhotoName"= 投稿者のFacebookページを検索するためのName
// 【UserDefaults管理】"ContactRequestPost"= コンタクト通知をした対象の投稿ID
// 【UserDefaults管理】"ContactRequestUserID"= コンタクト通知をした相手のユーザーID
// 【UserDefaults管理】"ChatRequestFlag"= コンタクト通知一覧で、投稿者プロフィール画像を押した事を確認するFlag


import UIKit
import Foundation
import SVProgressHUD
import Firebase
import FirebaseAuth
import ESTabBarController


class AJAlertController: UIViewController {
    
    // MARK:- Private Properties
    // MARK:-

    private var strAlertTitle = "【同意確認】"
    private var strAlertText = String()
    private var btnCancelTitle:String?
    private var btnOtherTitle:String?
    
    private let btnOtherColor  = UIColor.blue
    private let btnCancelColor = UIColor.red
    
    // MARK:- Public Properties
    // MARK:-

    @IBOutlet var viewAlert: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAlertText: UILabel?
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnOther: UIButton!
    @IBOutlet var btnOK: UIButton!
    @IBOutlet var viewAlertBtns: UIView!
    @IBOutlet var alertWidthConstraint: NSLayoutConstraint!
    
    /// AlertController Completion handler
    typealias alertCompletionBlock = ((Int, String) -> Void)?
    private var block : alertCompletionBlock?
    
    // MARK:- AJAlertController Initialization
    // MARK:-
    
    /**
     Creates a instance for using AJAlertController
     - returns: AJAlertController
     */
    static func initialization() -> AJAlertController
    {
        let alertController = AJAlertController(nibName: "AJAlertController", bundle: nil)
        return alertController
    }
    
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    //RejectIdArrayの配列初期設定
    var rejectIdArray : [String] = []
    //RejectUserArrayの配列初期設定
    var rejectUserArray : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAJAlertController()
        
        //userDefaultsの初期値設定
        userDefaults.register(defaults: ["RejectIdArray" : [], "RejectUserArray" : []])
    }
    
    // MARK:- AJAlertController Private Functions
    // MARK:-
    
    /// Inital View Setup
    private func setupAJAlertController(){
        
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.alpha = 0.8
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(visualEffectView, at: 0)
        
        preferredAlertWidth()
        
        viewAlert.layer.cornerRadius  = 4.0
        viewAlert.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        viewAlert.layer.shadowColor   = UIColor(white: 0.0, alpha: 1.0).cgColor
        viewAlert.layer.shadowOpacity = 0.3
        viewAlert.layer.shadowRadius  = 3.0
       
        lblTitle.text   = strAlertTitle
        lblAlertText?.text   = strAlertText
        
        if let aCancelTitle = btnCancelTitle {
            btnCancel.setTitle(aCancelTitle, for: .normal)
            btnOK.setTitle(nil, for: .normal)
            btnCancel.setTitleColor(btnCancelColor, for: .normal)
        } else {
            btnCancel.isHidden  = true
        }
        
        if let aOtherTitle = btnOtherTitle {
            btnOther.setTitle(aOtherTitle, for: .normal)
            btnOK.setTitle(nil, for: .normal)
            btnOther.setTitleColor(btnOtherColor, for: .normal)
        } else {
            btnOther.isHidden  = true
        }
        
        if btnOK.title(for: .normal) != nil {
            btnOK.setTitleColor(btnOtherColor, for: .normal)
        } else {
            btnOK.isHidden  = true
        }
    }
    
    /// Setup different widths for iPad and iPhone
    private func preferredAlertWidth()
    {
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                alertWidthConstraint.constant = 280.0
            case .pad:
                alertWidthConstraint.constant = 340.0
            case .unspecified: break
            case .tv: break
            case .carPlay: break
        }
    }
    
    /// Create and Configure Alert Controller
    private func configure(message:String, btnCancelTitle:String?, btnOtherTitle:String?)
    {
        self.strAlertText          = message
        self.btnCancelTitle     = btnCancelTitle
        self.btnOtherTitle    = btnOtherTitle
    }
    
    /// Show Alert Controller
    private func show()
    {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            viewWillAppear(true)
            didMove(toParentViewController: topViewController)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.alpha = 0.0
            view.frame = topViewController.view.bounds
            
            viewAlert.alpha     = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.view.alpha = 1.0
            }, completion: nil)
            
            viewAlert.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-10)
            UIView.animate(withDuration: 0.2 , delay: 0.1, options: .curveEaseOut, animations: { () -> Void in
                self.viewAlert.alpha = 1.0
                self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0))
            }, completion: nil)
        }
    }
    
    /// Hide Alert Controller
    private func hide()
    {
        self.view.endEditing(true)
        self.viewAlert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.viewAlert.alpha = 0.0
            self.viewAlert.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.viewAlert.center    = CGPoint(x: (self.view.bounds.size.width/2.0), y: (self.view.bounds.size.height/2.0)-5)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            
        }) { (completed) -> Void in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    // MARK:- UIButton Clicks
    // MARK:-
    
    @IBAction func btnCancelTapped(sender: UIButton) {
        block!!(0,btnCancelTitle!)
        
        //アカウント削除ボタンを押された上で、「キャンセル」を選択した際のアクション
        let AccountDeleteFlag :String = userDefaults.string(forKey: "AccountDeleteFlag")!
        if AccountDeleteFlag == "YES" {
            //アカウント削除の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "AccountDeleteFlag")
            userDefaults.synchronize()
            print("再初期化：AccountDeleteFlag = 「NO」")
            hide()
            return
        }
        
        
        //リジェクトボタンを押された上で、「キャンセル」を選択した際のアクション
        let RejectFlag :String = userDefaults.string(forKey: "RejectDataFlag")!
        if RejectFlag == "YES" {
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "RejectDataFlag")
            userDefaults.synchronize()
            print("再初期化：RejectDataFlag = 「NO」")
            hide()
            return
        }
        
        
        //報告ボタンを押された上で、「キャンセル」を選択した際のアクション
        let CautionFlag :String = userDefaults.string(forKey: "CautionDataFlag")!
        if CautionFlag == "YES" {
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "CautionDataFlag")
            userDefaults.synchronize()
            print("再初期化：CautionDataFlag = 「NO」")
            hide()
            return
        }
        
        
        //投稿者ブロックボタンを押された上で、「キャンセル」を選択した際のアクション
        let RejectUserFlag :String = userDefaults.string(forKey: "RejectUserFlag")!
        if RejectUserFlag == "YES" {
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "RejectUserFlag")
            userDefaults.synchronize()
            print("再初期化：RejectUserFlag = 「NO」")
            hide()
            return
        }
        
        
        //投稿者プロフィール画像を押された上で、「Facebook検索」を選択した際のアクション
        let UserPhotoURLFlag :String = userDefaults.string(forKey: "UserPhotoURLFlag")!
        if UserPhotoURLFlag == "YES" {
            let UserPhotoURL :String = userDefaults.string(forKey: "UserPhotoURL")!
            
            //Facebookの検索ページをSafariで開くアクション
            let url = URL(string: "\(UserPhotoURL)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
            
            //チェックFlagの再初期化
            userDefaults.set("NO", forKey: "UserPhotoURLFlag")
            userDefaults.synchronize()
            print("再初期化：UserPhotoURLFlag = 「NO」")
            hide()
            return
        }
        
        
        //コンタクト通知一覧で気になるユーザーのプロフィール画像を押された上で、「まずはFacebook検索」を選択した際のアクション
        let ChatRequestFlag :String = userDefaults.string(forKey: "ChatRequestFlag")!
        if ChatRequestFlag == "YES" {
            let UserPhotoURL :String = userDefaults.string(forKey: "UserPhotoURL")!
            
            //Facebookの検索ページをSafariで開くアクション
            let url = URL(string: "\(UserPhotoURL)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
            
            //チェックFlagの再初期化
            userDefaults.set("NO", forKey: "ChatRequestFlag")
            userDefaults.synchronize()
            print("再初期化：ChatRequestFlag = 「NO」")
            hide()
            return
        }
        
        
        //プライバシーポリシー・利用規約のページをSafariで開くアクション
        let url = URL(string: "https://chan-sho.github.io/")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
            //プライバシーポリシー・利用規約のページをSafariで開いた事をFlagに反映("No" → "YES")
            userDefaults.set("YES", forKey: "EULACheckFlag")
            userDefaults.synchronize()
        }
    }
    
    
    @IBAction func btnOtherTapped(sender: UIButton) {
        block!!(1,btnOtherTitle!)
        
        //アカウント削除ボタンを押された上で、「削除」を選択した際のアクション
        let AccountDeleteFlag :String = userDefaults.string(forKey: "AccountDeleteFlag")!
        if AccountDeleteFlag == "YES" {
            hide()
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "【エラーが発生しました】\n\nアカウント削除を希望される場合は、お手数ですが再度お試し下さい。\n\n何度もエラーが発生する場合には、お手数ですがHRugRug管理人にご連絡をお願いします。")
                    return
                } else {
                    SVProgressHUD.showSuccess(withStatus: "【アカウント削除完了】\n\nRugRugをご愛顧頂き、\nありがとうございました！\n\nご希望・ご期待に添えず、\n大変申し訣ありませんでした。\n\nまたご利用頂ける際には、\n是非よろしくお願い致します。")
                    
                    // ログアウトする
                    try! Auth.auth().signOut()
                    //4秒後にアプリを閉じる
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                        exit(0)
                    }
                }
            }
            return
        }
        
        
        //リジェクトボタンを押された上で、「今後表示しない」を選択した際のアクション
        let RejectFlag :String = userDefaults.string(forKey: "RejectDataFlag")!
        if RejectFlag == "YES" {
            
            let rejectDataId :String = userDefaults.string(forKey: "RejectDataId")!
            rejectIdArray = userDefaults.array(forKey: "RejectIdArray") as! [String]
            rejectIdArray.append(rejectDataId)
            //確認
            print("\(rejectIdArray)")
            
            //追加した"RejectDataId"を"RejectIdArray"の配列要素に追加
            userDefaults.set(rejectIdArray, forKey: "RejectIdArray")
            userDefaults.synchronize()
            
            //Firebaseに保存する
            let uid = Auth.auth().currentUser?.uid
            let postRef = Database.database().reference().child(Const.PostPath).child(rejectDataId)
            let rejects = ["Reject-By-(\(uid!))": uid]
            postRef.updateChildValues(rejects)
            
            hide()
            
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "RejectDataFlag")
            userDefaults.synchronize()
            print("再初期化：RejectDataFlag = 「NO」")
            
            SVProgressHUD.showSuccess(withStatus: "対象の投稿は、貴方の投稿一覧に表示されなくなりました。")
            
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
        
        
        //報告ボタンを押された上で、「管理人に報告」を選択した際のアクション
        let CautionFlag :String = userDefaults.string(forKey: "CautionDataFlag")!
        if CautionFlag == "YES" {
            hide()
            
            let cautionPostId :String = userDefaults.string(forKey: "CautionDataId")!
            //FireBase上に辞書型データで残す処理
            //postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            //**重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const4.PostPath4)
            let postDic = ["userID": Auth.auth().currentUser!.uid, "time": String(time), "name": name!, "cautionPostId": cautionPostId, "checkFlag": ""] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "CautionDataFlag")
            userDefaults.synchronize()
            print("再初期化：CautionDataFlag = 「NO」")
            
            SVProgressHUD.showSuccess(withStatus: "\(name!)さん\n\n好ましくない投稿のご報告、ありがとうございました！\n24時間以内に精査し、適切な処置（削除／警告）をします。")
            
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
        
        
        //投稿者ブロックボタンを押された上で、「投稿者ブロック」を選択した際のアクション
        let RejectUserFlag :String = userDefaults.string(forKey: "RejectUserFlag")!
        if RejectUserFlag == "YES" {
            
            let rejectDataId :String = userDefaults.string(forKey: "RejectDataId")!
            
            let rejectUserId :String = userDefaults.string(forKey: "RejectUserId")!
            rejectUserArray = userDefaults.array(forKey: "RejectUserArray") as! [String]
            rejectUserArray.append(rejectUserId)
            //確認
            print("\(rejectUserArray)")
            
            //追加した"RejectUserId"を"RejectUserArray"の配列要素に追加
            userDefaults.set(rejectUserArray, forKey: "RejectUserArray")
            userDefaults.synchronize()
            
            //Firebaseに保存する
            let uid = Auth.auth().currentUser?.uid
            let postRef = Database.database().reference().child(Const.PostPath).child(rejectDataId)
            let rejects = ["User-Reject-By-(\(uid!))": uid]
            postRef.updateChildValues(rejects)
            
            hide()
            
            //報告の2重チェックに使うFlagの再初期化
            userDefaults.set("NO", forKey: "RejectUserFlag")
            userDefaults.synchronize()
            print("再初期化：RejectUserFlag = 「NO」")
            
            SVProgressHUD.showSuccess(withStatus: "この投稿者の全ての投稿が、今後は貴方の投稿一覧に表示されなくなりました。")
            
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
        
        
        //投稿者プロフィール画像を押された上で、「通知＋Facebook検索」を選択した際のアクション
        let UserPhotoURLFlag :String = userDefaults.string(forKey: "UserPhotoURLFlag")!
        if UserPhotoURLFlag == "YES" {
            let UserPhotoName :String = userDefaults.string(forKey: "UserPhotoName")!
            let UserPhotoURL :String = userDefaults.string(forKey: "UserPhotoURL")!
            let ContactRequestPost :String = userDefaults.string(forKey: "ContactRequestPost")!
            let ContactRequestUserID :String = userDefaults.string(forKey: "ContactRequestUserID")!
            
            //FireBase上に辞書型データで残す処理
            //postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            //ログインユーザーのプロフィール画像をロード
            let UserProfileURL = (Auth.auth().currentUser?.photoURL?.absoluteString)! + "?width=140&height=140"
            
            //**重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const5.PostPath5)
            let postDic = ["AskUserID": Auth.auth().currentUser!.uid, "time": String(time), "AskUserName": name!, "AskUserURL": UserProfileURL, "RequestedUserID": ContactRequestUserID, "RequestedUserName": UserPhotoName, "RequestedPostID": ContactRequestPost,"checkFlag": "", "ChatRequest": ""] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            //Facebookの検索ページをSafariで開くアクション
            let url = URL(string: "\(UserPhotoURL)")
            if url == nil {
                print("NG")
                return
            }
            else {
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!)
                }
            }
            
            //チェックFlagの再初期化
            userDefaults.set("NO", forKey: "UserPhotoURLFlag")
            userDefaults.synchronize()
            print("再初期化：UserPhotoURLFlag = 「NO」")
            hide()
            return
        }
        
        
        //投稿者プロフィール画像を押された上で、「通知＋Facebook検索」を選択した際のアクション
        let ChatRequestFlag :String = userDefaults.string(forKey: "ChatRequestFlag")!
        if ChatRequestFlag == "YES" {
            let UserPhotoName :String = userDefaults.string(forKey: "UserPhotoName")!
            let ContactRequestPost :String = userDefaults.string(forKey: "ContactRequestPost")!
            let ContactRequestUserID :String = userDefaults.string(forKey: "ContactRequestUserID")!
            
            //FireBase上に辞書型データで残す処理
            //postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            //ログインユーザーのプロフィール画像をロード
            let UserProfileURL = (Auth.auth().currentUser?.photoURL?.absoluteString)! + "?width=140&height=140"
            
            //**重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const5.PostPath5)
            let postDic = ["AskUserID": Auth.auth().currentUser!.uid, "time": String(time), "AskUserName": name!, "AskUserURL": UserProfileURL, "RequestedUserID": ContactRequestUserID, "RequestedUserName": UserPhotoName, "RequestedPostID": ContactRequestPost,"checkFlag": "", "ChatRequest": "まずはチャットしませんか？↓ click"] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            //チェックFlagの再初期化
            userDefaults.set("NO", forKey: "ChatRequestFlag")
            userDefaults.synchronize()
            print("再初期化：ChatRequestFlag = 「NO」")
            hide()
            
            SVProgressHUD.showSuccess(withStatus: "コンタクト通知をもらったこちらユーザーに、「まずはチャットしませんか？」と通知を送りました！")
            
            return
        }
        
        
        let EULACheckFlag :String = userDefaults.string(forKey: "EULACheckFlag")!
        if EULACheckFlag == "NO" {
            SVProgressHUD.showError(withStatus: "【ご注意・お願い】\n\nリンクから内容を必ずご確認頂いた上で、同意するかどうかご判断ください。\n\nユーザー様の大切な個人情報を扱わせて頂くアプリですので、ご理解をお願い致します！")
            return
        }
        else {
            //利用規約同意済みのYESをUserDefaultsに保存する
            userDefaults.set("YES", forKey: "EULAagreement")
            userDefaults.set("YES", forKey: "InitialFlag")
            userDefaults.synchronize()
            hide()
            
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @IBAction func btnOkTapped(sender: UIButton) 
    {
        block!!(0,"OK")
        hide()
    }
    
    /// Hide Alert Controller on background tap
    @objc func backgroundViewTapped(sender:AnyObject)
    {
        hide()
    }

    // MARK:- AJAlert Functions
    // MARK:-

    /**
     Display an Alert
     
     - parameter aStrMessage:    Message to display in Alert
     - parameter aCancelBtnTitle: Cancel button title
     - parameter aOtherBtnTitle: Other button title
     - parameter otherButtonArr: Array of other button title
     - parameter completion:     Completion block. Other Button Index - 1 and Cancel Button Index - 0
     */
    
    public func showAlert( aStrMessage:String,
                    aCancelBtnTitle:String?,
                    aOtherBtnTitle:String? ,
                    completion : alertCompletionBlock){
        configure( message: aStrMessage, btnCancelTitle: aCancelBtnTitle, btnOtherTitle: aOtherBtnTitle)
        show()
        block = completion
    }
    
    /**
     Display an Alert With "OK" Button
     
     - parameter aStrMessage: Message to display in Alert
     - parameter completion:  Completion block. OK Button Index - 0
     */
    
    public func showAlertWithOkButton( aStrMessage:String,
                                completion : alertCompletionBlock){
        configure(message: aStrMessage, btnCancelTitle: nil, btnOtherTitle: nil)
        show()
        block = completion
    }
 }

