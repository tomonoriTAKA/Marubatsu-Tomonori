//
//  CreateView.swift
//  Marubatsu
//
//  Created by 高橋知憲 on 2025/02/15.
//

import SwiftUI

struct CreateView: View {
    @Binding var quizzesArray: [Quiz] // 回答画面で読み込んだ問題を受け取る
    @State private var questionText = ""//テキストフィールドの文字を受けとる
    @State private var selectedAnswer = "O"//ピッカーで選ばれた解答を受け取る
    let answers = ["O", "X"] // ピッカーの選択肢一覧
    
    var body: some View {
        VStack {
            Text("問題文と解答を入力して、追加ボタンを押してください。")
                .foregroundStyle(.gray)
                .padding()
            
            // 問題文を入力するテキストフィールド
            TextField(text: $questionText) {
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            // 解答を選択するピッカー
            Picker("解答", selection: $selectedAnswer) {
                ForEach(answers, id: \.self) { answer in
                    Text(answer)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // 追加ボタン
            Button {
                // 追加ボタンが押された時の処理
                addQuiz(question: questionText, answer: selectedAnswer)
            } label: {
                Text("追加")
            }
            .padding()
            
            //全削除ボタン
            Button {
                quizzesArray.removeAll() //配列を空に
                UserDefaults.standard
                    .removeObject(forKey: "quiz")// 保存されているものを削除
            } label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()
        }
    }
    
    // 問題追加・保存の関数
    func addQuiz(question: String, answer: String) {
        // 問題文が入力されているかチェック
        if question.isEmpty {
            print("問題文が入力されていません")
            return
        }
        var savingAnswer = true // 保存するためのtrue/falseを入れる変数
        
        // OかXかで、true/faseを切り替える
        switch answer {
        case "O":
            savingAnswer = true
        case "X":
            savingAnswer = false
        default:
            print("適切な答えが入っていません")
            break
        }
        
        let newQuiz = Quiz(question: question, answer: savingAnswer)
        
        var array: [Quiz] = quizzesArray //一時的に変数に入れておく
        array.append(newQuiz)  // 作った問題を配列に追加
        let storeKey = "quiz"  // UserDefaultsに保存するためのキー
        
        // エンコードできたら保存
        if let encodedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encodedQuizzes, forKey: storeKey)
            questionText = "" // テキストフィールドを空白に戻す
            quizzesArray = array // 既存問題 + 新問題 となった配列に更新
        }
    }
}
//
//#Preview {
//    CreateView()
//}
