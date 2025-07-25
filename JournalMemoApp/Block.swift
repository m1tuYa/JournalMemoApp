//
//  Block.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/24.
//

import Foundation

struct Block: Identifiable {
    enum BlockType: String {
        case board
        case post
        case text
        case heading1
        case heading2
        case list
        case checkbox
        case drawing
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
    var style: String
}

extension Block {
    static func create(
        type: BlockType,
        content: String = "",
        parentId: UUID? = nil,
        order: Int = 0,
        style: String = "timeline"
    ) -> Block {
        return Block(
            id: UUID(),
            type: type,
            content: content,
            parentId: parentId,
            order: order,
            createdAt: Date(),
            updatedAt: Date(),
            status: "draft",
            tags: [],
            isPinned: false,
            isCollapsed: false,
            style: style
        )
    }

    static func createPost(content: String = "", parentId: UUID? = nil) -> Block {
        create(type: .post, content: content, parentId: parentId, style: "timeline")
    }

    static func createText(content: String = "", parentId: UUID) -> Block {
        create(type: .text, content: content, parentId: parentId)
    }
}
