import XCTest
@testable import onTopPoke

final class SpeciesListPresenterTests: XCTestCase {
    override func setUp() {}
    
    override func tearDown() {}
    
    func test_getSpecies_whenLoading_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: true)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when it's loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_requestsFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(pokemonServiceMock.gotSpecies, "getSpecies should request from Service when it's NOT loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_setsLoading() {
        let pokemonServiceStub = PokemonServiceStub()
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       paginationManager: paginationManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetIsLoading, "getSpecies should set PaginationManaging.isLoading when not loading and next page exists.")
        XCTAssertTrue(paginationManagerMock.isLoading, "getSpecies should set PaginationManaging.isLoading to true when not loading and next page exists.")
    }
    
    // test if sets spinner view
    
    func test_getSpecies_whenNilNextPage_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: nil, isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when next page inexists.")
    }
    
    func test_getSpecies_onServiceSuccess_updatesNextPage() {
        let pokemonServiceStub = PokemonServiceStub()
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       paginationManager: paginationManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetNextPage, "getSpecies should set PaginationManaging.nextPage on service success.")
    }
    
    func test_getSpecies_onServiceSuccess_requestsImages() {
        let pokeAPIServiceMock = PokeAPIServiceMock()
        let paginationManager = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: pokeAPIServiceMock,
                                       pokemonService: PokemonServiceStub(),
                                       paginationManager: paginationManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(pokeAPIServiceMock.gotImages, "getSpecies should request images when PokemonService completes successfully.")
    }
    
    func test_getImages_onDefer_disablesLoading() {
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       paginationManager: paginationManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetIsLoading, "getImages should set PaginationManaging.isLoading when deferred.")
        XCTAssertFalse(paginationManagerMock.isLoading, "getImages should set PaginationManaging.isLoading to false when deferred.")
    }
    
    func test_getImages_onResult_appendsSpecies() {
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let speciesBeforeCall = sut.species
        sut.getSpecies()
        let speciesAfterCall = sut.species
        
        XCTAssertNotEqual(speciesBeforeCall.count, speciesAfterCall.count, "getImages should update Presenter's species when receives new species on completion.")
    }
    
    func test_getImages_onResult_removesFooterSpinner() {
        let viewControllerMock = SpeciesListViewControllerMock()
        let sut = SpeciesListPresenter(viewControllerDelegate: viewControllerMock,
                                       pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.setFooterSpinnerVisibility, "getImages should set footer spinner visibility on completion.")
        XCTAssertFalse(viewControllerMock.isFooterSpinnerViewVisible, "getImages should set PaginationManaging.isLoading to false on completion.")
    }
    
    func test_getImages_onResult_reloadsData() {
        let viewControllerMock = SpeciesListViewControllerMock()
        let sut = SpeciesListPresenter(viewControllerDelegate: viewControllerMock,
                                       pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.reloadedData, "getImages should reload ViewController data on completion.")
    }
}
