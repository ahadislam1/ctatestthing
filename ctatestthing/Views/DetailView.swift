//
//  DetailView.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import Kingfisher

class DetailView: UIView {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "photo")
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title"
        l.textAlignment = .center
        l.numberOfLines = 3
        return l
    }()
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.text = "OK"
        tv.isEditable = false
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func configureView(event: Event) {
        if let image = event.images.first {
            imageView.kf.setImage(with: URL(string: image.url))
        }
        
        titleLabel.text = event.name
        textView.text = "\(event.info ?? ""))\n\(event.dates.start.localDate)\n\( event.priceRanges?.first?.currency ?? "") \(event.priceRanges?.first?.min ?? 0) - \(event.priceRanges?.first?.max ?? 0)"
        
    }
    
    public func configureView(object: ArtObject) {
        imageView.kf.setImage(with: URL(string: object.webImage.url))
        titleLabel.text = object.longTitle
        textView.isHidden = true
        backgroundColor = .systemGray3
    }
    
    private func commonInit() {
        backgroundColor = .secondarySystemBackground
        setupImageView()
        setupTitleLabel()
        setupTextView()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)])
    }
    
    private func setupTextView() {
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)])
    }
}
