//
//  SerumSwap+Orderbook.swift
//  SolanaSwift
//
//  Created by Chung Tran on 20/08/2021.
//

import Foundation
import BufferLayoutSwift

extension SerumSwap {
    public struct Orderbook {
        
    }
}

extension SerumSwap.Orderbook {
    struct Layout: BufferLayout {
        let blob5: SerumSwap.Blob5
        let accountFlags: SerumSwap.AccountFlags
        let slab: Slab
        let blob7: SerumSwap.Blob7
    }
    
    struct Slab: BufferLayout {
        let header: SlabHeader
//        let nodes: SlabNodes
    }
    
    struct SlabHeader: BufferLayout {
        let bumpIndex: UInt32
        let zeros: UInt32
        let freeListLen: UInt32
        let zeros2: UInt32
        let freeListHead: UInt32
        let root: UInt32
        let leafCount: UInt32
        let zeros3: UInt32
    }
    
//    struct SlabNodes: BufferLayoutProperty {
//        static var numberOfNodes: Int {
//
//        }
//
//        static var numberOfBytes: Int {
//            numberOfNodes *
//        }
//
//        static func fromBytes(bytes: [UInt8]) throws -> SerumSwap.Orderbook.SlabNodes {
//            <#code#>
//        }
//
//        func encode() throws -> Data {
//            <#code#>
//        }
//    }

    struct SlabNode: BufferLayoutProperty {
        let tag: UInt32
        let value: SerumSwapSlabNodeType
        
        static func getNumberOfBytes() throws -> Int {
            4 // tag
            + 68 // node
        }
        
        init(buffer: Data) throws {
            guard buffer.count >= (try Self.getNumberOfBytes()) else {
                throw BufferLayoutSwift.Error.bytesLengthIsNotValid
            }
            self.tag = try UInt32(buffer: Data(buffer[0..<4]))
            
            let buffer = buffer[4...]
            switch tag {
            case 0:
                self.value = UninitializedNode()
            case 1:
                self.value = try InnerNode(buffer: buffer)
            case 2:
                self.value = try LeafNode(buffer: buffer)
            case 3:
                self.value = try FreeNode(buffer: buffer)
            case 4:
                self.value = try LastFreeNode(buffer: buffer)
            default:
                throw SerumSwapError("Unsupported node")
            }
        }
        
        func encode() throws -> Data {
            var data = Data(tag.bytes)
            
            var nodeData = Data()
            switch value {
            case is UninitializedNode:
                break
            case let value as InnerNode:
                nodeData += try value.encode()
            case let value as LeafNode:
                nodeData += try value.encode()
            case let value as FreeNode:
                nodeData += try value.encode()
            case is LastFreeNode:
                break
            default:
                throw SerumSwapError("Unsupported node")
            }
            data += nodeData
            
            let zeros = [UInt8](repeating: 0, count: (try Self.getNumberOfBytes())-4-nodeData.count)
            return data + zeros
        }
    }
    
    struct UninitializedNode: SerumSwapSlabNodeType {}
    
    struct InnerNode: SerumSwapSlabNodeType, BufferLayout {
        let prefixLen: UInt32
        let key: UInt128
        let children: [UInt32]
    }
    
    struct LeafNode: SerumSwapSlabNodeType, BufferLayout {
        let ownerSlot: UInt8
        let feeTier: UInt8
        let blob2: SerumSwap.Blob2
        let key: UInt128
        let owner: SerumSwap.PublicKey
        let quantity: UInt64
        let clientOrderId: UInt64
    }
    
    struct FreeNode: SerumSwapSlabNodeType, BufferLayout {
        let next: UInt32
    }
    
    struct LastFreeNode: SerumSwapSlabNodeType, BufferLayout {}
}

protocol SerumSwapSlabNodeType {}
