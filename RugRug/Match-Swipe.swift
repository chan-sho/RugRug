//
//  Match-Swipe.swift
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


class Match_Swipe: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    var postArray: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // HUDで投稿完了を表示する
        SVProgressHUD.show(withStatus: "データ読み込み中です。")
        SVProgressHUD.dismiss(withDelay: 2.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        yesButton.isExclusiveTouch = true
        noButton.isExclusiveTouch = true
        
        let nib = UINib(nibName: "MatchTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell-6")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        tableView.estimatedRowHeight = 430
        
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
                        
                        self.postArray.insert(postData, at: 0)
                        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-6", for: indexPath) as! MatchTableCell
        cell.setPostData6(postArray[indexPath.row])
        
        return cell
    }
    

    @IBAction func yesButton(_ sender: Any) {
    }
    
    
    @IBAction func noButton(_ sender: Any) {
    }
    
    
}
