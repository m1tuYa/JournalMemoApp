import SwiftUI
import UniformTypeIdentifiers

struct TimelinePostView: View {
    var post: Block
    @Binding var blocks: [Block]
    @Binding var draggedBlockId: UUID?
    @Binding var dropTargetBlockId: UUID?
    @Binding var activePopoverBlockId: UUID?
    @Binding var selectedBlockId: UUID?
    var selectedBoardId: UUID?

    var body: some View {
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
                        Button("編集") { activePopoverBlockId = nil }
                        Button("ピン留め") { activePopoverBlockId = nil }
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
            VStack(alignment: .leading, spacing: 4) {
                ForEach(children, id: \.id) { block in
                    let dropDelegate = BlockDropDelegate(
                        targetBlock: block,
                        blocks: $blocks,
                        draggedBlockId: $draggedBlockId,
                        dropTargetBlockId: $dropTargetBlockId,
                        onMove: { fromId, toId in
                            if let fromIndex = blocks.firstIndex(where: { $0.id == fromId }),
                               let toIndex = blocks.firstIndex(where: { $0.id == toId }) {
                                let movedBlock = blocks.remove(at: fromIndex)
                                blocks.insert(movedBlock, at: toIndex)
                            }
                        }
                    )
                    ZStack(alignment: .top) {
                        if dropTargetBlockId == block.id {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 2)
                                .offset(y: -4)
                        }
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
                            },
                            blocks: $blocks,
                            draggedBlockId: $draggedBlockId,
                            dropTargetBlockId: $dropTargetBlockId,
                            onMove: { fromId, toId in
                                if let fromIndex = blocks.firstIndex(where: { $0.id == fromId }),
                                   let toIndex = blocks.firstIndex(where: { $0.id == toId }) {
                                    let movedBlock = blocks.remove(at: fromIndex)
                                    blocks.insert(movedBlock, at: toIndex)
                                }
                            }
                        )
                        .onDrag {
                            draggedBlockId = block.id
                            return NSItemProvider(object: block.id.uuidString as NSString)
                        }
                        .onDrop(of: [UTType.blockID], delegate: dropDelegate)
                    }
                }
            }
            Divider()
        }
        .padding()
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
