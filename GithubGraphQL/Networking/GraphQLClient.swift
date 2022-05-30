import Apollo
import Foundation

/// An object capable of making GraphQL queries.
protocol GraphQLClient {
  /// Fetches the provided query.
  /// - Parameters:
  ///   - query: The query to fetch.
  ///   - cachePolicy: The caching policy to use in making the request.
  ///   - contextIdentifier: An optional identifier to uniquely identify this request.
  ///   - queue: An optional queue to invoke the resultHandler on
  ///   - resultHandler: An optional handler to receive the result of the request or failure.
  @discardableResult
  func fetch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy,
    contextIdentifier: UUID?,
    queue: DispatchQueue,
    resultHandler: GraphQLResultHandler<Query.Data>?
  ) -> Cancellable
}

extension ApolloClient: GraphQLClient {}
