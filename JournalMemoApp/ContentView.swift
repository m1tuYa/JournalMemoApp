import SwiftUI

struct ContentView: View {
    @State private var blocks: [Block] = sampleBlocks()
    @State private var selectedBoardId: UUID?
    @State private var activePopoverBlockId: UUID?
    @State private var selectedBlockId: UUID?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedBoardId) {
                // 新しい「その他」セクションを追加
                Section(header: Text("その他")) {
                    Label("検索", systemImage: "magnifyingglass")
                        .foregroundColor(.gray)
                    Label("設定", systemImage: "gearshape")
                        .foregroundColor(.gray)
                }

                Section(header: Text("メニュー")) {
                    Label("ホーム", systemImage: "house")
                        .tag(UUID()) // 仮のID。必要に応じてフィルタ機能を追加
                    Label("カレンダー", systemImage: "calendar")
                        .foregroundColor(.gray)
                }

                Section(header: Text("ボード")) {
                    ForEach(blocks.filter { $0.type == .board }) { board in
                        Text(board.content)
                            .foregroundColor(.black)
                            .tag(board.id)
                    }
                }

                Section(header: Text("タグ（仮）")) {
                    Label("重要", systemImage: "tag")
                        .foregroundColor(.gray)
                    Label("未整理", systemImage: "tag")
                        .foregroundColor(.gray)
                }
            }
            .toolbar {
                Button(action: {
                    let newBoard = Block(id: UUID(), type: .board, content: "新しいボード", parentId: nil, order: blocks.count, createdAt: Date(), updatedAt: Date(), status: "", tags: [], isPinned: false, isCollapsed: false, style: "")
                    blocks.append(newBoard)
                    selectedBoardId = newBoard.id
                }) {
                    Image(systemName: "plus")
                }
                EditButton()
            }
            .navigationTitle("メニュー")
        } detail: {
            TimelineView(
                blocks: $blocks,
                selectedBlockId: $selectedBlockId,
                activePopoverBlockId: $activePopoverBlockId,
                selectedBoardId: $selectedBoardId
            )
        }
    }

    func postsSortedByDate() -> [Block] {
        return blocks
            .filter { $0.type == .post }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func boardForPost(_ post: Block) -> Block? {
        guard let parentId = post.parentId else { return nil }
        return blocks.first(where: { $0.id == parentId && $0.type == .board })
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日HH:mm"
        return formatter.string(from: date)
    }
}
