//
//  Created by Kurlovich Vitali on 6/5/26.
//

nonisolated struct BidirectionalChannelIDResolver {
    func resolve(_ firstId: Int32, _ second: Int32) -> Int {
        let minId = Int(min(firstId, second))
        let maxId = Int(max(firstId, second)) << 32
        return maxId | minId
    }
}
