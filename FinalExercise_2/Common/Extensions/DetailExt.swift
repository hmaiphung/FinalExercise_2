//
//  File.swift
//  FinalExercise_2
//
//  Created by Phung Huy on 22/09/2023.
//

import Foundation

extension DetailUserViewController {
    
    func formatDateString(_ dateString: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatterInput.date(from: dateString) {
            return dateFormatterOutput.string(from: date)
        }
        
        return "Date not available"
    }
}
