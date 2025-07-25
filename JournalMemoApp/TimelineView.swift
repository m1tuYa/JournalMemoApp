import SwiftUI

struct TimelineView: View {
    @Binding var blocks: [Block]
    @Binding var selectedBlockId: UUID?
    @Binding var activePopoverBlockId: UUID?
    @Binding var selectedBoardId: UUID?

    @State private var isPresentingEditor = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(postsSortedByDate()) { post in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.blue)

                                HStack(spacing: 8) {
                                    if let board = boardForPost(post) {
                                        Text(board.content)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    Text(formatDate(post.createdAt))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    activePopoverBlockId = post.id
                                }) {
                                    Image(systemName: "ellipsis")
                                        .imageScale(.medium)
                                        .rotationEffect(.degrees(90))
                                        .foregroundColor(.gray)
                                }
                                .popover(isPresented: Binding(
                                    get: { activePopoverBlockId == post.id },
                                    set: { if !$0 { activePopoverBlockId = nil } }
                                )) {
                                    VStack(alignment: .leading) {
                                        Button("編集") {
                                            activePopoverBlockId = nil
                                        }
                                        Button("ピン留め") {
                                            activePopoverBlockId = nil
                                        }
                                        Button("削除", role: .destructive) {
                                            if let index = blocks.firstIndex(where: { $0.id == post.id }) {
                                                blocks.remove(at: index)
                                            }
                                            activePopoverBlockId = nil
                                        }
                                    }
                                    .padding()
                                }
                            }

                            let children = blocks.filter { $0.parentId == post.id }
                            HStack(alignment: .top, spacing: 0) {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(children) { block in
                                        BlockView(
                                            block: block,
                                            onUpdate: { updatedBlock in
                                                if let index = blocks.firstIndex(where: { $0.id == updatedBlock.id }) {
                                                    blocks[index] = updatedBlock
                                                }
                                            },
                                            onDelete: { deletedBlock in
                                                if let index = blocks.firstIndex(where: { $0.id == deletedBlock.id }) {
                                                    blocks.remove(at: index)
                                                }
                                            }
                                        )
                                    }
                                    .onMove { indices, newOffset in
                                        let moved = indices.map { children[$0] }
                                        for (i, movedBlock) in moved.enumerated() {
                                            if let originalIndex = blocks.firstIndex(where: { $0.id == movedBlock.id }) {
                                                blocks.remove(at: originalIndex)
                                                blocks.insert(movedBlock, at: newOffset + i)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        Divider()
                    }
                }
                .background(Color.white)
            }
            Button(action: {
                isPresentingEditor = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .padding()
                    .background(Circle().fill(Color.blue))
                    .shadow(radius: 4)
            }
            .padding()
            .sheet(isPresented: $isPresentingEditor) {
                NewPostEditor(blocks: $blocks, defaultBoardId: selectedBoardId ?? UUID())
            }
        }
    }

    private func postsSortedByDate() -> [Block] {
        return blocks
            .filter { $0.type == .post }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private func boardForPost(_ post: Block) -> Block? {
        guard let parentId = post.parentId else { return nil }
        return blocks.first(where: { $0.id == parentId && $0.type == .board })
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日HH:mm"
        return formatter.string(from: date)
    }
}
