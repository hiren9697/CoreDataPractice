//
//  ParentVC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 07/01/25.
//

import UIKit

import UIKit

class ParentVC: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var progressView: UIView = {
        // Create the container view
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isHidden = true // Initially hidden
        
        // Add the activity indicator to the container view
        containerView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        // Add the container view to the parent view
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return containerView
    }()
    
    // MARK: - Show Progress View
    func showProgressView() {
        activityIndicator.startAnimating()
        progressView.isHidden = false
    }
    
    // MARK: - Hide Progress View
    func hideProgressView() {
        activityIndicator.stopAnimating()
        progressView.isHidden = true
    }
}
