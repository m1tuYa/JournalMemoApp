import SwiftUI

struct NewPostEditor: View {
    @Environment(\.dismiss) var dismiss
    @Binding var blocks: [Block]
    let defaultBoardId: UUID

    @State private var content: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $content)
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
                    .padding()

                Spacer()
            }
            .navigationTitle("新規ポスト")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("ポスト") {
                        addNewPost()
                        dismiss()
                    }
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
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

        let newTextBlock = Block.create(
            type: .text,
            content: content,
            parentId: newPost.id,
            order: 0
        )

        blocks.append(newPost)
        blocks.append(newTextBlock)
    }
}
