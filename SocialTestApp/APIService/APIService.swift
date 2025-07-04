import UIKit
import Alamofire

class APIService {
    static var shared = APIService()
    private init(){}
    func fetchData(url:String,complation:@escaping (Result<Data,Error>)->Void){
        AF.request(url,method: .get,encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success(let data):
                complation(.success(data))
            case .failure(let error):
                complation(.failure(error))
            }
        }
    }
}
