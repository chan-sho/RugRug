//
//  Post.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"reviseDataId"= 投稿画面で「編集」を押した投稿のID

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController


class Post: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearchBar: UISearchBar!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var newPostButton2: UIButton!
    
    
    var postArray: [PostData] = []
    var postArrayBySearch: [PostData] = []
    var postArrayAll: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // HUDで投稿完了を表示する
        SVProgressHUD.show(withStatus: "データ読み込み中です。\n※一番最初のデータ読み込みには時間がかかる事があります。")
        SVProgressHUD.dismiss(withDelay: 4.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //separatorを左端始まりにして、黒色にする
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = .zero
        
        textSearchBar.delegate = self
        textSearchBar.placeholder = "キーワードで検索"
        //何も入力されていなくてもReturnキーを押せるようにする。
        textSearchBar.enablesReturnKeyAutomatically = false
        
        let nib = UINib(nibName: "PostTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 220
        
        // TableViewを再表示する
        self.tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        // TableViewを再表示する（※superの前に入れておくのが大事！！）
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が【追加】されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 始めのinsertの段階でuidと異なるmySecret(ID)の投稿データを除いておく
                        if postData.mySecret == [] || postData.mySecret.contains(uid) {
                            
                            self.postArray.insert(postData, at: 0)
                            // 念のため同じデータをpostArrayAllに入れておく
                            self.postArrayAll.insert(postData, at: 0)
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
                        
                        // 検索バーのテキスト有無で場合分け
                        if self.textSearchBar.text == "" {
                            // 保持している配列からidが同じものを探す
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArrayAll用）
                            var indexAll: Int = 0
                            for post in self.postArrayAll {
                                if post.id == postData.id {
                                    indexAll = self.postArrayAll.index(of: post)!
                                    break
                                }
                            }
                            
                            // 差し替えるため一度削除する
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            // 削除したところに更新済みのデータを追加する
                            self.postArray.insert(postData, at: index)
                            self.postArrayAll.insert(postData, at: indexAll)
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
                        // 検索バーにテキストが打たれている場合
                        else {
                            // 保持している配列からidが同じものを探す
                            var indexBySearch: Int = 0
                            for post in self.postArrayBySearch {
                                if post.id == postData.id {
                                    indexBySearch = self.postArrayBySearch.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArray用）
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArrayAll用）
                            var indexAll: Int = 0
                            for post in self.postArrayAll {
                                if post.id == postData.id {
                                    indexAll = self.postArrayAll.index(of: post)!
                                    break
                                }
                            }
                            
                            // 差し替えるため一度削除する
                            self.postArrayBySearch.remove(at: indexBySearch)
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            // 削除したところに更新済みのデータを追加する
                            self.postArrayBySearch.insert(postData, at: indexBySearch)
                            self.postArray.insert(postData, at: index)
                            self.postArrayAll.insert(postData, at: indexAll)
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
                    }
                })
                
                // 要素が【削除】されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childRemoved, with: { snapshot in
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 検索バーのテキスト有無で場合分け
                        if self.textSearchBar.text == "" {
                            // 保持している配列からidが同じものを探す
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArrayAll用）
                            var indexAll: Int = 0
                            for post in self.postArrayAll {
                                if post.id == postData.id {
                                    indexAll = self.postArrayAll.index(of: post)!
                                    break
                                }
                            }
                            
                            // 削除する
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
                        // 検索バーにテキストが打たれている場合
                        else {
                            
                            // 保持している配列からidが同じものを探す
                            var indexBySearch: Int = 0
                            for post in self.postArrayBySearch {
                                if post.id == postData.id {
                                    indexBySearch = self.postArrayBySearch.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArray用）
                            var index: Int = 0
                            for post in self.postArray {
                                if post.id == postData.id {
                                    index = self.postArray.index(of: post)!
                                    break
                                }
                            }
                            
                            // 保持している配列からidが同じものを探す（※postArrayAll用）
                            var indexAll: Int = 0
                            for post in self.postArrayAll {
                                if post.id == postData.id {
                                    indexAll = self.postArrayAll.index(of: post)!
                                    break
                                }
                            }
                            
                            // 削除する
                            self.postArrayBySearch.remove(at: indexBySearch)
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
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
                postArrayAll = []
                postArrayBySearch = []
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
    
    
    // Returnボタンを押した際にキーボードを消す
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    
    //検索バーでテキストが空白時 or テキスト入力時の呼び出しメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if textSearchBar.text == "" {
            self.tableView.reloadData()
        }
            
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            
            self.tableView.reloadData()
        }
    }
    
    
    // tableviewの行数をカウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if textSearchBar.text == "" {
            return postArray.count
        }
        else {
            return postArrayBySearch.count
        }
    }
    
    
    // tablewviewのcellにデータを受け渡すfunc
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if textSearchBar.text == "" {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableCell
            cell.setPostData(postArray[indexPath.row])
            
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のreviseボタンを追加で管理
            cell.reviseButton.addTarget(self, action:#selector(handleReviseButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のuserPhotoボタンを追加で管理
            cell.userPhotoButton.addTarget(self, action:#selector(handleUserPhotoButton(_:forEvent:)), for: .touchUpInside)
            
            return cell
        }
            
        else {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableCell
            cell.setPostData(postArrayBySearch[indexPath.row])
            
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のreviseボタンを追加で管理
            cell.reviseButton.addTarget(self, action:#selector(handleReviseButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のuserPhotoボタンを追加で管理
            cell.userPhotoButton.addTarget(self, action:#selector(handleUserPhotoButton(_:forEvent:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
    // セル内のlikeボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        if textSearchBar.text == "" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        }
        
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        
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
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
    }
    
    
    //セル内のReviseボタンが押された時に呼ばれるメソッド
    @objc func handleReviseButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        if textSearchBar.text == "" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        }
        
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        
        //タップを検知されたpostDataから投稿ナンバーを抽出する
        let reviseDataId = postData.id
        
        //Reviseボタンを押したユーザーが投稿者本人かどうかの判断
        let uid = Auth.auth().currentUser?.uid
        let userID = postData.userID
        if userID == uid {
            userDefaults.set(reviseDataId, forKey: "reviseDataId")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "toRevise", sender: nil)
        }
        else {
            return
        }
    }
    
    
    //セル内のuserPhotoボタンが押された時に呼ばれるメソッド
    @objc func handleUserPhotoButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        if let facebookUid = Auth.auth().currentUser?.providerData
            .filter({ (userInfo: UserInfo) in return userInfo.providerID == FacebookAuthProviderID})
            .map({ (userInfo: UserInfo) in return userInfo.uid})
            .first {
            print ("FaceBookのユーザーID = \(facebookUid)")
            }
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        if textSearchBar.text == "" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        }
            
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        
        //タップを検知されたpostDataからnameを抽出する
        let userPhotoName = postData.name
        let userURL : String = "https://www.facebook.com/search/str/\(userPhotoName!)/keywords_search"
        print("\(userURL)")
        let userPhotoURL = userURL.replacingOccurrences(of: " ", with: "", options: .regularExpression)
        print("\(userPhotoURL)")
        
        //Facebookの検索ページをSafariで開くアクション
        let url = URL(string: "\(userPhotoURL)")
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
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
