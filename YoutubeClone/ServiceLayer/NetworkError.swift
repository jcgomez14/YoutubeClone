
import Foundation

enum NetworkError: String, Error {
    case invalidURL
    case serieizationFailed
    case generic
    case couldNotDecodeData
    case httpReponseError
    case statusCodeError 
    case jsonDecoder
    case unauthorized
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return NSLocalizedString("La URL es invalida", comment: "")
        case .serieizationFailed:
            return NSLocalizedString("Fallo cuando trato de serializar el body del request", comment: "")
        case .generic:
            return NSLocalizedString("La app fallo por un error desconocido. Validar API-KEY", comment: "")
        case .couldNotDecodeData:
            return NSLocalizedString("No se pudo lograr el decode data", comment: "")
        case .httpReponseError:
            return NSLocalizedString("Imposible obtener el HTTPURLResponse", comment: "")
        case .statusCodeError:
            return NSLocalizedString("El status code es diferente a 200", comment: "")
        case .jsonDecoder:
            return NSLocalizedString("Fallo cuando leyo el JSON y no pudo localizar", comment: "")
        case .unauthorized:
            return NSLocalizedString("La sesion finalizo vuelva a iniciarla", comment: "")
        }
    }
}
