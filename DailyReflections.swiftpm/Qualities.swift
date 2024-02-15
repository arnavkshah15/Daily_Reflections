//
// Qualities.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class QualitiesInput : MLFeatureProvider {

    /// Input text as string value
    var text: String

    var featureNames: Set<String> {
        get {
            return ["text"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "text") {
            return MLFeatureValue(string: text)
        }
        return nil
    }
    
    init(text: String) {
        self.text = text
    }

}


/// Model Prediction Output Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class QualitiesOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// Text label as string value
    var label: String {
        return self.provider.featureValue(for: "label")!.stringValue
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(label: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["label" : MLFeatureValue(string: label)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class Qualities {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    public class var urlOfModelInThisBundle : URL {
        let resPath = Bundle(for: self).url(forResource: "Qualities",
                                            withExtension:"mlmodel")!
        return try! MLModel.compileModel(at: resPath)
        
    }

    /**
        Construct Qualities instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of Qualities.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `Qualities.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct Qualities instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct Qualities instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct Qualities instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Qualities, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct Qualities instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> Qualities {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct Qualities instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Qualities, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(Qualities(model: model)))
            }
        }
    }

    /**
        Construct Qualities instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> Qualities {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return Qualities(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as QualitiesInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as QualitiesOutput
    */
    func prediction(input: QualitiesInput) throws -> QualitiesOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as QualitiesInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as QualitiesOutput
    */
    func prediction(input: QualitiesInput, options: MLPredictionOptions) throws -> QualitiesOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return QualitiesOutput(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        - parameters:
           - input: the input to the prediction as QualitiesInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as QualitiesOutput
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    public func prediction(input: QualitiesInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> QualitiesOutput {
        let outFeatures = try await model.prediction(from: input, options:options)
        return QualitiesOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - text: Input text as string value

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as QualitiesOutput
    */
    public func prediction(text: String) throws -> QualitiesOutput {
        let input_ = QualitiesInput(text: text)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [QualitiesInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [QualitiesOutput]
    */
    public func predictions(inputs: [QualitiesInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [QualitiesOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [QualitiesOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  QualitiesOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
