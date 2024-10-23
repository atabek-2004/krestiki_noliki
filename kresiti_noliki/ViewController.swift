import UIKit

class ViewController: UIViewController {
    
    enum Player {
        case none
        case cross
        case nought
    }
    
    var board: [Player] = Array(repeating: .none, count: 9)
    var currentPlayer: Player = .cross
    var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBoard()
    }
    
    func setupBoard() {
        let gridSize: CGFloat = 3
        let buttonSize = view.frame.size.width / gridSize
        
        for i in 0..<Int(gridSize) {
            for j in 0..<Int(gridSize) {
                let button = UIButton(frame: CGRect(x: CGFloat(i) * buttonSize, y: CGFloat(j) * buttonSize, width: buttonSize, height: buttonSize))
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.tag = i * Int(gridSize) + j
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                view.addSubview(button)
                buttons.append(button)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        guard board[index] == .none else { return }
        
        board[index] = currentPlayer
        sender.setTitle(currentPlayer == .cross ? "X" : "O", for: .normal)
        sender.setTitleColor(currentPlayer == .cross ? .red : .blue, for: .normal)
        
        if checkForWin(for: currentPlayer) {
            showAlert(title: "\(currentPlayer == .cross ? "Crosses" : "Noughts") Win!")
        } else if !board.contains(.none) {
            showAlert(title: "It's a draw!")
        } else {
            currentPlayer = currentPlayer == .cross ? .nought : .cross
        }
    }
    
    func checkForWin(for player: Player) -> Bool {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]             // Diagonals
        ]
        
        for pattern in winPatterns {
            if pattern.allSatisfy({ board[$0] == player }) {
                return true
            }
        }
        
        return false
    }
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        board = Array(repeating: .none, count: 9)
        currentPlayer = .cross
        for button in buttons {
            button.setTitle(nil, for: .normal)
        }
    }
}

