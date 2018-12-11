//
//  Info.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/10.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"RequestedPostID"= Info画面の「この時チェックされた投稿」ボタンに紐づく投稿ID


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController


class Info: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //separatorを左端始まりにして、黒色にする
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = .zero
        
        let nib = UINib(nibName: "InfoTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell-3")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableViewAutomaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 200
        
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
                let postsRef = Database.database().reference().child(Const5.PostPath5)
                postsRef.observe(.childAdded, with: { snapshot in
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 始めのinsertの段階でuidと異なるRequestedUserIDの投稿データを除いておく
                        if postData.RequestedUserID == uid ||  (postData.RequestedUserID?.contains(uid))! {
                            self.postArray.insert(postData, at: 0)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-3", for: indexPath) as! InfoTableCell
        cell.setPostData3(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.checkedPostButton.addTarget(self, action:#selector(handleCheckedPostButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のreviseボタンを追加で管理
        cell.askUserPhotoButton.addTarget(self, action:#selector(handleAskUserPhotoButton(_:forEvent:)), for: .touchUpInside)
            
        return cell
    }
    
    
    //セル内のcheckedPostButtonが押された時に呼ばれるメソッド
    @objc func handleCheckedPostButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData : PostData
        // 配列からタップされたインデックスのデータを取り出す
        postData = postArray[indexPath!.row]
        
        let RequestedPostID = postData.RequestedPostID!
        
        userDefaults.set(RequestedPostID, forKey: "RequestedPostID")
        userDefaults.synchronize()
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(1, animated: false)
        for viewController in tabBarController.childViewControllers {
            if viewController is Post {
                let post = viewController as! Post
                post.handleCheckedPost()
                break
            }
        }
        
    }
    
    
    //セル内のAskUserPhotoButtonが押された時に呼ばれるメソッド
    @objc func handleAskUserPhotoButton(_ sender: UIButton, forEvent event: UIEvent) {
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }

}