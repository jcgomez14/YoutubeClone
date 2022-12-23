
import Foundation

enum NetworkError: String, Error {
    case invalidURL
    case serieizationFailed
    case generic
    case couldNotDecodeData
    case httpReponseError
    case statusCodeError = "Ocurrio un error al tratar de consultar la API"
    case jsonDecoder = "Ocurrio un error al intentar extraer los datos"
    case unauthorized
}
