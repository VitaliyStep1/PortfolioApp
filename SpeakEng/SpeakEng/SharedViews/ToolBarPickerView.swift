//
//  ToolBarPickerView.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 29.11.2021.
//

import UIKit
import SnapKit

protocol ToolBarPickerViewItem {
    var title: String { get }
}

class ToolBarPickerView: UIView {
    private var toolBar: UIToolbar?
    private var pickerView: UIPickerView?
    private var cancelAction: (() -> Void)?
    private var doneAction: ((ToolBarPickerViewItem?) -> Void)?
    private var items:[ToolBarPickerViewItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        pickerView.dataSource = self
        pickerView.delegate = self
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(pickerView.snp.width).multipliedBy(0.7)
        }
        
        self.pickerView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneTitle = "Done".localized()
        let doneButtonItem = UIBarButtonItem(title: doneTitle, style: .plain, target: self, action: #selector(doneButtonClicked))
        let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelTitle = "Cancel".localized()
        let cancelButtonItem = UIBarButtonItem(title: cancelTitle, style: .plain, target: self, action: #selector(cancelButtonClicked))
        
        toolBar.setItems([cancelButtonItem, spaceButtonItem, doneButtonItem], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.addSubview(toolBar)
        let toolBarHeightToWidth = 44.0 / 375.0
        toolBar.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(pickerView.snp.top)
            maker.height.equalTo(toolBar.snp.width).multipliedBy(toolBarHeightToWidth)
        }
        self.toolBar = toolBar
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    }
    
    @objc func doneButtonClicked() {
        var item: ToolBarPickerViewItem? = nil
        if let row = pickerView?.selectedRow(inComponent: 0) {
            if items.indices.contains(row) {
                item = items[row]
            }
        }
        doneAction?(item)
    }
    
    @objc func cancelButtonClicked() {
        cancelAction?()
    }
}

extension ToolBarPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard items.indices.contains(row) else {
            return nil
        }
        
        let title = items[row].title
        return title
    }
}

extension ToolBarPickerView {
    func show(items:[ToolBarPickerViewItem], selectedIndex: Int, doneAction: @escaping ((ToolBarPickerViewItem?) -> Void), cancelAction: (() -> Void)?) {
        self.items = items
        self.doneAction = doneAction
        self.cancelAction = cancelAction
        pickerView?.reloadAllComponents()
        pickerView?.selectRow(selectedIndex, inComponent: 0, animated: false)
        superview?.bringSubviewToFront(self)
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
