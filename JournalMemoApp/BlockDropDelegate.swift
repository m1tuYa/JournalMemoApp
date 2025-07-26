//
//  BlockDropDelegate.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/26.
//


//
//  BlockDropDelegate.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct BlockDropDelegate: DropDelegate {
    let targetBlock: Block
    @Binding var blocks: [Block]
    @Binding var draggedBlockId: UUID?
    @Binding var dropTargetBlockId: UUID?
    let onMove: (UUID, UUID) -> Void

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedId = draggedBlockId, draggedId != targetBlock.id else {
            return false
        }
        dropTargetBlockId = targetBlock.id
        onMove(draggedId, targetBlock.id)
        dropTargetBlockId = nil
        return true
    }
}
