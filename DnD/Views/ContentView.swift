//
//  ContentView.swift
//  DnD
//
//  Created by Kakeru Fukuda on 2022/09/19.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var list = ImageList()
    @State private var showPicker = false
    
    /// 選択できる画像の上限
    private let selectionLimit = 4
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(list.items) { item in
                    ZStack(alignment: .topTrailing) {
                        thumbnail(item)
                        deleteButton(item)
                    }
                }
                
                if list.items.count != selectionLimit {
                    addButton
                }
                
            }
            .padding(10)
            
        }
        .fullScreenCover(isPresented: $showPicker) {
            PhotoPicker(images: $list.items, selectionLimit: selectionLimit - list.items.count)
        }
    }
    
    /// サムネイル画像
    @ViewBuilder private func thumbnail(_ item: ImageItem) -> some View {
        item.image
            .resizable()
            .frame(width: 100, height: 100)
            .cornerRadius(20)
            .onDrag {
                list.dragging = item
                return  NSItemProvider()
            }
            .onDrop(of: [.url], delegate: DropViewDelegate(list: list, target: item))
    }

    /// 画像の削除ボタン
    @ViewBuilder private func deleteButton(_ item: ImageItem) -> some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.white)
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.black)
            
        }
        .opacity(0.8)
        .font(.title)
        .onTapGesture {
            if let index = list.items.firstIndex(where: { $0.id == item.id }) {
                withAnimation { () -> Void in
                    list.items.remove(at: index)
                }
                
            }
        }
    }

    /// 画像の選択ボタン
    @ViewBuilder private var addButton: some View {
        Image(systemName: "plus.app")
            .font(.title)
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(20)
            .onTapGesture {
                showPicker = true
            }
    }
}

