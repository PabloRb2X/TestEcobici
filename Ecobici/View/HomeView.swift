//
//  HomeView.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit

protocol HomeDelegate{
    func onButtonPressed(sender: UIButton)
}

public class HomeView: UIView{
    
    var homeDelegate: HomeDelegate!
    
    var referenceController: HomeController!
    var view: UIView!
    
    let subview: UIView = UIView()
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func initView(reference: HomeController, view: UIView) -> UIView{
        self.referenceController = reference
        view.backgroundColor = UIColor(rgba: barColor)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let ecobiciImage: UIImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.05, width: view.frame.width * 0.8, height: view.frame.height * 0.1))
        ecobiciImage.image = UIImage(named: "ecobici")
        ecobiciImage.contentMode = .scaleAspectFit
        ecobiciImage.clipsToBounds = true
        view.addSubview(ecobiciImage)
        
        let welcomeText: UIButton = UIButton(frame: CGRect(x: ecobiciImage.frame.origin.x, y: ecobiciImage.frame.origin.y + ecobiciImage.frame.height + view.frame.height * 0.1, width: ecobiciImage.frame.width, height: ecobiciImage.frame.height * 0.5))
        welcomeText.setTitle("Bienvenido a EcoBici, en esta app podrás ver los 25 puntos más cercanos a tu ubicación.", for: .normal)
        welcomeText.setTitleColor(UIColor.black, for: .normal)
        welcomeText.titleLabel?.font = UIFont.systemFont(ofSize: regularFontSize)
        welcomeText.titleLabel?.textAlignment = .center
        welcomeText.titleLabel?.numberOfLines = 0
        welcomeText.contentHorizontalAlignment = .center
        welcomeText.contentVerticalAlignment = .top
        view.addSubview(welcomeText)
        
        let startButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.4, height: view.frame.height * 0.06))
        startButton.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.9)
        startButton.backgroundColor = UIColor(rgba: "#2CCB49")
        ///// Ponerle corner radius al boton
        startButton.layer.cornerRadius = 10
        startButton.setTitle("Iniciar", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
        view.addSubview(startButton)
        
        //////////////////// Loader Interface
        
        subview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        subview.backgroundColor = UIColor.black
        subview.alpha = 0.5
        subview.tag = 101
        subview.isHidden = true
        view.addSubview(subview)
        
        indicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.5)
        indicatorView.activityIndicatorViewStyle = .gray
        indicatorView.tag = 102
        indicatorView.isHidden = true
        view.addSubview(indicatorView)
        
        return view
    }
    
    func showLoader(){
        subview.isHidden = false
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    func hideLoader(){
        indicatorView.stopAnimating()
        
        indicatorView.isHidden = true
        subview.isHidden = true
    }
    
    func showAlertError(reference: HomeController, titleText: String, textMessage: String){
        let alertController = UIAlertController(title: titleText, message: textMessage, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Aceptar", style: .default) { (action: UIAlertAction) in
            print("Accept Action");
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(acceptAction)
        reference.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onButtonPressed(sender: UIButton){
        homeDelegate.onButtonPressed(sender: sender)
    }
}
