struct EvolutionChainResponse: Decodable {
    private let chainItem: EvolutionChain
    
    enum CodingKeys: String, CodingKey {
        case chainItem = "chain"
    }
    
    var flatSpecieChain: [Specie] {
        flattenChain([chainItem])
    }
    
    private func flattenChain(_ chain: [EvolutionChain]) -> [Specie] {
        var result: [Specie] = []
        for item in chain {
            result.append(item.originSpecie)
            result.append(contentsOf: flattenChain(item.chain))
        }
        return result
    }
}
