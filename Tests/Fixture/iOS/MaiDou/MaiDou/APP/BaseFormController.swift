//
//  BaseFormController.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/5.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import QuickForm

class BaseFormController: BaseViewController {

    var formView: FormView!
    
    var form: Form {
        get {
            return formView.form
        }
        set {
            formView.form = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView = FormView(frame: CGRect(x: 0, y: 0, width: .screenWidth, height: .screenHeight))
        formView.backgroundColor = .backgroundColor
        view.addSubview(formView)
    }
}
