//
//  HomeView.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import presenter
import UIKit

class HomeView:UIViewController, IHomeView{
    private let presenter:IHomePresenter
    
    init(presenter:IHomePresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setView(view: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.shutdown()
    }
    
    func displayFavs(favs: [String]) {
        
    }
    
    func displayImg(imgRef: String, imgBase64: String) {
        
    }
    
    func displayRests(rests: [ModelRestaurant]) {
        
    }
    
    func error(error: KotlinException) {
        
    }
}
