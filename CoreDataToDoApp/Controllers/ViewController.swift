//
//  ViewController.swift
//  CoreDataToDoApp
//
//  Created by Seun Olalekan on 2021-10-19.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    //MARK: - properties
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private var itemList : [ToDoItem] = []
    
    private var isSelected = false
    
    private let tableView : UITableView =  {
        let tableView = UITableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        
        label.text = "No items"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        
        
        
        return label
        
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureTableView()
        view.addSubview(label)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        label.frame = CGRect(x: (view.width - 150)/2 , y: (view.height-52)/2, width: 150, height: 52)
        
    }
    
    
    
    //MARK: - functions
    
    /// fetch data from coredata
    private func fetchData(){
        
        do {
            guard let results = try context?.fetch(ToDoItem.fetchRequest()) else{return}
            
            itemList = results
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
            
        }catch{
            print(error)
        }
        
        if itemList.isEmpty{
            tableView.isHidden = true
            label.isHidden = false
            
        }else
        
        { tableView.isHidden = false
            label.isHidden = true}
        
        
    }
    
    /// configure tableView
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    /// add new items to list
    @objc private func didTapAdd(){
        
        let alert = UIAlertController(title: "What would you like to add?", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let add = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            
            guard let context = self?.context, let field = alert.textFields?[0] else {return}
            
            let newItem = ToDoItem(context: context)
            
            newItem.title = field.text
            
            
            do{
                try context.save()
                
            }catch{
                print(error)
                
            }
            
            self?.fetchData()
            
            
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }else{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = itemList[indexPath.row]
        
        guard let context = context else {return}
        
        if editingStyle == .delete {
            
            itemList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            do{
                context.delete(item)
                try context.save()
                
            }catch{
                print(error)
            }
            
            fetchData()
            
        }
        
        
    }
    
}

