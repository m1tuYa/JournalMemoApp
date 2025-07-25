//
//  Block.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/24.
//

import Foundation
enum BlockStatus: String {
    case draft
    case published
    case archived
}
typealias BlockType = Block.BlockType

struct Block: Identifiable {
    enum BlockType: String {
        case board
        case post
        case text
        case heading1
        case heading2
        case list
        case checkbox
        // Drawing blocks are now expressed by setting the `style` property to "handwriting" rather than using a separate type.
    }

    let id: UUID
    var type: BlockType
    var content: String
    var parentId: UUID?
    var order: Int
    var createdAt: Date
    var updatedAt: Date
    var status: String
    var tags: [String]
    var isPinned: Bool
    var isCollapsed: Bool
    var style: String // e.g., "timeline", "mindmap", "handwriting"
}

extension Block {
    static func create(
        type: BlockType,
        content: String = "",
        parentId: UUID? = nil,
        order: Int = 0,
        status: BlockStatus = .draft,
        tags: [String] = [],
        isPinned: Bool = false,
        isCollapsed: Bool = false,
        style: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> Block {
        return Block(
            id: UUID(),
            type: type,
            content: content,
            parentId: parentId,
            order: order,
            createdAt: createdAt,
            updatedAt: updatedAt,
            status: status.rawValue,
            tags: tags,
            isPinned: isPinned,
            isCollapsed: isCollapsed,
            style: style ?? ""
        )
    }

    static func createWithId(
        id: UUID,
        type: BlockType,
        content: String = "",
        parentId: UUID? = nil,
        order: Int = 0,
        status: BlockStatus = .draft,
        tags: [String] = [],
        isPinned: Bool = false,
        isCollapsed: Bool = false,
        style: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) -> Block {
        return Block(
            id: id,
            type: type,
            content: content,
            parentId: parentId,
            order: order,
            createdAt: createdAt,
            updatedAt: updatedAt,
            status: status.rawValue,
            tags: tags,
            isPinned: isPinned,
            isCollapsed: isCollapsed,
            style: style ?? ""
        )
    }

    static func createPost(content: String = "", parentId: UUID? = nil) -> Block {
        create(type: BlockType.post, content: content, parentId: parentId, style: "timeline")
    }

    static func createText(content: String = "", parentId: UUID) -> Block {
        create(type: BlockType.text, content: content, parentId: parentId)
    }
}
