//
//  SettingsViewController.swift
//  Vinyl
//
//  Created by Ivan Blagajić on 05/04/2019.
//  Copyright © 2019 Five Dollar Milkshake Limited. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias SettingsSection = Section<SettingsCellType>

class SettingsViewController: UITableViewController {
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        title = .settings
        navigationItem.largeTitleDisplayMode = .always
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.backgroundColor = .very
        tableView.rowHeight = 57
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        tableView.separatorColor = .pale
        tableView.sectionHeaderHeight = 33
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 4 * .margin))
        tableView.tableHeaderView = headerView
        let settingsCellReuseId = "SettingsCellReuseId"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellReuseId)
        let headerViewId = "HeaderViewId"
        tableView.register(SettingsHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewId)
        let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { (_, cv, ip, cellType) -> UITableViewCell in
            let cell = cv.dequeueReusableCell(withIdentifier: settingsCellReuseId, for: ip)
            cell.textLabel?.text = cellType.title
            cell.textLabel?.font = .body
            cell.textLabel?.textColor = .dark
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            if cellType != .version {
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }, titleForHeaderInSection: { (dataSource, sectionIndex) -> String? in
            return dataSource.sectionModels[sectionIndex].title
        })
        
        Observable.just([
            SettingsSection(items: [.general, .instructions, .privacy], title: .about),
            SettingsSection(items: [.rate, .share], title: .enjoyUsing),
            SettingsSection(items: [.credits, .version], title: .other)
        ]).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
//        tableView.rx.modelSelected(SettingsCellType.self).subscribe(onNext: { cellType in
//            switch cellType {
//            case .general:
//                <#code#>
//            case .instructions:
//                <#code#>
//            case .privacy:
//                <#code#>
//            case .rate:
//                <#code#>
//            case .share:
//                <#code#>
//            case .credits:
//                <#code#>
//            case .version:
//                <#code#>
//            }
//        }).disposed(by: bag)
    }
}
