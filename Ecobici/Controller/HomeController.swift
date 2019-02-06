//
//  HomeController.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit

class HomeController: UIViewController, HomeDelegate {
    
    let homeView: HomeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.homeDelegate = self
        
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView(){
        
        self.view = homeView.initView(reference: self, view: self.view)
    }
    
    func onButtonPressed(sender: UIButton){
        homeView.showLoader()
        
        serviceManager.getAccessToken(referenceController: self)
    }
    
    func showMapController(){
        homeView.hideLoader()
        timerToken.startTimer()
        
        let mapController: MapController = MapController()
        self.present(mapController, animated: true, completion: nil)
    }
    
    func errorsEvents(){
        homeView.hideLoader()
        
        homeView.showAlertError(reference: self, titleText: "Error", textMessage: "Error en la petición del servicio")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
