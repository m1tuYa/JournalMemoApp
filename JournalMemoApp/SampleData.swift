//
//  sampleData.swift
//  JournalMemoApp
//
//  Created by 小野晴樹 on 2025/07/24.
//



import Foundation

// サンプル用のBlock配列を返す関数
func sampleBlocks() -> [Block] {
    let board = Block(
        id: UUID(),
        type: .board,
        content: "開発メモ",
        parentId: nil,
        order: 0,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: ["開発"],
        isPinned: true,
        isCollapsed: false,
        style: "timeline"
    )

    let post1 = Block(
        id: UUID(),
        type: .post,
        content: "データ構造について",
        parentId: board.id,
        order: 0,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: ["構造"],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let heading1 = Block(
        id: UUID(),
        type: .heading1,
        content: "Blockの定義",
        parentId: post1.id,
        order: 0,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let text1 = Block(
        id: UUID(),
        type: .text,
        content: "すべての要素をBlock型で統一して扱う。",
        parentId: post1.id,
        order: 1,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let list1 = Block(
        id: UUID(),
        type: .list,
        content: "board / post / text / list など",
        parentId: text1.id,
        order: 0,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )

    let post2 = Block(
        id: UUID(),
        type: .post,
        content: "UI設計の課題",
        parentId: board.id,
        order: 1,
        createdAt: Date().addingTimeInterval(-3600),
        updatedAt: Date(),
        status: "draft",
        tags: ["UI"],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let heading2 = Block(
        id: UUID(),
        type: .heading2,
        content: "今後の改善案",
        parentId: post2.id,
        order: 0,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let checkbox1 = Block(
        id: UUID(),
        type: .checkbox,
        content: "ドラッグで順序変更を可能にする",
        parentId: post2.id,
        order: 1,
        createdAt: Date(),
        updatedAt: Date(),
        status: "published",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )
    let checkbox2 = Block(
        id: UUID(),
        type: .checkbox,
        content: "タグでフィルタ表示に対応",
        parentId: post2.id,
        order: 2,
        createdAt: Date(),
        updatedAt: Date(),
        status: "draft",
        tags: [],
        isPinned: false,
        isCollapsed: false,
        style: ""
    )

    return [
        board,
        post1,
        heading1,
        text1,
        list1,
        post2,
        heading2,
        checkbox1,
        checkbox2
    ]
}
