//
//  ContentView.swift
//  Marubatsu
//
//  Created by 高橋知憲 on 2025/02/15.
//

import SwiftUI

struct Quiz: Identifiable, Codable {
    var id = UUID()     //それぞれの設問を区別するためのID
    var question: String//問題文
    var answer: Bool    //解答
}

struct ContentView: View {
    
    // 問題
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    @AppStorage("quiz") var quizzesData = Data() // UserDefaultsから問題を読み込む(Data型)
    @State var quizzesArray: [Quiz] = [] // 問題を入れておく配列
    
    @State var currentQuestionNum = 0 // 今、何問目の数字
    @State var showingAlert = false // アラートの表示・非表示を制御
    @State var alertTitle = "" // "正解"か"不正解"の文字をいれるための変数
    
    // 画面生成時にquizzesDataに読み込んだData型の値を[Quiz]型にデコードしてquizzesArrayに入れる
    init() {
        if let decodedQuizzes = try? JSONDecoder()
            .decode([Quiz].self, from: quizzesData) {
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Text(showQuestion())
                        .padding() // 余白を外側に追加
                        .frame(width: geometry.size.width * 0.85, alignment: .leading) // 横幅を250,左寄せに
                        .font(.system(size: 25)) //フォントサイズを25に
                        .fontDesign(.rounded)   // フォントのデザインを変更
                        .background(.yellow)
                    
                    Spacer() //問題文とボタンの間を広げるための余白を追加
                    
                    // OXボタンを横並びにするためにHStackを使う
                    HStack {
                        // ○ボタン
                        Button {
                            checkAnswer(yourAnswer: true)
                        } label: {
                            Text("O")  // ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4) // 幅と高さを親ビューの幅の0.4倍に
                        .font(.system(size: 100, weight: .bold)) //フォントサイズ100,太字に
                        .background(.red) // 背景を赤に
                        .foregroundStyle(.white) // 文字の色を白に
                        
                        
                        // Xボタン
                        Button {
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("X")  // ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4) // 幅と高さを親ビューの幅の0.4倍に
                        .font(.system(size: 100, weight: .bold)) //フォントサイズ100,太字に
                        .background(.blue) // 背景を青に
                        .foregroundStyle(.white) // 文字の色を白に
                        
                        
                    }
                    
                }
                .padding()
                .navigationTitle("マルバツクイズ") // ナビゲーションバーにタイトル設定
                
                // 回答時のアラート
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", role: .cancel){}
                }
                
                // 問題作成画面へ遷移するためのボタンを設置
                .toolbar {
                    // 配置する場所を画面最上部のバーの右端に設定
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CreateView(quizzesArray: $quizzesArray) // 遷移先の画面
                                .navigationTitle("問題を作ろう")
                        } label: {
                            Image(systemName: "plus") // ボタンの見た目
                                .font(.title)
                        }
                    }
                }
                
            }
        }
    }
    
    // 問題文を表示するための関数
    func showQuestion() -> String {
        var question = "問題がありません"
        // 問題が有るかどうかのチェック
        if !quizzesArray.isEmpty {
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        return question
    }
    
    // 回答をチェックする関数、正解なら次の問題を表示
    func checkAnswer(yourAnswer: Bool) {
        
        if quizzesArray.isEmpty { return } // 問題が無い時は回答チェックしない
        let quiz = quizzesArray[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans { // 正解の時
            alertTitle = "正解"
            // 現在の問題番号が問題数を超えないように場合分け
            if currentQuestionNum + 1 < quizzesArray.count {
                currentQuestionNum += 1 // 次の問題に進む
            } else {
                // 超えるときは0に戻す
                currentQuestionNum = 0
            }
        } else { // 不正解の時
            alertTitle = "不正解"
        }
        showingAlert = true // アラートを表示
    }
    
}

#Preview {
    ContentView()
}
