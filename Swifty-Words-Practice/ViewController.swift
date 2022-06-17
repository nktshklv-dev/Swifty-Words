//
//  ViewController.swift
//  Swifty-Words-Practice
//
//  Created by Nikita  on 6/17/22.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswerTextField: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var doneWords = 0
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.text = "ANSWERS"
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.textAlignment = .center
        view.addSubview(answersLabel)
        
        
        currentAnswerTextField = UITextField()
        currentAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        currentAnswerTextField.placeholder = "Tap letters to guess"
        currentAnswerTextField.font = UIFont.systemFont(ofSize: 36)
        currentAnswerTextField.isUserInteractionEnabled = false
        currentAnswerTextField.textAlignment = .center
        view.addSubview(currentAnswerTextField)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(tappedSubmit), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(tappedClear), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 60),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -60),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4,constant: -60),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswerTextField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            submit.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor, constant: 10),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            clear.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor, constant: 10),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4{
            for column in 0..<5{
                
                let letterButton = UIButton(type: .system)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                let frame = CGRect(x: column * width, y: height * row, width: width, height: height)
                
                letterButton.frame = frame
                letterButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.gray.cgColor
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
                
                
            }
        }
       
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        
    }
    
    
    func startGame(){
        var clueString = " "
        var answerString = " "
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    answerString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = answerString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterButtons.count == letterBits.count{
            for i in 0..<letterButtons.count{
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    @objc func tappedSubmit(_ sender: UIButton){
        guard let answerText = currentAnswerTextField.text else {
            return
        }
        if let solutionIndex = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            var answersStrings = answersLabel.text?.components(separatedBy: "\n")
            answersStrings?[solutionIndex] = answerText
            answersLabel.text = answersStrings?.joined(separator: "\n")
            currentAnswerTextField.text = ""
            score += 10
            doneWords += 1
            
            
            if doneWords == 7{
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Let's go!", style: .default, handler: levelUp)
                ac.addAction(action)
                present(ac, animated: true, completion: nil)
            }
            
        }
        else{
            if currentAnswerTextField.text != ""{
                let ac = UIAlertController(title: "You're wrong!", message: "Try another variant", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                currentAnswerTextField.text = ""
                for button in activatedButtons {
                    button.isHidden = false
                }
                present(ac, animated: true, completion: nil)
                
                if score != 0{
                    score -= 5
                }
            }
           
        }
        
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        startGame()
        for button in letterButtons {
            button.isHidden = false
        }
        
    }
    @objc func tappedClear(_ sender: UIButton){
        currentAnswerTextField.text = ""
        for button in activatedButtons{
            button.isHidden = false
        }
        
    }
    @objc func tappedButton(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else{
            return
        }
        currentAnswerTextField.text = currentAnswerTextField.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
        
    }
    


}

