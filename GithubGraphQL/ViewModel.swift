import Apollo
import Foundation

enum GraphQLError: Error {
    case queryTypeMismatch
}

struct GraphClient<Query: GraphQLQuery> {
    typealias ExpectedType = Query
    let response: ExpectedType.Data
    
    init(response: ExpectedType.Data) {
        self.response = response
    }
}

extension GraphClient: GraphQLClient {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy,
        contextIdentifier: UUID?,
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Query.Data>?
    ) -> Cancellable {
        resultHandler?(
            Query.self == ExpectedType.self
            ? .success(.init(data: (self.response as! Query.Data),
                             extensions: nil,
                             errors: nil,
                             source: .cache,
                             dependentKeys: nil))
            : .failure(GraphQLError.queryTypeMismatch)
        )
        return EmptyCancellable()
    }
}


final class ViewModel: ObservableObject {
    private let client: GraphQLClient
    @Published var repos: [RepositoryDetails] = []
    
    init(client: GraphQLClient = ApolloClient.shared) {
        self.client = client
        search(phrase: "graphql")
    }
    
    func search(phrase: String) {
        self.client.searchRepositories(mentioning: phrase) { response in
            switch response {
            case .failure(let error):
                print(error)
                
            case .success(let results):
                self.repos = results.repos
                
//                let pageInfo = results.pageInfo
//                print("pageInfo: \n")
//                print("hasNextPage: \(pageInfo.hasNextPage)")
//                print("hasPreviousPage: \(pageInfo.hasPreviousPage)")
//                print("startCursor: \(String(describing: pageInfo.startCursor))")
//                print("endCursor: \(String(describing: pageInfo.endCursor))")
//                print("\n")
                
                results.repos.forEach { repository in
                    print("Name: \(repository.name)")
                    print("Path: \(repository.url)")
                    print("Owner: \(repository.owner.login)")
                    print("avatar: \(repository.owner.avatarUrl)")
                    print("Stars: \(repository.stargazers.totalCount)")
                    print("\n")
                }
            }
        }
    }
}
