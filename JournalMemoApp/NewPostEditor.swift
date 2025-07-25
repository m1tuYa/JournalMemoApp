import SwiftUI

struct EditorBlock: Identifiable {
    var id = UUID()
    var content: String
    var type: Block.BlockType
}

struct NewPostEditor: View {
    @Environment(\.dismiss) var dismiss
    @Binding var blocks: [Block]
    let defaultBoardId: UUID

    @State private var title: String = ""
    @State private var editorBlocks: [EditorBlock] = [
        EditorBlock(content: "", type: Block.BlockType.text)
    ]

    var body: some View {
        VStack {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    TextField("無題", text: $title)
                        .font(.system(size: 32, weight: .bold))
                        .padding(.horizontal)
                    
                    ForEach($editorBlocks) { $block in
                        TextEditor(text: $block.content)
                            .frame(minHeight: 200)
                            .padding(.horizontal)
                            .background(Color.clear)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: 700)
                .padding(.vertical, 40)
                .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
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
