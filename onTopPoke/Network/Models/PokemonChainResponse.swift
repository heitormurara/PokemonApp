struct PokemonChainResponse: Decodable {
    private let chainItem: PokemonChainItem
    
    enum CodingKeys: String, CodingKey {
        case chainItem = "chain"
    }
    
    var flatSpecieChain: [PokemonSpecieItem] {
        flattenChain([chainItem])
    }
    
    private func flattenChain(_ chain: [PokemonChainItem]) -> [PokemonSpecieItem] {
        var result: [PokemonSpecieItem] = []
        for item in chain {
            result.append(item.originSpecie)
            result.append(contentsOf: flattenChain(item.chain))
        }
        return result
    }
}
