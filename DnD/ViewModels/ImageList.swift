import SwiftUI

class ImageList: ObservableObject {
    @Published var items: [ImageItem] = []
    var dragging: ImageItem?

}

struct ImageItem: Identifiable {
    var id = UUID()
    var image: Image
}

struct DropViewDelegate: DropDelegate {
    var list: ImageList
    var target: ImageItem
    
    func performDrop(info: DropInfo) -> Bool { true }
    
    func dropEntered(info: DropInfo) {
        let from = list.items.firstIndex { $0.id == list.dragging?.id } ?? 0
        let to = list.items.firstIndex { $0.id == target.id } ?? 0

        guard from != to else { return }
        
        // ドラッグ中の画像とその下にある画像を入れ替える
        withAnimation {
            list.items.swapAt(from, to)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
}
