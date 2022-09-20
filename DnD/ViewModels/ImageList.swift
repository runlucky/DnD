import SwiftUI

class ImageList: ObservableObject {
    @Published var items: [ImageItem] = []
    @Published var dragging: ImageItem?
    
}

struct ImageItem: Identifiable, Hashable {
    var id = UUID()
    var image: UIImage
    var url: URL { URL(string: id.uuidString)! }
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
            let temp = list.items[from]
            list.items[from] = list.items[to]
            list.items[to] = temp
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
}
