//
//  ResultsStack.swift
//  Sample2023
//
//  Created by David S Reich on 15/3/2023.
//

import Foundation

class ResultsStack<T> {
    private var resultsStack = [ResultBox]()

    private struct ResultBox {
        var title: String
        var values: [T]
    }

    func clear() {
        resultsStack.removeAll()
    }

    var resultsCount: Int {
        resultsStack.count
    }

    func pushResults(title: String, values: [T]) {
        resultsStack.append(ResultBox(title: title, values: values))
    }

    func popResults() -> (title: String, values: [T])? {
        _ = resultsStack.popLast()

        return getLast()
    }

    func popToTop() -> (title: String, values: [T])? {
        guard !resultsStack.isEmpty else {
            return nil
        }
        resultsStack.removeLast(resultsStack.count - 1)

        return getLast()
    }

    func getLast() -> (title: String, values: [T])? {
        if let resultBox = resultsStack.last {
            return (resultBox.title, resultBox.values)
        }

        return nil
    }

    func getPenultimate() -> (title: String, values: [T])? {
        let count = resultsStack.count
        if count < 2 {
            return getLast()
        }

        let resultBox = resultsStack[count - 2]

        return (resultBox.title, resultBox.values)
    }
}
