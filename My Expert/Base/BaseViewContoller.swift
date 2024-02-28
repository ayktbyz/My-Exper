//
//  BaseViewContoller.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreOriginalNavigationBarStyle()
    }
    
    private func customizeNavigationBar() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .red
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .red
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        let rightBarButton: UIButton = UIButton()
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "house.fill", withConfiguration: config)
        rightBarButton.setImage(image, for: UIControl.State())
        rightBarButton.addTarget(self, action: #selector(goToHome(sender:)), for: UIControl.Event.touchUpInside)
        rightBarButton.sizeToFit()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    private func restoreOriginalNavigationBarStyle() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = nil
            navigationController?.navigationBar.titleTextAttributes = nil
        }
        
        navigationController?.navigationBar.tintColor = navigationController?.navigationBar.barTintColor
    }
    
    func changeRightBarButtonItem(button: UIButton) {
        let newBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = newBarButtonItem
    }
    
    @objc func goToHome(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let homeViewController = storyboard.instantiateViewController(withIdentifier: HomePageViewController.identifier) as? HomePageViewController {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}
