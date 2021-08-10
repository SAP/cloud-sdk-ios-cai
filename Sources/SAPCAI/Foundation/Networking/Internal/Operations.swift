import Foundation
import SAPFoundation

class CAICreateConversationOperation: CAIConversationOperation {
    var createRequest: CAICreateConversationRequest
    override var request: APIRequest {
        self.createRequest
    }
    
    init(_ serviceConfig: CAIServiceConfig, request: CAICreateConversationRequest, finishHandler: @escaping (Result<CAIResponseData, CAIError>) -> Void) {
        self.createRequest = request
        super.init(serviceConfig, finishHandler: finishHandler)
    }
}

class CAILoadConversationOperation: CAIConversationOperation {
    var loadRequest: CAILoadConversationRequest
    override var request: APIRequest {
        self.loadRequest
    }
    
    init(_ serviceConfig: CAIServiceConfig, request: CAILoadConversationRequest, finishHandler: @escaping (Result<CAIResponseData, CAIError>) -> Void) {
        self.loadRequest = request
        super.init(serviceConfig, finishHandler: finishHandler)
    }
}

class CAIPostMessageOperation: CAIConversationOperation {
    var postMessageRequest: CAIPostMessageRequest
    override var request: APIRequest {
        self.postMessageRequest
    }
    
    init(_ serviceConfig: CAIServiceConfig, request: CAIPostMessageRequest, finishHandler: @escaping (Result<CAIResponseData, CAIError>) -> Void) {
        self.postMessageRequest = request
        super.init(serviceConfig, finishHandler: finishHandler)
    }
}

class CAIConversationOperation: AsynchronousOperation {
    var dataTask: SAPURLSessionTask?

    var finishHandler: (Result<CAIResponseData, CAIError>) -> Void

    var serviceConfig: CAIServiceConfig

    var request: APIRequest {
        preconditionFailure("request property must be overridden")
    }

    init(_ serviceConfig: CAIServiceConfig, finishHandler: @escaping (Result<CAIResponseData, CAIError>) -> Void) {
        self.finishHandler = finishHandler
        self.serviceConfig = serviceConfig

        super.init()
    }

    override func execute() {
        self.dataTask = self.jsonAPIDataTask(request: self.request, completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.finish()

            if self.isCancelled {
                self.finishHandler(.failure(CAIError.cancelled))
            } else {
                self.finishHandler(result)
            }
        })

        self.dataTask?.resume()
    }
    
    override func cancel() {
        self.dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Operation handling
    
    func jsonAPIDataTask(request: APIRequest, completionHandler: @escaping ((Result<CAIResponseData, CAIError>) -> Void)) -> SAPURLSessionTask {
        let urlRequest = request.urlRequest(with: self.serviceConfig.baseURL)
        
        return self.serviceConfig.urlSession.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            guard let self = self else {
                completionHandler(.failure(.cancelled))
                return
            }
            if self.isCancelled {
                completionHandler(.failure(.server(nil)))
                return
            }
            
            // check for error
            guard error == nil else {
                completionHandler(.failure(.server(error)))
                return
            }
            
            // check for http error in response
            let e = URLError.lookForError(in: response)
            guard e == nil else {
                if e == .notFound {
                    completionHandler(.failure(.conversationNotFound(e)))
                } else {
                    completionHandler(.failure(.server(e)))
                }
                return
            }
            
            // check for error in data
            guard let data = data else {
                completionHandler(.failure(.server(nil)))
                return
            }
                        
            do {
                let value = try DecoderUtil.decoder.decode(CAIResponseData.self, from: data)
                completionHandler(.success(value))
            } catch { // decoding issue
                completionHandler(.failure(.dataDecoding(error)))
            }
        })
    }
}
