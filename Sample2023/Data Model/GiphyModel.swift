//
//  GiphyModel.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

struct GiphyModel: Decodable {
    var meta: MetaModel
    var data: [ImageDataModel]

    static func getGiphyModel(// tagString: String,
                              urlString: String,
                              mimeType: String,
                              giphyResult: @escaping((Result<GiphyModel, SampleError>) -> Void)) {
        Task {
            let result = try await Networking.loadData(urlString: urlString) as Result<GiphyModel, SampleError>
            giphyResult(result)
        }
    }
}

extension GiphyModel {
    static func mockGiphyModel() -> GiphyModel {
        let mockData: Result<GiphyModel, SampleError> = BaseTestUtilities.getFishGiphyModelData().decodeData()

        if case .success(let success) = mockData {
            return success
        }

        return GiphyModel(meta: MetaModel(status: 0, msg: ""), data: [])
    }
}
