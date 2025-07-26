import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let blockID = UTType(exportedAs: "com.example.block-id")
}

struct TimelineView: View {
    @Binding var blocks: [Block]
    @Binding var selectedBlockId: UUID?
    @Binding var activePopoverBlockId: UUID?
    @Binding var selectedBoardId: UUID?

    @State private var isPresentingEditor = false
    @State private var draggedBlockId: UUID? = nil
    @State private var dropTargetBlockId: UUID? = nil

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(postsSortedByDate()) { post in
                        TimelinePostView(
                            post: post,
                            blocks: $blocks,
                            draggedBlockId: $draggedBlockId,
                            dropTargetBlockId: $dropTargetBlockId,
                            activePopoverBlockId: $activePopoverBlockId,
                            selectedBlockId: $selectedBlockId,
                            selectedBoardId: selectedBoardId
                        )
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
