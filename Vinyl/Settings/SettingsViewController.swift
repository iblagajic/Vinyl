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
import StoreKit

typealias SettingsSection = Section<SettingsCellType>

class SettingsViewController: UITableViewController {
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        title = .settings
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = .empty
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
            cell.textLabel?.textColor = cellType == .version ? .mediumGrey : .dark
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
        
        tableView.rx.modelSelected(SettingsCellType.self).subscribe(onNext: { [unowned self, weak navigationController] cellType in
            switch cellType {
            case .general:
                let generalInformationBody = String(format: .generalInformationText, String.discogs, String.reachOut)
                let links = [Link(text: .discogs, path: "https://www.discogs.com"), Link(text: .reachOut, email: .email)].compactMap { $0 }
                let generalViewController = SettingsTextViewController(with: generalInformationBody, tappableParts: links, boldPart: nil, title: .generalInformation)
                navigationController?.pushViewController(generalViewController, animated: true)
            case .instructions:
                let instructionsBody = String(format: .instructionsMessage, String.catalogNumber, String.catalogNumber)
                let links = [Link(text: .catalogNumber, path: "https://ourpastimes.com/catalog-numbers-vinyl-records-8518643.html")].compactMap { $0 }
                let instructionsViewController = SettingsTextViewController(with: instructionsBody, tappableParts: links, boldPart: nil, title: .instructionsTitle)
                navigationController?.pushViewController(instructionsViewController, animated: true)
            case .privacy:
                let privacyBody = String(format: .privacyMessage, String.privacyMessageHighlighted, String.email, String.github)
                let links = [Link(text: .email, email: .email), Link(text: .github, path: "https://github.com/iblagajic/Vinyl")].compactMap { $0 }
                let privacyViewController = SettingsTextViewController(with: privacyBody, tappableParts: links, boldPart: .privacyMessageHighlighted, title: .privacyTitle)
                navigationController?.pushViewController(privacyViewController, animated: true)
            case .rate:
                SKStoreReviewController.requestReview()
            case .share:
                self.share()
            case .credits:
                let creditsBody = String(format: .vinylIcon + "\n" + .cameraIcon + "\n" + .appIcon, String.freepik, String.smashicons, String.alexanderKahlkopf)
                let links = [Link(text: .freepik, path: "https://www.freepik.com"),
                             Link(text: .smashicons, path: "https://smashicons.com"),
                             Link(text: .alexanderKahlkopf, path: "https://iconmonstr.com")].compactMap { $0 }
                let generalViewController = SettingsTextViewController(with: creditsBody, tappableParts: links, boldPart: nil, title: .credits)
                navigationController?.pushViewController(generalViewController, animated: true)
            case .version:
                break
            }
        }).disposed(by: bag)
    }

    private func share(){
        if let appStoreUrl = URL(string: "https://apps.apple.com/us/app/vinyl-scan-and-see-the-info/id1433818198") {
            let objectsToShare = [String.shareTitle, appStoreUrl, UIImage.launch ?? UIImage()] as [Any]
            let shareViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(shareViewController, animated: true, completion: nil)
        }

    }
}
