//
//  ProductDetailsVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class ProductDetailsVC: UIViewController {
    // MARK: - Declaration
    
    var productImageView    = ShopImageView(frame: .zero)
    var productTitleLabel   = StoreBoldLabel(with: "Product's Name",
                                             from: .center,
                                             ofsize: 20,
                                             ofweight: .medium,
                                             alpha: 1,
                                             color: UIColor(named: colorAsString.storePrimaryText) ?? .orange)
    
    var descriptionTextView = GroceryTextView(with: "Product's Description")
    var currentUser: UserLocal!
    var currentProduct: ProductLocal!
    
    var addToBasketButton = StoreButton(fontSize: 20, label: "Add")
    
    var productCounter: UIStackView!
    let plusButton = UIButton()
    let minusButton = UIButton()
    let counter = UITextField()
    var count = 0
    
    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUIElements()
        layoutUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireManager.shared.clearCache()
    }
    
    init(currentProduct: ProductLocal, currentUser: UserLocal) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser        = currentUser
        self.currentProduct     = currentProduct
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - @Objectives
    
    
    @objc private func plusButtonTapped() {
        animateCounterView(counter)
        count += 1
        DispatchQueue.main.async {
            self.counter.text = String(self.count)
        }
    }
    
    
    @objc private func minusButtonTapped() {
        if count > 0 {
            animateCounterView(counter)
            count -= 1
            DispatchQueue.main.async { self.counter.text = String(self.count) }
        }
        
    }
    
    
    @objc private func addToBasketButtonTapped(sender: UIView) {
        animateButtonView(sender)
        FireManager.shared.addProductToBasket(for: currentUser, with: currentProduct, howMany: count) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        self.count = 0
        DispatchQueue.main.async { self.counter.text = String(self.count) }
    }
    
    
    
    
    
    
    // MARK: - Private function
    
    private func configureStackViewButtons() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureAddToBasketButton() {
        addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    //MARK: - VC Configuration
    
    
    private func configureUIElements() {
        
    }
    
    
    //MARK: - Layout configuration
    
    
    private func configureUIStackView() {
        plusButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        plusButton.tintColor = UIColor(named: colorAsString.storeTertiary)
        
        minusButton.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        minusButton.tintColor = UIColor(named: colorAsString.storeTertiary)
        
        counter.text = String(count)
        counter.font = UIFont.preferredFont(forTextStyle: .title2)
        counter.textColor = UIColor(named: colorAsString.storeTertiary)
        counter.textAlignment = .center
        counter.isEnabled = false
        
        productCounter                   = UIStackView()
        productCounter.axis              = .horizontal
        productCounter.distribution      = .fillEqually
        productCounter.alignment         = .center
        productCounter.translatesAutoresizingMaskIntoConstraints = false
        minusButton.layer.borderWidth = 2
        counter.layer.borderWidth = 2
        productCounter.addArrangedSubview(minusButton)
        productCounter.addArrangedSubview(counter)
        productCounter.addArrangedSubview(plusButton)
    }
    
    
    
    private func layoutUI() {
        addSubviews(productImageView, productTitleLabel, descriptionTextView)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint           (equalTo: view.topAnchor, constant: -20),
            productImageView.leadingAnchor.constraint       (equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint      (equalTo: view.trailingAnchor, constant: -20),
            productImageView.heightAnchor.constraint        (equalToConstant: 250),
                
            productTitleLabel.topAnchor.constraint          (equalTo: productImageView.bottomAnchor, constant: 10),
            productTitleLabel.leadingAnchor.constraint      (equalTo: view.leadingAnchor, constant: 20),
            productTitleLabel.trailingAnchor.constraint     (equalTo: view.trailingAnchor, constant: -20),
            productTitleLabel.heightAnchor.constraint       (equalToConstant: 30),
            
            productCounter.topAnchor.constraint             (equalTo: productTitleLabel.bottomAnchor, constant: 0),
            productCounter.leadingAnchor.constraint         (equalTo: view.leadingAnchor, constant: 0),
            productCounter.widthAnchor.constraint           (equalToConstant: 150),
            productCounter.heightAnchor.constraint          (equalToConstant: 50),
            
            descriptionTextView.topAnchor.constraint        (equalTo: productCounter.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint    (equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint   (equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint     (equalToConstant: 100),
        ])
    }
    
    // MARK: - Animation
    
    
    private func animateButtonView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
    
    private func animateCounterView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.1, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
    
}


//MARK: - Extension

