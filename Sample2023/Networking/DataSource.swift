//
//  DataSource.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Foundation

class DataSource {
    var resultsStack = ResultsStack<ImageDataModel>()

    func getData(tagString: String,
                 urlString: String,
                 mimeType: String,
                 completion: @escaping (SampleError?) -> Void) {
        GiphyModel.getGiphyModel(urlString: urlString, mimeType: mimeType) { result in
            switch result {
            case .success(let giphyModel):
                // we need to publish on the main thread
                DispatchQueue.main.async {
                    self.resultsStack.pushResults(title: tagString, values: giphyModel.data)
                    completion(nil)
                }
            case .failure(let error):
                if case .responseNot200(let responseCode, let data) = error {
                    if [401, 403].contains(responseCode), let data = data {
                        let result: Result<MessageModel, SampleError> = data.decodeData()

                        if case .success(let messageModel) = result {
                            let message = responseCode == 403 ? "Your API Key might be incorrect.  Go to Settings to check it." : messageModel.message
                            completion(.apiNotHappy(message: message))
                            return
                        }
                    }
                }

                print(">>> error: \(error)")
                completion(error)
            }
        }
    }

    var resultsDepth: Int {
        resultsStack.resultsCount
    }

    func clearAllResults() {
        resultsStack.clear()
    }

    func popResults() -> [ImageDataModel]? {
        return resultsStack.popResults()?.values
    }

    func popToTop() -> [ImageDataModel]? {
        return resultsStack.popToTop()?.values
    }

    var currentResults: [ImageDataModel]? {
        resultsStack.getLast()?.values
    }

    var penultimateTitle: String {
        return resultsStack.getPenultimate()?.title ?? ""
    }

    var title: String {
        return resultsStack.getLast()?.title ?? ""
    }

    var tagsArray: [String] {
        var tagsSet = Set<String>()

        if let imageModels = currentResults {
            for imageModel in imageModels {
                tagsSet.formUnion(imageModel.tags)
            }
        }

        return [String](tagsSet).sorted { $0 < $1 }
    }
}

class MockDataSource: DataSource {
    override func getData(tagString: String, urlString: String, mimeType: String, completion: @escaping (SampleError?) -> Void) {
        DispatchQueue.main.async {
            self.resultsStack.pushResults(title: tagString, values: GiphyModel.mockGiphyModel().data)
            completion(nil)
        }
    }
}
