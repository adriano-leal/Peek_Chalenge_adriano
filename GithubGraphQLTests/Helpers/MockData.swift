@testable import GithubGraphQL

typealias SearchQueryEdge = SearchRepositoriesQuery.Data.Search.Edge
typealias SearchQueryNode = SearchQueryEdge.Node

extension SearchQueryNode {
  /// Creates a repository node with the desired overriden values.
  /// - Parameters:
  ///   - name: The name of the repository. By default it is the name of the function that invoked this method.
  ///   - owner: The owner of the repository. By default it is an organization - Peek Travel.
  ///   - stargazersCount: The number of people who have starred the repository.
  /// - Returns: A repository search edge node.
  static func makeRepository(
    name: String = #function,
    owner: RepositoryDetails.Owner = .makeOrganization(login: "Peek Travel", avatarUrl: "https://d2z5w7rcu7bmie.cloudfront.net/assets/images/logo.png"),
    stargazersCount: Int = 100
  ) -> SearchQueryNode {
    return try! .init(RepositoryDetails(
      name: name,
      url: "https://github.com/peek/\(name)",
      owner: owner,
      stargazers: .init(totalCount: stargazersCount))
    )
  }
}

/// Creates the desired number of repository edges using the given factory closure.
/// - Parameters:
///   - count: The number of edges to create.
///   - factoryMethod: A closure invoked to create each node instance for the given index count.
///   If not provided, a default initialized value will be created with the repository name being a combination
///   of the index of the count and the name of the function that invoked this method.
///
///   See ``SearchQueryNode.makeRepository(name:owner:stargazersCount:)``
/// - Returns: Factory created repository nodes, with the count matching the given `count` argument.
func makeEdges(
  count: UInt,
  _ factoryMethod: (UInt) -> SearchQueryNode = { .makeRepository(name: "\(#function)-\($0)") }
) -> [SearchQueryEdge] {
  return (0..<count)
    .reduce(into: []) { result, index in
      result.append(.init(node: factoryMethod(index)))
    }
}
