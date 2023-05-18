import Foundation

protocol PokeAPIServicing {
    func getSpecies(at page: Page) async -> Result<Paginated<Specie>, Error>
    func getEvolutionChain(forSpecieID specieID: Int) async -> Result<[Specie], Error>
}

final class PokeAPIService {
    private let networkProvider: NetworkProviding
    private let networkRoute = PokeAPIRoute.self
    
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
}

extension PokeAPIService: PokeAPIServicing {
    func getSpecies(at page: Page) async -> Result<Paginated<Specie>, Error> {
        let result = await networkProvider.request(networkRoute.getSpecies(page: page),
                                                   decodeInto: Paginated<Specie>.self)
        
        switch result {
        case let .success(paginated):
            let nextPage = paginated.nextPage
            let array = await getImages(from: paginated.array)
            return .success(Paginated(nextPage: nextPage, array: array))
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func getEvolutionChain(forSpecieID specieID: Int) async -> Result<[Specie], Error> {
        let result = await getSpecie(withID: specieID)
        
        switch result {
        case let .success(specieDetails):
            return await getEvolutionChain(withID: specieDetails.evolutionChainID)
        case let .failure(error):
            return .failure(error)
        }
    }
}

extension PokeAPIService {
    private func getImages(from species: [Specie]) async -> [Specie] {
        var _species: [Specie] = []
        
        await withTaskGroup(of: Specie.self) { taskGroup in
            for specie in species {
                taskGroup.addTask { [weak self] in
                    guard let self = self else { return specie }
                    
                    var _specie = specie
                    
                    if case let .success(data) = await getImage(from: specie.id) {
                        _specie.setImage(data)
                    }
                    
                    return _specie
                }
            }
            
            for await specie in taskGroup {
                _species.append(specie)
            }
        }
        
        return _species
    }
    
    private func getImage(from specieID: Int) async -> Result<Data, Error> {
        await networkProvider.request(networkRoute.getImage(specieID: specieID))
    }
    
    private func getSpecie(withID specieID: Int) async -> Result<SpecieDetails, Error> {
        await networkProvider.request(networkRoute.getSpecie(specieID: specieID),
                                      decodeInto: SpecieDetails.self)
    }
    
    private func getEvolutionChain(withID chainID: Int) async -> Result<[Specie], Error> {
        let result = await networkProvider.request(networkRoute.getEvolutionChain(chainID: chainID),
                                                   decodeInto: EvolutionChainResponse.self)

        switch result {
        case let .success(response):
            let species = await getImages(from: response.flatSpecieChain)
            return .success(species)
        case let .failure(error):
            return .failure(error)
        }
    }
}
