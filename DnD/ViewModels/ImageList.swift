import SwiftUI

/// 並び替え可能な画像リスト
class ImageList: ObservableObject {
    /// 保持している画像群
    @Published var items: [ImageItem] = []
    /// ドラッグ中の画像
    var dragging: ImageItem?

}

/// 描画、並び替え可能な画像
struct ImageItem: Identifiable {
    /// 並び替え時やForEachでの一意性担保のためにIdentifiableに準拠しています。
    var id = UUID()
    var image: Image
}

/// ドラッグ&ドロップ時の挙動を制御します
struct DropViewDelegate: DropDelegate {
    var list: ImageList
    var target: ImageItem
    
    func performDrop(info: DropInfo) -> Bool { true }
    
    /// ドラッグ中の画像とその下にある画像を入れ替えます
    func dropEntered(info: DropInfo) {
        let from = list.items.firstIndex { $0.id == list.dragging?.id } ?? 0
        let to = list.items.firstIndex { $0.id == target.id } ?? 0

        guard from != to else { return }
        
        withAnimation {
            list.items.swapAt(from, to)
        }
    }
    
    /// ドロップ挙動(UI描画に影響する)を移動モードにします
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
}
