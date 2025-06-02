//
//  ViewController.swift
//  calculator-uikit
//
//  Created by Deepan Gnanavel on 02/06/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    private var workings: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }
    
    private func clearAll() {
        workings = ""
        calculatorWorkings.text = ""
        calculatorResults.text = ""
    }
    
    @IBAction func equalsTap(_ sender: UIButton) {
        if isValidInput() {
            let expressionString = workings.replacingOccurrences(of: "%", with: "*0.01")
            let expression = NSExpression(format: expressionString)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                calculatorResults.text = formatResult(result)
            }
        } else {
            showAlert(title: "Invalid Input", message: "Calculator is unable to compute the given expression.")
        }
    }
    
    private func isValidInput() -> Bool {
        let operators: Set<Character> = ["+", "-", "*", "/"]
        let chars = Array(workings)
        
        guard let first = chars.first, !operators.contains(first),
              let last = chars.last, !operators.contains(last) else {
            return false
        }
        
        for i in 1..<chars.count {
            if operators.contains(chars[i]) && operators.contains(chars[i - 1]) {
                return false
            }
        }
        
        return true
    }
    
    private func formatResult(_ result: Double) -> String {
        return result.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", result)
            : String(format: "%.2f", result)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func allClearTap(_ sender: UIButton) {
        clearAll()
    }
    
    @IBAction func backTap(_ sender: UIButton) {
        guard !workings.isEmpty else { return }
        workings.removeLast()
        calculatorWorkings.text = workings
    }
    
    private func appendToWorkings(_ value: String) {
        workings += value
        calculatorWorkings.text = workings
    }
    
    // MARK: - Input Buttons
    
    @IBAction func operatorTap(_ sender: UIButton) {
        if let value = sender.titleLabel?.text {
            appendToWorkings(value)
        }
    }
    
    @IBAction func numberTap(_ sender: UIButton) {
        if let value = sender.titleLabel?.text {
            appendToWorkings(value)
        }
    }
}
