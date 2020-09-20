//
//  MovieCollectionViewCell.swift
//  StudyOfNetworking
//
//  Created by Macbook on 11.09.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "MovieCollectionViewCell"
    
    private var urlString: String = ""

    let moviePoster: UIImageView = {
        let movieView = UIImageView()
        movieView.contentMode = .scaleToFill
        movieView.layer.cornerRadius = 20
        movieView.layer.masksToBounds = true
        return movieView
    }()
    let ratingImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "star")
        return image
    }()
    let movieTitle: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    let movieDate: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .italicSystemFont(ofSize: 15)
        return label
    }()
    let movieOverview: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.numberOfLines = 0
        return label
    }()
    let movieRating: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        
        self.addSubview(movieDate)
        self.addSubview(movieTitle)
        self.addSubview(moviePoster)
        self.addSubview(movieRating)
        self.addSubview(movieOverview)
        self.addSubview(ratingImage)
        
        moviePoster.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 250))
        }
        movieTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(moviePoster.snp.right).offset(8)
            make.width.equalTo(200)
        }
        ratingImage.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.left.equalTo(movieTitle.snp.right)
            make.top.equalTo(self).offset(0)
            make.right.equalTo(self).offset(8)
        }
        movieDate.snp.makeConstraints { (make) in
            make.left.equalTo(moviePoster.snp.right).offset(8)
            make.top.equalTo(movieTitle.snp.bottom).offset(8)
        }
        movieOverview.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(8)
            make.left.equalTo(moviePoster.snp.right).offset(8)
            make.top.equalTo(movieDate.snp.bottom).offset(8)
            make.bottom.equalTo(0)
        }
        movieRating.snp.makeConstraints { (make) in
            make.top.equalTo(ratingImage.snp.bottom)
            make.right.equalTo(self).offset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, releaseDate: movie.year,
                 rating: movie.rate, overview: movie.overview,
                 poster: movie.posterImage)
    }
    
    private func updateUI(title: String?, releaseDate: String?, rating: Double?, overview: String?, poster: String?) {
        
        self.movieTitle.text = title
        let date = convertDateFormater(releaseDate)
        self.movieDate.text = "Release: \(date)"
        guard let rate = rating else { return }
        self.movieRating.text = String(rate)
        self.movieOverview.text = overview
        
        guard let posterString = poster else { return }
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        guard let posterImage = URL(string: urlString) else {
            self.moviePoster.image = UIImage(named: "noImage")
            return
        }
        self.moviePoster.image = nil
        getImageDataFrom(url: posterImage)
    }
    
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.moviePoster.image = image
                }
            }
        }.resume()
    }
    
    private func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}











