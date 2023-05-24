import XCTest
import Quick
import Nimble
@testable import onTopPoke

final class PokeAPIServiceSpec: AsyncSpec {
    override class func spec() {
        var networkProviderStub: NetworkProviderStub!
        var sut: PokeAPIService!
        
        beforeEach {
            networkProviderStub = NetworkProviderStub()
            sut = PokeAPIService(networkProvider: networkProviderStub)
        }
        
        describe("getSpecies") {
            context("request success") {
                let fileName = "speciePaginatedResult-single"
                
                beforeEach {
                    let decodable: Paginated<Specie> = JSONReader().getFromFile(named: fileName)
                    let decodableResult = DecodableRouteResult(route: PokeAPIRoute.getSpecies(page: Page(limit: 20, offset: 0)),
                                                               result: .success(decodable))
                    networkProviderStub.append(decodableResult)
                    
                    let data = UIImage(systemName: "person")!.pngData()!
                    let dataResult = DataRouteResult(route: PokeAPIRoute.getImage(specieID: 1),
                                                     result: .success(data))
                    networkProviderStub.append(dataResult)
                }
                
                it("returns expected nextPage") {
                    let result = await sut.getSpecies(at: Page(limit: 20, offset: 0))
                    expect(result).to(beSuccess { paginated in
                        expect(paginated.nextPage).to(equal(Page(limit: 20, offset: 20)))
                    })
                }
                
                it("returns expected specie") {
                    let result = await sut.getSpecies(at: Page(limit: 20, offset: 0))
                    expect(result).to(beSuccess { paginated in
                        expect(paginated.array.first?.id).to(equal(1))
                    })
                }
                
                it("returns species with images") {
                    let result = await sut.getSpecies(at: Page(limit: 20, offset: 0))
                    expect(result).to(beSuccess { paginated in
                        expect(paginated.array.first?.image).toNot(beNil())
                    })
                }
            }
            
            context("request failure") {
                beforeEach {
                    let routeResult = DecodableRouteResult(route: PokeAPIRoute.getSpecies(page: Page(limit: 20, offset: 0)),
                                                           result: .failure(StubError.custom))
                    networkProviderStub.append(routeResult)
                }
                
                it("returns expected error") {
                    let result = await sut.getSpecies(at: Page(limit: 20, offset: 0))
                    expect(result).to(beFailure { error in
                        expect(error).to(matchError(StubError.custom))
                    })
                }
            }
        }
        
        describe("getEvolutionChain") {
            context("existent specieDetails") {
                let fileName = "specieDetails-single"
                
                beforeEach {
                    let decodable: SpecieDetails = JSONReader().getFromFile(named: fileName)
                    let routeResult = DecodableRouteResult(route: PokeAPIRoute.getSpecie(specieID: 1),
                                                           result: .success(decodable))
                    networkProviderStub.append(routeResult)
                }
                
                context("request success") {
                    let fileName = "evolutionChain"
                    
                    beforeEach {
                        let decodable: EvolutionChainResponse = JSONReader().getFromFile(named: fileName)
                        let decodableResult = DecodableRouteResult(route: PokeAPIRoute.getEvolutionChain(chainID: 1),
                                                                   result: .success(decodable))
                        networkProviderStub.append(decodableResult)
                        
                        let data = UIImage(systemName: "person")!.pngData()!
                        let dataResult = DataRouteResult(route: PokeAPIRoute.getImage(specieID: 1),
                                                         result: .success(data))
                        networkProviderStub.append(dataResult)
                    }
                    
                    it("returns expected chain") {
                        let result = await sut.getEvolutionChain(forSpecieID: 1)
                        expect(result).to(beSuccess { species in
                            expect(species.first?.id).to(equal(1))
                        })
                    }
                    
                    it("returns species with images") {
                        let result = await sut.getEvolutionChain(forSpecieID: 1)
                        expect(result).to(beSuccess { species in
                            expect(species.first?.image).toNot(beNil())
                        })
                    }
                }
                
                context("request failure") {
                    beforeEach {
                        let routeResult = DecodableRouteResult(route: PokeAPIRoute.getEvolutionChain(chainID: 1),
                                                               result: .failure(StubError.custom))
                        networkProviderStub.append(routeResult)
                    }
                    
                    it("returns expected error") {
                        let result = await sut.getEvolutionChain(forSpecieID: 1)
                        expect(result).to(beFailure { error in
                            expect(error).to(matchError(StubError.custom))
                        })
                    }
                }
            }
            
            context("non-existent specieDetails") {
                beforeEach {
                    let routeResult = DecodableRouteResult(route: PokeAPIRoute.getSpecie(specieID: 1),
                                                           result: .failure(StubError.custom))
                    networkProviderStub.append(routeResult)
                }
                
                it("returns expected error") {
                    let result = await sut.getEvolutionChain(forSpecieID: 1)
                    expect(result).to(beFailure { error in
                        expect(error).to(matchError(StubError.custom))
                    })
                }
            }
        }
    }
}
