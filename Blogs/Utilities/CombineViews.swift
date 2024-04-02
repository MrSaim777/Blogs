import Combine

class DataViewModel: ObservableObject {
    @Published var data: String = ""
}

class BlogViewModelListner: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let dataViewModel: DataViewModel
    
    init(dataViewModel: DataViewModel) {
        self.dataViewModel = dataViewModel
        
        // Subscribe to changes in DataViewModel
        dataViewModel.$data
            .sink { [weak self] newData in
                self?.getArticles()
            }
            .store(in: &cancellables)
    }
    
    func getArticles() {
        // Call your API here to get articles
        print("API call to get articles triggered")
    }
}

let dataViewModel = DataViewModel()
let blogViewModel = BlogViewModelListner(dataViewModel: dataViewModel)
