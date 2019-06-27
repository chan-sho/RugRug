//
//  Match-Contact.swift
//  RugRug
//
//  Created by 高野翔 on 2019/03/19.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit


class Match_Contact: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var twoIDArray: [String] = []
    var twoMatchIDArray: [String] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HUDで投稿完了を表示する
        SVProgressHUD.show(withStatus: "データ読み込み中です。")
        SVProgressHUD.dismiss(withDelay: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false

        //userDefaultsの初期値設定（念の為）
        userDefaults.register(defaults: ["MatchYesArray" : []])
        
        let nib = UINib(nibName: "MatchDoneTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell-7")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 280
        
        //separatorを左端始まりにして、色指定
        tableView.separatorColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        tableView.separatorInset = .zero
        
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
                let postsRef = Database.database().reference().child(Const8.PostPath8)
                postsRef.observe(.childAdded, with: { snapshot in
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        let idCheck = self.userDefaults.string(forKey: "MatchID")!
                        let matchYesArray = self.userDefaults.array(forKey: "MatchYesArray") as! [String]
                        self.userDefaults.synchronize()
                        
                        // 始めのinsertの段階で"Match-YES"にidCheckを含むデータのみ抽出する
                        if postData.MatchYes.contains(idCheck) && matchYesArray.contains(postData.id!) {
                            self.postArray.insert(postData, at: 0)
                        }
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
                // 要素が【変更】されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                //postsRef.observe(.childChanged, with: { snapshot in
                
                //if let uid = Auth.auth().currentUser?.uid {
                // PostDataクラスを生成して受け取ったデータを設定する
                //let postData = PostData(snapshot: snapshot, myId: uid)
                
                // 保持している配列からidが同じものを探す
                //var index: Int = 0
                //for post in self.postArray {
                //if post.id == postData.id {
                //index = self.postArray.index(of: post)!
                //break
                //}
                //}
                // 差し替えるため一度削除する
                //self.postArray.remove(at: index)
                // 削除したところに更新済みのデータを追加する
                //self.postArray.insert(postData, at: index)
                // TableViewを再表示する
                //self.tableView.reloadData()
                //}
                //})
                
                // 要素が【削除】されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                //postsRef.observe(.childRemoved, with: { snapshot in
                
                //if let uid = Auth.auth().currentUser?.uid {
                // PostDataクラスを生成して受け取ったデータを設定する
                //let postData = PostData(snapshot: snapshot, myId: uid)
                
                // 保持している配列からidが同じものを探す
                //var index: Int = 0
                //for post in self.postArray {
                //if post.id == postData.id {
                //index = self.postArray.index(of: post)!
                //break
                //}
                //}
                
                // 削除する
                //self.postArray.remove(at: index)
                
                // TableViewを再表示する
                //self.tableView.reloadData()
                //}
                //})
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // tableviewの行数をカウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    
    // tablewviewのcellにデータを受け渡すfunc
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-7", for: indexPath) as! MatchDoneTableCell
        cell.setPostData7(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.userPhotoButton.addTarget(self, action:#selector(handleUserPhotoButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のeditボタンを追加で管理
        cell.chatButton.addTarget(self, action:#selector(handleChatButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }

    
    // セル内のuserPhotoボタンがタップされた時に呼ばれるメソッド
    @objc func handleUserPhotoButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        // 配列からタップされたインデックスのデータを取り出す
        postData = postArray[indexPath!.row]
        
        //タップを検知されたpostDataからnameを抽出する
        let userPhotoName = postData.name
        
        //クリップボードにuserNameを保存する
        let pasteboard: UIPasteboard = UIPasteboard.general
        pasteboard.string = "\(userPhotoName!)"
        
        let userURL : String = "https://www.facebook.com"
        
        var userPhotoURL = userURL.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        userPhotoURL = userPhotoURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        //userDefaultsに必要なデータを保存（7×7からの使い回し）
        userDefaults.set("YES", forKey: "UserPhotoURLFlagof7x7")
        userDefaults.set(userPhotoName, forKey: "UserPhotoName")
        userDefaults.set(userPhotoURL, forKey: "UserPhotoURL")
        userDefaults.synchronize()
        showAlertWithVC()
        return
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
        //自身の投稿ナンバー(MatchID)を抽出する
        let myselfMatchID = userDefaults.string(forKey: "MatchID")
        
        //上記2つのIDを配列に入れる
        twoIDArray.append("\(chatDataId!)")
        twoIDArray.append("\(myselfMatchID!)")
        print("twoIDArray = \(twoIDArray)")
        
        //配列の要素を昇順にならべかえる
        twoMatchIDArray = twoIDArray.sorted(by: <)
        print("twoMatchIDArray = \(twoMatchIDArray)")
        
        //配列の要素を連結する
        let twoMatchIDs = twoMatchIDArray.joined(separator: "+")
        print("twoMatchIDs = \(twoMatchIDs)")
        
        userDefaults.set(twoMatchIDs, forKey: "ChatDataId")
        userDefaults.synchronize()
        
        //全配列の初期化
        twoIDArray = []
        twoMatchIDArray = []
        
        //Chatに移動
        self.performSegue(withIdentifier: "toChatMatch", sender: nil)
    }
    

    //最終確認ポップアップページを出す
    func showAlertWithVC(){
        
        let UserPhotoURLFlagof7x7 :String = userDefaults.string(forKey: "UserPhotoURLFlagof7x7")!
        if UserPhotoURLFlagof7x7 == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "このユーザーを検索する為に、\n「ユーザー名」をコピーし、\nFacebookに移動します。\n\n(※ペーストして検索が出来ます)", aCancelBtnTitle: "いいえ", aOtherBtnTitle: "はい") { (index, title) in
                print(index,title)
            }
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
