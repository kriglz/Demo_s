//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    private let searchBar = UISearchBar()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .black
        
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .white
        searchBar.placeholder = "Search"
        
        searchBar.searchTextField.tintColor = .systemPink
        searchBar.searchTextField.keyboardAppearance = .dark
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        
        let clearImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        searchBar.setImage(clearImage, for: .clear, state: .normal)
        
        let containerView = UIView()
        
        view.addSubview(containerView)
        containerView.addSubview(searchBar)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalTo: searchBar.heightAnchor).isActive = true
        
        searchBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalTo: searchBar.searchTextField.heightAnchor).isActive = true
        
        searchBar.searchTextField.widthAnchor.constraint(equalTo: searchBar.widthAnchor).isActive = true
        searchBar.searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor).isActive = true
        searchBar.searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        
        searchBar.searchTextField.setContentHuggingPriority(.required, for: .vertical)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
