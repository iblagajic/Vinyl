//
//  CustomActionSheetViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajic on 08/12/2018.
//  Copyright © 2018 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomActionSheetViewController: UIViewController {
    fileprivate let tableView = DynamicTableView(forAutoLayout: ())
    fileprivate let header = CustomActionSheetHeader(forAutoLayout: ())
    private let bag = DisposeBag()
    
    init(options: [ActionSheetOption]) {
        super.init(nibName: nil, bundle: nil)
        Observable.just(options).bind(to: tableView.rx.items).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.layoutIfNeeded()
        tableView.tableHeaderView = header
    }
    
    override func loadView() {
        let root = UIView(frame: UIScreen.main.bounds)
        
        root.addSubview(tableView)
        tableView.tableHeaderView = header
        
        self.view = root
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            header.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
        
        root.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 77
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 0)
        tableView.separatorColor = .veryLightPink
    }
}

extension Reactive where Base: UITableView {
    
    func items(_ items: Observable<[ActionSheetOption]>) -> Disposable {
        let cellReuseId = "ActionSheetCellId"
        base.register(CustomActionSheetCell.self, forCellReuseIdentifier: cellReuseId)
        return items.bind(to: base.rx.items(cellIdentifier: cellReuseId)) { (_, option, cell) in
            if let cell = cell as? CustomActionSheetCell {
                cell.update(option: option)
            }
        }
    }
}

extension UIViewController {
    
    func presentCustomActionSheet(with options: [ActionSheetOption]) -> Observable<ActionSheetOption> {
        let actionSheet = CustomActionSheetViewController(options: options)
        actionSheet.modalPresentationStyle = .overCurrentContext
        present(actionSheet, animated: true)
        let close: Observable<ActionSheetOption?> = actionSheet.header.closeButton.rx.tap.map { nil }
        let selected: Observable<ActionSheetOption?> = actionSheet.tableView.rx.modelSelected(ActionSheetOption.self).map { $0 }
        return Observable.merge(close, selected)
            .do(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).filterNil()
    }
    
}
