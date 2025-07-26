import SwiftUI

struct EditorBlock: Identifiable {
    var id = UUID()
    var content: String
    var type: BlockType
}

struct NewPostEditor: View {
    @Environment(\.dismiss) var dismiss
    @Binding var blocks: [Block]
    let defaultBoardId: UUID

    @State private var title: String = ""
    @State private var editorBlocks: [EditorBlock] = [
        EditorBlock(content: "", type: BlockType.text)
    ]

    var body: some View {
        VStack {
            headerView()
            scrollContent()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Button("キャンセル") {
                dismiss()
            }
            Spacer()
            Button("ポスト") {
                addNewPost()
                dismiss()
            }
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }

    @ViewBuilder
    private func scrollContent() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                TextField("無題", text: $title)
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal)

                ForEach($editorBlocks) { $block in
                    blockView(block: block)
                }
            }
            .frame(maxWidth: 700)
            .padding(.vertical, 40)
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func blockView(block: EditorBlock) -> some View {
        BlockView(
            block: Block.create(
                type: block.type,
                content: block.content,
                parentId: nil,
                order: 0
            ),
            onUpdate: { updated in
                if let i = editorBlocks.firstIndex(where: { $0.id == updated.id }) {
                    editorBlocks[i].content = updated.content
                }
            },
            onDelete: { deleted in
                editorBlocks.removeAll { $0.id == deleted.id }
            },
            blocks: .constant([]),
            draggedBlockId: .constant(nil),
            dropTargetBlockId: .constant(nil),
            onMove: { _, _ in }
        )
    }

    private func addNewPost() {
        let postId = UUID()
        let now = Date()

        let newPost = Block.create(
            type: .post,
            content: "",
            parentId: defaultBoardId,
            order: blocks.filter { $0.parentId == defaultBoardId && $0.type == .post }.count,
            style: "timeline"
        )

        let headingBlock = Block.create(
            type: .heading1,
            content: title,
            parentId: postId,
            order: 0
        )

        var newBlocks: [Block] = [newPost, headingBlock]

        for (index, editorBlock) in editorBlocks.enumerated() {
            let b = Block.create(
                type: editorBlock.type,
                content: editorBlock.content,
                parentId: postId,
                order: index + 1
            )
            newBlocks.append(b)
        }

        blocks.append(contentsOf: newBlocks)
    }
}
