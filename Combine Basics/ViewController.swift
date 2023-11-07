//
//  ViewController.swift
//  Combine Basics
//
//  Created by Lovice Sunuwar on 06/11/2023.
//

import UIKit
import Combine
// Custom Cell
class MyCustomTableCell: UITableViewCell{
    
    private let button: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemCyan
    button.setTitle("Button", for: .normal)
    return button
    }()
    
    let action = PassthroughSubject<String, Never>() // we are passing string while we are haivng Never because this can never pass an error.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapButton(){
        action.send("The Button was tapped.")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width, height: contentView.frame.size.height-6)
    }
    
    
}

class ViewController: UIViewController, UITableViewDataSource {
    
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: Explanation
    // Whenever we call a funciton that has future we need to create a variable to hang on to it.
    // In this case we are creating the one below which takes any of the data types , AnyCancellable is provided in Combine Framework
    var observer: [AnyCancellable] = [] // <- Available in Combine
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        // Calling the Singleton funciton that is using combine
        // Capturing the future, on type anycancleable that is observer we have created above
        APICaller.shared.fetchFruits()
            .receive(on: DispatchQueue.main) // we are telling combine to notify on the main thread to update the data
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
            // Here we have two closuers that is provided in Sink or basically sink has two clousre one is upon completin and other one is on recieving the value
            
        }, receiveValue: { [weak self] value in // you can use the value from this in the sucess case
            self?.models = value
            self?.tableView.reloadData()
        }).store(in: &observer) // <- Since we made an array of the anycancellable for observer to continue using the observer to hold on to the future that our apicaller brings we are storing the value in the array now. this is a in out parameter.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }
        cell.action.sink { string in
            print(string)
        }.store(in: &observer) // we can use only the recieve value because on action passthroughsubject we have metnioned that it does not have error so we dont need to handle the error.
        //cell.textLabel?.text = models[indexPath.row]
        return cell
    }

}

