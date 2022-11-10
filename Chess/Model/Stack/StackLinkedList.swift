//
//  StackLinkedList.swift
//  Chess
//
//  Created by Николай Щербаков on 16.09.2022.
//

import Foundation

public struct StackLinkedList<Value> {
    
    public var head: Node<Value>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var count: Int {
        guard var tmpHead = head else { return 0 }
        var count = 1
        while let next = tmpHead.next {
            count += 1
            tmpHead = next
        }
        
        return count
    }
    
    public mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
    }
    
    @discardableResult
    public mutating func pop()-> Value? {
        defer {
            head = head?.next
        }
        return head?.value
    }
    
    public mutating func reversed() -> Self? {
        
        guard !isEmpty else { return nil }
        let tmpHead = head
        var stack = StackLinkedList()
        while let item = head?.next {
            stack.push(item.value)
            head = item
        }
        
        self.head = tmpHead

        return stack
    }
}

extension StackLinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}
