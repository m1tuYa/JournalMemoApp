//
//  BlockView.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/25.
//

// 修正概要: ボタンのタップ領域の改善と不要な青い線の削除

import SwiftUI

struct BlockView: View {
    var block: Block
    var onUpdate: (Block) -> Void
    var onDelete: (Block) -> Void
    @State private var content: String
    @FocusState private var isFocused: Bool

    init(block: Block, onUpdate: @escaping (Block) -> Void, onDelete: @escaping (Block) -> Void) {
        self.block = block
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        _content = State(initialValue: block.content)
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
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .padding(.vertical, 0)
                                .padding(.horizontal, 6)
                        }
                    }
                }
                .frame(width: 30) // fixed width to reserve space for the button

                // Main content area
                VStack(alignment: .leading, spacing: 0) {
                    switch block.type {
                    case .heading1:
                        TextEditor(text: $content)
                            .font(.title)
                            .padding(.vertical, -4)
                            .focused($isFocused)
                    case .heading2:
                        TextEditor(text: $content)
                            .font(.title2)
                            .padding(.vertical, -4)
                            .focused($isFocused)
                    case .text, .list:
                        HStack(alignment: .center) {
                            TextEditor(text: $content)
                                .font(.body)
                                .padding(.vertical, -4)
                                .focused($isFocused)
                        }
                    case .checkbox:
                        HStack(alignment: .center) {
                            Image(systemName: "square")
                            TextEditor(text: $content)
                                .font(.body)
                                .padding(.vertical, -4)
                                .focused($isFocused)
                        }
                    default:
                        TextEditor(text: $content)
                            .padding(.vertical, -4)
                            .focused($isFocused)
                    }
                }
                .background(Color.white)
                .foregroundColor(.black)
                .onChange(of: content) { newValue in
                    var updated = block
                    updated.content = newValue
                    onUpdate(updated)
                }
            }
            .padding(.vertical, 0)
            .background(Color.white)
            .cornerRadius(4)
        }
    }
}
