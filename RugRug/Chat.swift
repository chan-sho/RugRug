//
//  Chat.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/13.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"ChatDataId"= チャットをしたい対象の投稿ID


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController


class Chat: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userPhoto: UIImageView!
    
    var postArray: [PostData] = []
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text.delegate = self
        // 枠のカラー
        text.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        text.layer.borderWidth = 0.5
        
        text.keyboardDismissMode = .onDrag
        text.keyboardDismissMode = .interactive
        
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(title: "キーボードを閉じる / Close Keyboard", style: .done, target: self, action: #selector(self.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        text.inputAccessoryView = kbToolBar
        
        //7x7でチャットボタンを押して画面遷移して来た際のsendButtonのテキスト変更
        let chat7x7Flag = userDefaults.string(forKey: "Chat7x7Flag")!
        print("chat7x7Flag = \(chat7x7Flag)")
        
        if chat7x7Flag == "YES" {
            sendButton.setTitle("Send", for: .normal)
        }
        
        //ログインユーザーのプロフィール画像をロード
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            let userProfileurl = (Auth.auth().currentUser?.photoURL?.absoluteString)! + "?width=140&height=140"
            
            if userProfileurl != "" {
                let url = URL(string: "\(userProfileurl)")
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        self.userPhoto.image = UIImage(data: data!)
                        self.userPhoto.clipsToBounds = true
                        self.userPhoto.layer.cornerRadius = 35.0
                        self.userPhoto.layer.borderColor = UIColor.gray.cgColor
                        self.userPhoto.layer.borderWidth = 0.5
                    }
                }).resume()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを【無効】にする
        tableView.allowsSelection = false
        
        //separatorを左端始まりにして、白色にする
        tableView.separatorColor = UIColor.white
        tableView.separatorInset = .zero
        
        let nib = UINib(nibName: "ChatTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell-4")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
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
                let chatDataId :String = userDefaults.string(forKey: "ChatDataId")!
                // 要素が【追加】されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const6.PostPath6).child("\(chatDataId)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell-4", for: indexPath) as! ChatTableCell
        cell.setPostData4(postArray[indexPath.row])
        
        return cell
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        text.resignFirstResponder()
    }
    
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }

    
    @IBAction func sendButton(_ sender: Any) {
        let chat7x7Flag = userDefaults.string(forKey: "Chat7x7Flag")!
        
        if text.text == "" {
            if chat7x7Flag == "YES" {
                SVProgressHUD.showError(withStatus: "チャット内容の記載が空白です。\nご確認下さい。\n\nChat text is empty.\nPlease check.")
            }
            else {
                SVProgressHUD.showError(withStatus: "チャット内容の記載が空白です。\nご確認下さい。")
            }
        }
        else {
            // ImageViewから画像を取得する
            let imageData = userPhoto.image!.jpegData(compressionQuality: 0.5)
            let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
            // postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            let chatDataId :String = userDefaults.string(forKey: "ChatDataId")!
            
            // **重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const6.PostPath6).child("\(chatDataId)")
            let postDic = ["userID": Auth.auth().currentUser!.uid, "contents": text.text!, "userPhoto": imageString, "time": String(time), "name": name!] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            //textを空白にする（初期化）
            text.text = ""
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        //Flagの再初期化
        userDefaults.set("NO", forKey: "Chat7x7Flag")
        userDefaults.synchronize()
        print("再初期化：Chat7x7Flag = 「NO」")
    }
    
}
