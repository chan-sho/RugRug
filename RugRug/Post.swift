//
//  Post.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"reviseDataId"= 投稿画面で「編集」を押した投稿のID
// 【UserDefaults管理】"RejectDataId"= 投稿画面で「リジェクト／管理」を押した投稿のID
// 【UserDefaults管理】"RejectUserId"= 投稿画面で「リジェクト／管理」を押した投稿者のID
// 【UserDefaults管理】"RejectIdArray"= 投稿画面で「リジェクト／管理」を押した投稿のIDをまとめた配列
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataId"= 投稿画面で「報告」を押した投稿のID
// 【UserDefaults管理】"UserPhotoURLFlag"= 投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"UserPhotoURL"= 投稿者のFacebookページを検索するためのURL
// 【UserDefaults管理】"UserPhotoName"= 投稿者のFacebookページを検索するためのName
// 【UserDefaults管理】"ContactRequestPost"= コンタクト通知をした対象の投稿ID
// 【UserDefaults管理】"ContactRequestUserID"= コンタクト通知をした相手のユーザーID
// 【UserDefaults管理】"ChatDataId"= チャットをしたい対象の投稿ID


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController
import FBSDKCoreKit
import FBSDKLoginKit


class Post: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearchBar: UISearchBar!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var newPostButton2: UIButton!
    
    
    var postArray: [PostData] = []
    var postArrayBySearch: [PostData] = []
    var postArrayAll: [PostData] = []
    var postArrayOfCheckedPost: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // HUDで投稿完了を表示する
        SVProgressHUD.show(withStatus: "データ読み込み中です。\n※一番最初のデータ読み込みには時間がかかる事があります。")
        SVProgressHUD.dismiss(withDelay: 2.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //separatorを左端始まりにして、黒色にする
        tableView.separatorColor = UIColor.white
        tableView.separatorInset = .zero
        
        
        textSearchBar.delegate = self
        textSearchBar.placeholder = "キーワードで検索"
        //何も入力されていなくてもReturnキーを押せるようにする。
        textSearchBar.enablesReturnKeyAutomatically = false
        
        //searchBarの背景をカスタマイズ
        let barImageView = textSearchBar.value(forKey: "_background") as! UIImageView
        barImageView.removeFromSuperview()
        textSearchBar.backgroundColor = UIColor.white
        let textField = textSearchBar.value(forKey: "_searchField") as! UITextField
        textField.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)
        
        let nib = UINib(nibName: "PostTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 250
        
        //userDefaultsの初期値設定（念の為）
        userDefaults.register(defaults: ["RejectIdArray" : [], "UserPhotoURLFlag" : "NO", "RejectUserArray" : [], "ChatRequestFlag" : "NO"])
        
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
                        
                        self.postArray.insert(postData, at: 0)
                        // 念のため同じデータをpostArrayAllに入れておく
                        self.postArrayAll.insert(postData, at: 0)
                        
                        let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                        let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                        // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                        if rejectIdArray != [] {
                            // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray1 = self.postArray
                            for n in rejectIdArray {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArray = rejectedArray1
                        }
                        
                        if rejectUserArray != [] {
                            // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray1R = self.postArray
                            for n in rejectUserArray {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArray = rejectedArray1R
                        }
                        
                        // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                        if rejectIdArray != [] {
                            // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray2 = self.postArrayAll
                            for n in rejectIdArray {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArrayAll = rejectedArray2
                        }
                        
                        if rejectUserArray != [] {
                            // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                            var rejectedArray2R = self.postArrayAll
                            for n in rejectUserArray {
                                //filterの後の「!」が結果を反転している→含まない！！！
                                rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                            }
                            self.postArrayAll = rejectedArray2R
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
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
                        
                        else if self.textSearchBar.text == "【※抽出中】" {
                            // 保持している配列からidが同じものを探す
                            var indexOfCheckedPost: Int = 0
                            for post in self.postArrayOfCheckedPost {
                                if post.id == postData.id {
                                    indexOfCheckedPost = self.postArrayOfCheckedPost.index(of: post)!
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
                            self.postArrayOfCheckedPost.remove(at: indexOfCheckedPost)
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            // 削除したところに更新済みのデータを追加する
                            self.postArrayOfCheckedPost.insert(postData, at: indexOfCheckedPost)
                            self.postArray.insert(postData, at: index)
                            self.postArrayAll.insert(postData, at: indexAll)
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArrayOfCheckedPost用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3 = self.postArrayOfCheckedPost
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3 = rejectedArray3.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayOfCheckedPost = rejectedArray3
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3R = self.postArrayOfCheckedPost
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3R = rejectedArray3R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayOfCheckedPost = rejectedArray3R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
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
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArrayBySearch用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3 = self.postArrayBySearch
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3 = rejectedArray3.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayBySearch = rejectedArray3
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3R = self.postArrayBySearch
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3R = rejectedArray3R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayBySearch = rejectedArray3R
                            }
                            
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
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
                            // TableViewを再表示する
                            self.tableView.reloadData()
                        }
                        else if self.textSearchBar.text == "【※抽出中】" {
                            // 保持している配列からidが同じものを探す
                            var indexOfCheckedPost: Int = 0
                            for post in self.postArrayOfCheckedPost {
                                if post.id == postData.id {
                                    indexOfCheckedPost = self.postArrayOfCheckedPost.index(of: post)!
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
                            self.postArrayOfCheckedPost.remove(at: indexOfCheckedPost)
                            self.postArray.remove(at: index)
                            self.postArrayAll.remove(at: indexAll)
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArrayOfCheckedPost用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3 = self.postArrayOfCheckedPost
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3 = rejectedArray3.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayOfCheckedPost = rejectedArray3
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3R = self.postArrayOfCheckedPost
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3R = rejectedArray3R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayOfCheckedPost = rejectedArray3R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
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
                            
                            let rejectIdArray = self.userDefaults.array(forKey: "RejectIdArray") as! [String]
                            let rejectUserArray = self.userDefaults.array(forKey: "RejectUserArray") as! [String]
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1 = self.postArray
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1 = rejectedArray1.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray1R = self.postArray
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray1R = rejectedArray1R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArray = rejectedArray1R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArray用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2 = self.postArrayAll
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2 = rejectedArray2.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray2R = self.postArrayAll
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray2R = rejectedArray2R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayAll = rejectedArray2R
                            }
                            
                            // 【※追加アクション】RejectIdArrayに含まれるリジェクト対象の投稿IDから該当のpostDataを削除する（postArrayBySearch用）
                            if rejectIdArray != [] {
                                // RejectIdArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3 = self.postArrayBySearch
                                for n in rejectIdArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3 = rejectedArray3.filter({ (!($0.id?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayBySearch = rejectedArray3
                            }
                            
                            if rejectUserArray != [] {
                                // RejectUserArrayの投稿IDを含まないデータのみpostArrayに入れ直す
                                var rejectedArray3R = self.postArrayBySearch
                                for n in rejectUserArray {
                                    //filterの後の「!」が結果を反転している→含まない！！！
                                    rejectedArray3R = rejectedArray3R.filter({ (!($0.userID?.localizedCaseInsensitiveContains(n))!) })
                                }
                                self.postArrayBySearch = rejectedArray3R
                            }
                            
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
                postArrayOfCheckedPost = []
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
        else if self.textSearchBar.text == "【※抽出中】" {
            let RequestedPostID :String = userDefaults.string(forKey: "RequestedPostID")!
            
            let array = RequestedPostID.components(separatedBy: NSCharacterSet.whitespaces)
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter{($0.id?.contains(n))!}
            }
            postArrayOfCheckedPost = tempFilteredArray
            
            self.tableView.reloadData()
        }
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))! ||  ($0.id?.localizedCaseInsensitiveContains(n))!})
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
        else if self.textSearchBar.text == "【※抽出中】" {
            return postArrayOfCheckedPost.count
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
            
            // セル内のcautionPhotoボタンを追加で管理
            cell.cautionButton.addTarget(self, action:#selector(handleCautionButton(_:forEvent:)), for: .touchUpInside)
            
            return cell
        }
        else if self.textSearchBar.text == "【※抽出中】" {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableCell
            cell.setPostData(postArrayOfCheckedPost[indexPath.row])
            
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のreviseボタンを追加で管理
            cell.reviseButton.addTarget(self, action:#selector(handleReviseButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のuserPhotoボタンを追加で管理
            cell.userPhotoButton.addTarget(self, action:#selector(handleUserPhotoButton(_:forEvent:)), for: .touchUpInside)
            
            // セル内のcautionPhotoボタンを追加で管理
            cell.cautionButton.addTarget(self, action:#selector(handleCautionButton(_:forEvent:)), for: .touchUpInside)
            
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
            
            // セル内のcautionPhotoボタンを追加で管理
            cell.cautionButton.addTarget(self, action:#selector(handleCautionButton(_:forEvent:)), for: .touchUpInside)
            
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
        else if self.textSearchBar.text == "【※抽出中】" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArrayOfCheckedPost[indexPath!.row]
        }
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))! ||  ($0.id?.localizedCaseInsensitiveContains(n))!})
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
        else if self.textSearchBar.text == "【※抽出中】" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArrayOfCheckedPost[indexPath!.row]
        }
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))! ||  ($0.id?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        
        //タップを検知されたpostDataから投稿ナンバー/投稿者を抽出する
        let reviseDataId = postData.id
        let rejectUserId = postData.userID
        
        //Reviseボタンを押したユーザーが投稿者本人かどうかの判断
        let uid = Auth.auth().currentUser?.uid
        let userID = postData.userID
        if userID == uid {
            userDefaults.set(reviseDataId, forKey: "reviseDataId")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "toRevise", sender: nil)
        }
        else {
            //reject、cautionの意思がある投稿のID、投稿者のID
            userDefaults.set(reviseDataId, forKey: "RejectDataId")
            userDefaults.set(reviseDataId, forKey: "CautionDataId")
            userDefaults.set(rejectUserId, forKey: "RejectUserId")
            userDefaults.synchronize()
            self.performSegue(withIdentifier: "toReject", sender: nil)
        }
    }
    
    
    //セル内のuserPhotoボタンが押された時に呼ばれるメソッド
    @objc func handleUserPhotoButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        if textSearchBar.text == "" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        }
        else if self.textSearchBar.text == "【※抽出中】" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArrayOfCheckedPost[indexPath!.row]
        }
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))! ||  ($0.id?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        //ボタンを押したユーザーが投稿者本人かどうかの判断
        let uid = Auth.auth().currentUser?.uid
        let userID = postData.userID
        
        if userID != uid {
            let ContactRequestPost = postData.id!
            let ContactRequestUserID = postData.userID!
        
            //タップを検知されたpostDataからnameを抽出する
            let userPhotoName = postData.name
            
            let userURL : String = "https://www.facebook.com/search/str/\(userPhotoName!)/keywords_search"
            print("\(userURL)")
            let userPhotoURL = userURL.replacingOccurrences(of: " ", with: "", options: .regularExpression)
            print("\(userPhotoURL)")
            
            //userDefaultsに必要なデータを保存
            userDefaults.set("YES", forKey: "UserPhotoURLFlag")
            userDefaults.set(userPhotoName, forKey: "UserPhotoName")
            userDefaults.set(userPhotoURL, forKey: "UserPhotoURL")
            userDefaults.set(ContactRequestPost, forKey: "ContactRequestPost")
            userDefaults.set(ContactRequestUserID, forKey: "ContactRequestUserID")
            userDefaults.synchronize()
            showAlertWithVC()
            return
        }
    }
    
    
    //セル内の※Cautionボタン（→途中で役割を変えたので正しくは「チャット」ボタン）が押された時に呼ばれるメソッド
    @objc func handleCautionButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        
        if textSearchBar.text == "" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArray[indexPath!.row]
        }
        else if self.textSearchBar.text == "【※抽出中】" {
            // 配列からタップされたインデックスのデータを取り出す
            postData = postArrayOfCheckedPost[indexPath!.row]
        }
        else {
            // 検索バーに入力された単語をスペースで分けて配列に入れる
            let searchWords = textSearchBar.text!
            let array = searchWords.components(separatedBy: NSCharacterSet.whitespaces)
            // 検索バーのテキストを一部でも含むものをAND検索する！
            var tempFilteredArray = postArrayAll
            for n in array {
                tempFilteredArray = tempFilteredArray.filter({ ($0.category?.localizedCaseInsensitiveContains(n))! || ($0.contents?.localizedCaseInsensitiveContains(n))! ||  ($0.name?.localizedCaseInsensitiveContains(n))! ||  ($0.id?.localizedCaseInsensitiveContains(n))!})
            }
            postArrayBySearch = tempFilteredArray
            postData = postArrayBySearch[indexPath!.row]
        }
        
        //タップを検知されたpostDataから投稿ナンバーを抽出する
        let chatDataId = postData.id
        
        userDefaults.set(chatDataId, forKey: "ChatDataId")
        userDefaults.synchronize()
        //Chatに移動
         self.performSegue(withIdentifier: "toChat", sender: nil)
       
    }
    
    
    //最終確認ポップアップページを出す
    func showAlertWithVC(){
        
        let UserPhotoURLFlag :String = userDefaults.string(forKey: "UserPhotoURLFlag")!
        if UserPhotoURLFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今からFacebookでこのユーザーを検索します！\n\nコンタクトする事を事前に\n「通知」しておきますか？\n\n※通知を選択すると、貴方から後程コンタクトがある旨を\nこのユーザーにお知らせします。", aCancelBtnTitle: "まずは検索のみ", aOtherBtnTitle: "「通知」＋検索") { (index, title) in
                print(index,title)
            }
        }
    }
    
    
    //Infoで「この時チェックされた投稿」を押された際の処理
    func handleCheckedPost() {
        self.tableView.reloadData()
        self.textSearchBar.text = "【※抽出中】"
        
       let RequestedPostID :String = userDefaults.string(forKey: "RequestedPostID")!
        
        let array = RequestedPostID.components(separatedBy: NSCharacterSet.whitespaces)
        var tempFilteredArray = postArrayAll
        for n in array {
            tempFilteredArray = tempFilteredArray.filter{($0.id?.contains(n))!}
        }
        postArrayOfCheckedPost = tempFilteredArray
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
