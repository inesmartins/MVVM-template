struct CountryDetailViewModel: ViewModel {

    let name: String
    let code: String

    init(withMovieId id: Int) {
        self.movieId = id
    }

    public func pickStore(_ store: Store) {
        // TODO: implement
    }

}
