//
//  APIManager.swift
//  HistorIA
//
//  Created by Alumno on 15/03/24.
//
// APIManager.swift
import Foundation

class APIManager {
    static let shared = APIManager()
    
    func fetchData(query: String, completion: @escaping (ApiResponse?) -> Void) {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://historia-api.fly.dev/search?query=\(encodedQuery)") else {
                completion(nil)
                return
            }
    

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No se recibieron datos.")
                completion(nil)
                return
            }
            
            // Imprime los datos recibidos
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos:")
                print(jsonString)
            } else {
                print("No se pudieron convertir los datos a cadena.")
            }
            
            
            do {
                let decodedData = try JSONDecoder().decode(ApiResponse.self, from: data)
                completion(decodedData)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

}

