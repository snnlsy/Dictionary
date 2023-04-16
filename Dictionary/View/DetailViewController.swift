//
//  DetailViewController.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 25.03.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var wordTitleLabel: UILabel!
    @IBOutlet private weak var phoneticLabel: UILabel!
    @IBOutlet private weak var voiceButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var nounButton: UIButton!
    @IBOutlet private weak var verbButton: UIButton!
    @IBOutlet private weak var adjectiveButton: UIButton!
    
    private var detailViewModel: DetailViewModel!
    var word: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
    }
    
    private func setup() {
        detailViewModel = DetailViewModel(self.word)
        detailViewModel.delegate = self
    }

    private func setupView() {
        let leftArrowImage = UIImage(named: "leftArrow")
        navigationController?.navigationBar.backIndicatorImage = leftArrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = leftArrowImage
        navigationController?.navigationBar.tintColor = UIColor(hexString: "#686868")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        let nibDetailTableViewCell = UINib(nibName: K.Id.detailTVCell, bundle: nil)
        let nibSynonymTableViewCell = UINib(nibName: K.Id.synonymTVCell, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibDetailTableViewCell, forCellReuseIdentifier: K.Id.detailTVCell)
        tableView.register(nibSynonymTableViewCell, forCellReuseIdentifier: K.Id.synonymTVCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        wordTitleLabel.text = self.word
        wordTitleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
        phoneticLabel.font = UIFont.systemFont(ofSize: 12.0)

        let voiceImage = UIImage(named: "voice")
        voiceButton.backgroundColor = .white
        voiceButton.layer.cornerRadius = 24
        voiceButton.setImage(voiceImage, for: .normal)
        voiceButton.layer.shadowColor = UIColor.black.cgColor
        voiceButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        voiceButton.layer.shadowOpacity = 0.1
        voiceButton.layer.shadowRadius = 5.0
        
        let cancelImage = UIImage(named: "cancel")
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.isHidden = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = K.Color.blurBorder.cgColor
        cancelButton.layer.cornerRadius = 19
        nounButton.layer.borderColor = K.Color.blurBorder.cgColor
        nounButton.layer.cornerRadius = 19
        verbButton.layer.borderColor = K.Color.blurBorder.cgColor
        verbButton.layer.cornerRadius = 19
        adjectiveButton.layer.borderColor = K.Color.blurBorder.cgColor
        adjectiveButton.layer.cornerRadius = 19
    }
}


extension DetailViewController: DetailViewModelProtocol {
    
    func setPhoneticLabel(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.phoneticLabel.text = text
        }
    }
    
    func reloadData() {
        tableView.reloadDataAsync()
    }
}


extension DetailViewController {
    
    @IBAction private func didCancelButtonClicked(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = true
            self?.nounButton.layer.borderWidth = 0
            self?.verbButton.layer.borderWidth = 0
            self?.adjectiveButton.layer.borderWidth = 0
        }
    }
    
    @IBAction private func didNounButtonClicked(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = false
            self?.nounButton.layer.borderWidth = 1
        }
    }
    
    @IBAction private func didVerbButtonClicked(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = false
            self?.verbButton.layer.borderWidth = 1
        }
    }
    
    @IBAction private func didAdjectiveButtonClicked(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.cancelButton.isHidden = false
            self?.adjectiveButton.layer.borderWidth = 1
        }
    }
}


extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.wordDetailListCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == detailViewModel.wordDetailListCount {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: K.Id.synonymTVCell, for: indexPath) as! SynonymTableViewCell
            cell.synonymList = detailViewModel.synonymList
            cell.synonymCollectionView.reloadDataAsync()
            return cell
        }
        
        let wordDetailIndex = detailViewModel.wordDetailFlatList[indexPath.row].index
        let wordDetailType = detailViewModel.wordDetailFlatList[indexPath.row].type
        let wordDetailDefination = detailViewModel.wordDetailFlatList[indexPath.row].defination
        let wordDetailExample = detailViewModel.wordDetailFlatList[indexPath.row].example
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.Id.detailTVCell, for: indexPath) as! DetailTableViewCell
    
        let typeStr = wordDetailType.capitalized
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.blue, .font: UIFont.italicSystemFont(ofSize: 18)]
        let attributedStr = NSAttributedString(string: typeStr, attributes: attribute)
        let mutableAttributedStr = NSMutableAttributedString(
            string: String(describing: wordDetailIndex + 1) + " - ")
        mutableAttributedStr.append(attributedStr)

        cell.typeLabel.attributedText = mutableAttributedStr
        cell.definationLabel.text = wordDetailDefination
        
        if let example = wordDetailExample {
            let attribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#AAAAAA")]
            let attributedStr = NSAttributedString(string: example, attributes: attribute)
            let mutableAttributedStr = NSMutableAttributedString(string: "Example\n\n")
            mutableAttributedStr.append(attributedStr)
            cell.exampleLabel.attributedText = mutableAttributedStr
            cell.exampleLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == detailViewModel.wordDetailListCount {
            return 140
        }
        return UITableView.automaticDimension
    }
}
