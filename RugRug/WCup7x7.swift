//
//  WCup7x7.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/28.
//  Copyright © 2019 高野翔. All rights reserved.
//
// 【UserDefaults管理】"revise7x7Id"= 投稿画面で「編集」を押した7x7のID
// 【UserDefaults管理】"Reject7x7Id"= 投稿画面で「リジェクト／管理」を押した7x7のID
// 【UserDefaults管理】"Reject7x7UserId"= 投稿画面で「リジェクト／管理」を押した投稿者のID
// 【UserDefaults管理】"Caution7x7Id"= 投稿画面で「報告」を押した7x7のID
// 【UserDefaults管理】"Reject7x7Array"= 投稿画面で「リジェクト／管理」を押した7x7のIDをまとめた配列
// 【UserDefaults管理】"Reject7x7UserArray"= 投稿画面で「リジェクト／管理」を押した7x7投稿者のIDをまとめた配列
// 【UserDefaults管理】"UserPhotoURLFlagof7x7"= 投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"ChatDataId"= チャットをしたい対象の投稿ID
// 【UserDefaults管理】"Chat7x7Flag"= 7x7でチャットボタンを押した事を確認するFlag


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit


class WCup7x7: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // HUDで投稿完了を表示する
        SVProgressHUD.show(withStatus: "データ読み込み中です。\nData Loading")
        SVProgressHUD.dismiss(withDelay: 2.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //separatorを左端始まりにして、黒色にする
        tableView.separatorColor = UIColor.darkGray
        tableView.separatorInset = .zero
        
        let nib = UINib(nibName: "New7x7TableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell-5")
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        newPostButton.isExclusiveTouch = true
        backButton.isExclusiveTouch = true
        hintButton.isExclusiveTouch = true
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 410
        
        //userDefaultsの初期値設定（念の為）
        userDefaults.register(defaults: ["Reject7x7Array" : [], "UserPhotoURLFlag" : "NO", "Reject7x7UserArray" : [], "UserPhotoURLFlagof7x7" : "NO", "Chat7x7Flag" : "NO"])
        
        // TableViewを再表示する
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // TableViewを再表示する（※superの前に入れておくのが大事！！）
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が【追加】されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const7.PostPath7)
                postsRef.observe(.childAdded, with: { snapshot in
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        self.postArray.insert(postData, at: 0)
                        
                        let reject7x7Array = self.userDefaults.array(forKey: "Reject7x7Array") as! [String]
                        let reject7x7UserArray = self.userDefaults.array(forKey: "Reject7x7UserArray") as! [String]
                        // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                        if reject7x7Array != [] {
                            // Reject7x7Arrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray1 = self.postArray
                            for n in reject7x7Array {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArray = rejectedArray1
                        }
                        
                        if reject7x7UserArray != [] {
                            // Reject7x7UserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray1R = self.postArray
                            for n in reject7x7UserArray {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArray = rejectedArray1R
                        }
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                // 要素が【変更】されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                            // 保持している配列からidが同じものを探す
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 差し替えるため一度削除する
                            self.postArray.remove(at: index)
                            
                            // 削除したところに更新済みのデータを追加する
                            self.postArray.insert(postData, at: index)

                            let reject7x7Array = self.userDefaults.array(forKey: "Reject7x7Array") as! [String]
                            let reject7x7UserArray = self.userDefaults.array(forKey: "Reject7x7UserArray") as! [String]
                            // 【※追加アクション】Reject7x7Arrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if reject7x7Array != [] {
                                // Reject7x7Arrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in reject7x7Array {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if reject7x7UserArray != [] {
                                // Reject7x7UserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in reject7x7UserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
 
                    }
                })
                
                // 要素が【削除】されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childRemoved, with: { snapshot in
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                            // 保持している配列からidが同じものを探す
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 削除する
                            self.postArray.remove(at: index)
                            
                            let reject7x7Array = self.userDefaults.array(forKey: "Reject7x7Array") as! [String]
                            let reject7x7UserArray = self.userDefaults.array(forKey: "Reject7x7UserArray") as! [String]
                            // 【※追加アクション】Reject7x7Arrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if reject7x7Array != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in reject7x7Array {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if reject7x7UserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in reject7x7UserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                    }
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.dataSource = self
        // TableViewを再表示する
        self.tableView.reloadData()
    }
    
    
    // tableviewの行数をカウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    
    // tablewviewのcellにデータを受け渡すfunc
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-5", for: indexPath) as! New7x7TableCell
        cell.setPostData5(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のeditボタンを追加で管理
        cell.chatButton.addTarget(self, action:#selector(handleChatButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のeditボタンを追加で管理
        cell.editButton.addTarget(self, action:#selector(handleEditButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のuserPhotoボタンを追加で管理
        cell.userPhotoButton.addTarget(self, action:#selector(handleUserPhotoButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    
    // セル内のlikeボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        // 配列からタップされたインデックスのデータを取り出す
        postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            // 増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const7.PostPath7).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
    }
    
    
    //セル内のEditボタンが押された時に呼ばれるメソッド
    @objc func handleEditButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        // 配列からタップされたインデックスのデータを取り出す
        postData = postArray[indexPath!.row]
        
        //タップを検知されたpostDataから投稿ナンバー/投稿者を抽出する
        let revise7x7Id = postData.id
        let reject7x7UserId = postData.userID
        
        //Editボタンを押したユーザーが投稿者本人かどうかの判断
        let uid = Auth.auth().currentUser?.uid
        let userID = postData.userID
        if userID == uid {
            userDefaults.set(revise7x7Id, forKey: "revise7x7Id")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "toRevise7x7", sender: nil)
        }
        else {
            //reject、cautionの意思がある投稿のID、投稿者のID
            userDefaults.set(revise7x7Id, forKey: "Reject7x7Id")
            userDefaults.set(revise7x7Id, forKey: "Caution7x7Id")
            userDefaults.set(reject7x7UserId, forKey: "Reject7x7UserId")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "toReject7x7", sender: nil)
        }
    }
    
    
    //セル内のuserPhotoボタンが押された時に呼ばれるメソッド
    @objc func handleUserPhotoButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        
        //ボタンを押したユーザーが投稿者本人かどうかの判断
        let uid = Auth.auth().currentUser?.uid
        let userID = postData.userID
        
        if userID != uid {
            
            //タップを検知されたpostDataからnameを抽出する
            let userPhotoName = postData.name
            
            let userURL : String = "https://www.facebook.com/search/str/\(userPhotoName!)/keywords_search"
            print("\(userURL)")
            var userPhotoURL = userURL.replacingOccurrences(of: " ", with: "", options: .regularExpression)
            userPhotoURL = userPhotoURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            print("\(userPhotoURL)")
            
            //userDefaultsに必要なデータを保存
            userDefaults.set("YES", forKey: "UserPhotoURLFlagof7x7")
            userDefaults.set(userPhotoName, forKey: "UserPhotoName")
            userDefaults.set(userPhotoURL, forKey: "UserPhotoURL")
            userDefaults.synchronize()
            showAlertWithVC()
            return
        }
    }
    
    
    //セル内のチャットボタンが押された時に呼ばれるメソッド
    @objc func handleChatButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        // 配列からタップされたインデックスのデータを取り出す
        postData = postArray[indexPath!.row]
        
        //タップを検知されたpostDataから投稿ナンバーを抽出する
        let chatDataId = postData.id
        
        userDefaults.set(chatDataId, forKey: "ChatDataId")
        userDefaults.set("YES", forKey: "Chat7x7Flag")
        userDefaults.synchronize()
        //Chatに移動
        self.performSegue(withIdentifier: "toChat7x7", sender: nil)
        
    }
    
    
    //最終確認ポップアップページを出す
    func showAlertWithVC(){
        
        let UserPhotoURLFlagof7x7 :String = userDefaults.string(forKey: "UserPhotoURLFlagof7x7")!
        if UserPhotoURLFlagof7x7 == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今からFacebookでこのユーザーを検索します！\n\nLet's search this user on Facebook now !", aCancelBtnTitle: "いいえ / NO", aOtherBtnTitle: "はい / YES") { (index, title) in
                print(index,title)
            }
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
