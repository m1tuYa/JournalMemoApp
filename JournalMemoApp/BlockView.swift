

import SwiftUI
import UniformTypeIdentifiers

struct BlockView: View {
    var block: Block
    var onUpdate: (Block) -> Void
    var onDelete: (Block) -> Void
    @Binding var blocks: [Block]
    @Binding var draggedBlockId: UUID?
    @Binding var dropTargetBlockId: UUID?
    var onMove: (_ fromId: UUID, _ toId: UUID) -> Void
    var isDragging: Bool = false
    @State private var content: String
    @FocusState private var isFocused: Bool
    @GestureState private var isDetectingLongPress = false
    @State private var dragOffset: CGSize = .zero
    @State private var isSelected: Bool = false
    @State private var isEditing = true

    init(
        block: Block,
        onUpdate: @escaping (Block) -> Void,
        onDelete: @escaping (Block) -> Void,
        blocks: Binding<[Block]>,
        draggedBlockId: Binding<UUID?>,
        dropTargetBlockId: Binding<UUID?>,
        onMove: @escaping (_ fromId: UUID, _ toId: UUID) -> Void = { _, _ in }
    ) {
        self.block = block
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._blocks = blocks
        self._draggedBlockId = draggedBlockId
        self._dropTargetBlockId = dropTargetBlockId
        self.onMove = onMove
        _content = State(initialValue: block.content)
    }

    @ViewBuilder
    private func editingTextView(font: Font) -> some View {
        TextEditor(text: $content)
            .font(font)
            .padding(.vertical, -4)
            .focused($isFocused)
            .disabled(isSelected)
            .onDrop(
                of: [UTType.blockID],
                delegate: BlockDropDelegate(
                    targetBlock: block,
                    blocks: $blocks,
                    draggedBlockId: $draggedBlockId,
                    dropTargetBlockId: $dropTargetBlockId,
                    onMove: onMove
                )
            )
    }

    @ViewBuilder
    private func blockContent(font: Font) -> some View {
        if isEditing && !isDragging {
            editingTextView(font: font)
        } else {
            Text(content)
                .font(font)
                .padding(.vertical, 4)
        }
    }

    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 4) {
                ZStack {
                    if isFocused {
                        Menu {
                            Button("Change Type") {
                                print("Change type tapped")
                            }
                            Button("Duplicate") {
                                print("Duplicate tapped")
                            }
                            Button("Delete") {
                                onDelete(block)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            isEditing = false
                            isSelected = true
                        }
                        .padding(.leading, 4)
                    }
                }
                .frame(width: 30) // fixed width to reserve space for the button

                // Main content area
                VStack(alignment: .leading, spacing: 0) {
                    switch block.type {
                    case .heading1:
                        blockContent(font: .title)
                    case .heading2:
                        blockContent(font: .title2)
                    case .text, .list:
                        blockContent(font: .body)
                    case .checkbox:
                        HStack(alignment: .center) {
                            Image(systemName: "square")
                            blockContent(font: .body)
                        }
                    default:
                        blockContent(font: .body)
                    }
                }
                .foregroundColor(.black)
                .onChange(of: content) { newValue in
                    var updated = block
                    updated.content = newValue
                    onUpdate(updated)
                }
            }
            .padding(.vertical, 0)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.white)
            .cornerRadius(4)
            .gesture(
                isSelected ?
                LongPressGesture(minimumDuration: 0.3)
                    .sequenced(before: DragGesture())
                    .onChanged { value in
                        if case .second(true, let drag?) = value {
                            dragOffset = drag.translation
                        }
                    }
                    .onEnded { value in
                        if case .second(true, _) = value,
                           let targetId = dropTargetBlockId {
                            if block.id != targetId {
                                onMove(block.id, targetId)
                            }
                        }
                        dragOffset = .zero
                    }
                : nil
            )
        }
        .overlay(
            Rectangle()
                .fill(Color.blue)
                .frame(height: 2)
                .opacity(dropTargetBlockId == block.id ? 1.0 : 0.0)
                .padding(.top, -1),
            alignment: .bottom
        )
    }
}
