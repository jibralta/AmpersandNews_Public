//
//  HomeViewController.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/10/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: Properties
    let dataSource = DataSource()
    let categories = Category.categories
    
    var allArticles = [[Article]]()
    private var articlesForCurrentCategory = [Article]() // used to fill dictionary
    var dictionaryOfArticlesPerCategory = [String:[Article]]()
    
    private var tableViewArticlesForSelectedCategory = [Article]()
    
    private var selectedCategoryIndexPath = IndexPath(item: 0, section: 0)
    private var selectedTopArticleIndexPath: IndexPath?
    
    private var indexOfCellBeforeDragging = 0
    var barRectangle = CGRect()

    var barLeftAnchorConstraint: NSLayoutConstraint?
    var barWidthConstraint: NSLayoutConstraint?
    
    var horizontalBarView = UIView()
    private var barWidths: [CGFloat] = [81]
    
    // MARK: IBOutlets
    @IBOutlet weak var categoryImageCollectionView: UICollectionView!
    @IBOutlet weak var categoryTitleCollectionView: UICollectionView!
    @IBOutlet weak var imageViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleViewFlowLayout: UICollectionViewFlowLayout!
        
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImageCollectionView.delegate = self
        categoryImageCollectionView.dataSource = self
        categoryTitleCollectionView.delegate = self
        categoryTitleCollectionView.dataSource = self
        
        getAllArticlesFromAllCategories()
        setupPaging()
        setupHorizontalBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupPaging() {
        categoryImageCollectionView.isSpringLoaded = true
        categoryTitleCollectionView.isSpringLoaded = true
        imageViewFlowLayout.minimumLineSpacing = 0 // between columns
        imageViewFlowLayout.minimumInteritemSpacing = 0 // between items in the same columns so not required here.
    }

    
    func getAllArticlesFromAllCategories() {
        for i in 0..<categories.count {
            let category = categories[i].categoryQuery
            
            self.dataSource.parseArticles(ofCategory: category, completion: { (articles) in
                let articlesOfOneCategory = articles
                self.allArticles.append(articlesOfOneCategory) // appends to an array of array of articles which are separated in order of category
                self.articlesForCurrentCategory = articles
                self.dictionaryOfArticlesPerCategory[category] = self.articlesForCurrentCategory
                
                DispatchQueue.main.async {
                    self.categoryImageCollectionView.reloadData()
                }
            })
        }
    }
    
    private func setupHorizontalBar() {
        
        horizontalBarView = UIView()
        horizontalBarView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6470588235, blue: 0.2117647059, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalBarView)
        
        let leftBarPosition = horizontalBarView.leftAnchor.constraint(equalTo: categoryTitleCollectionView.leftAnchor, constant: 20) 

        barLeftAnchorConstraint = leftBarPosition
        barLeftAnchorConstraint?.isActive = true
        
        // Initial barWidth
        let barWidth = horizontalBarView.widthAnchor.constraint(equalToConstant: barWidths[0])
        
        barWidthConstraint = barWidth
        barWidthConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: categoryImageCollectionView.topAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func configureCategoryBar(at indexPath: IndexPath, _ collectionView: UICollectionView) {
        let width = CGFloat(barWidths[indexPath.item])
        barWidthConstraint?.constant = width
        
        // Get layout attributes to move bar along with selected category as CategoryTitleCollectionView is scrolled independently of the CategoryImageCollectionView
        let selectedCategoryBarAttributes = collectionView.layoutAttributesForItem(at: indexPath)!
        // convert rectangle to superview
        barRectangle = (horizontalBarView.superview?.convert(selectedCategoryBarAttributes.frame, from: collectionView))!
        CATransaction.setDisableActions(true) // disable during animations
        horizontalBarView.frame.origin.x = barRectangle.origin.x + 20
        CATransaction.setDisableActions(false)
    }
    
    func attachBarToSelectedCategory() {
        
        guard let selectedCategoryBarAttributes = categoryTitleCollectionView.layoutAttributesForItem(at: selectedCategoryIndexPath) else { return }
        // convert rectangle to superview
        barRectangle = (horizontalBarView.superview?.convert(selectedCategoryBarAttributes.frame, from: categoryTitleCollectionView))!
        
        CATransaction.setDisableActions(true)
        horizontalBarView.frame.origin.x = barRectangle.origin.x + 20
        CATransaction.setDisableActions(false)
        
    }
    
    func estimateFrameForText(_ label: String) -> CGFloat {

        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22.75, weight: UIFont.Weight.heavy) ]
        let label = NSAttributedString(string: label, attributes: attributes)

        return label.size().width
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = imageViewFlowLayout.itemSize.width
        let proportionalOffset = imageViewFlowLayout.collectionView!.contentOffset.x / itemWidth
        return Int(round(proportionalOffset))
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // create funcion for calc width at indexpath.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoryTitleCollectionView {
            var paddedWidth: CGFloat = 400
            let padding: CGFloat = 20 // space between category title text.  Space to the left of the anchor point
            
            // width determined by text in label of indexpath
            let categoryLabel = categories[indexPath.item].categoryTitle
            let barWidth = estimateFrameForText(categoryLabel)
            paddedWidth = barWidth + padding
            if indexPath.item > 0 {
                barWidths.append(barWidth)
            }
            
            // if last indexPath, the width will be the entire frame width and gradient overlay stretches too.
            if indexPath == IndexPath(item: categories.count - 1, section: 0) {
                return CGSize(width: view.frame.width, height: 50)
            } else {
                return CGSize(width: paddedWidth, height: 50)
            }
            
        } else {
            // If the collection view is the ImgCollectionView...
            // if last indexPath, the width will be the entire frame width
            if indexPath == IndexPath(item: categories.count - 1, section: 0) {
                return CGSize(width: view.frame.width, height: collectionView.frame.height)
            } else {
                // the size is the designated size set in the storyboard
                return CGSize(width: imageViewFlowLayout.itemSize.width, height: collectionView.frame.height)
            }
        }
    }
    
    
    // MARK: CollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryImageCollectionView {
            guard let categoryImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: TOP_HEADLINE_CELL, for: indexPath) as? CategoryImageCollectionViewCell else { return UICollectionViewCell() }
            
            let currentCategory = self.categories[indexPath.item]
            let currentCategoryQuery = currentCategory.categoryQuery
            
            let articlesForCollectionViewCell = self.dictionaryOfArticlesPerCategory[currentCategoryQuery]
            guard let topArticle = articlesForCollectionViewCell?.first else { return categoryImageCell }
            
            categoryImageCell.titleLabel.text = topArticle.title
            categoryImageCell.sourceLabel.text = topArticle.source?.name
            
            if indexPath.item == 0 {
                categoryImageCell.logoImg.isHidden = false
            } else {
                categoryImageCell.logoImg.isHidden = true
            }
            
            dataSource.downloadImage(from: topArticle.urlToImage!) { (image) in
                categoryImageCell.categoryImage.image = image
            }

            return categoryImageCell
        }
        
        if collectionView == categoryTitleCollectionView {
            guard let categoryTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: CATEGORY_TITLE_CELL, for: indexPath) as? CategoryTitleCollectionViewCell else { return UICollectionViewCell() }
            categoryTitleCell.categoryLabel.text = Category.categories[indexPath.item].categoryTitle
            return categoryTitleCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == categoryImageCollectionView {
            guard let categoryImageCell = cell as? CategoryImageCollectionViewCell else { return }
            categoryImageCell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
            
            if indexPath == IndexPath(item: categories.count - 1, section: 0) {
                categoryImageCell.gradientImgOverlay.bindEdgesToSuperview()
            }
        }
    }
    

    // MARK: CollectionView Methods to Segue or Scroll To Next Category
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryTitleCollectionView {
            selectedCategoryIndexPath = indexPath
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
            categoryImageCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            categoryTitleCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            configureCategoryBar(at: indexPath, collectionView)

            }
        
        if collectionView == categoryImageCollectionView {
            selectedCategoryIndexPath = indexPath
            performSegue(withIdentifier: CATEGORY_IMG_TO_TOP_ARTICLE, sender: self)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        attachBarToSelectedCategory()
    }


    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        attachBarToSelectedCategory()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        attachBarToSelectedCategory()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == categoryImageCollectionView {
            // Stop scrollView from sliding
            targetContentOffset.pointee = scrollView.contentOffset
            
            // calc where scrollView should snap to
            let indexOfMajorCell = self.indexOfMajorCell()
            let swipeVelocityThreshold: CGFloat = 0.5
            var didUseSwipeToSkipCell = false
            
            // determine if it's a drag or a swipe
            let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < categories.count && velocity.x > swipeVelocityThreshold
            let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
            let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
            didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
            
            if didUseSwipeToSkipCell {
                // Swiping
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                    self.selectedCategoryIndexPath = IndexPath(item: indexOfMajorCell + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1), section: 0)
                    self.configureCategoryBar(at: self.selectedCategoryIndexPath, scrollView as! UICollectionView)
                    self.categoryImageCollectionView.scrollToItem(at: self.selectedCategoryIndexPath, at: .left, animated: true)
                    self.categoryTitleCollectionView.scrollToItem(at: self.selectedCategoryIndexPath, at: .left, animated: true)
                    scrollView.layoutIfNeeded()
                }, completion: nil)
            } else {
                // Dragging
                if indexOfMajorCell <= categories.count - 1 {
                    selectedCategoryIndexPath = IndexPath(item: indexOfMajorCell, section: 0)
                    configureCategoryBar(at: selectedCategoryIndexPath, scrollView as! UICollectionView)
                    categoryImageCollectionView.scrollToItem(at: self.selectedCategoryIndexPath, at: .left, animated: true)
                    categoryTitleCollectionView.scrollToItem(at: self.selectedCategoryIndexPath, at: .left, animated: true)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let articleDetailVC = segue.destination as? ArticleDetailViewController {
            let selectedTopHeadlineIndexPath = self.selectedCategoryIndexPath
            let category = categories[selectedTopHeadlineIndexPath.item].categoryQuery
            let articlesForCategory = self.dictionaryOfArticlesPerCategory[category]
            
            if segue.identifier == CATEGORY_IMG_TO_TOP_ARTICLE {
                articleDetailVC.article = articlesForCategory![0]
            } else if segue.identifier == TOP_ARTICLES_TO_SELECTED {
                if let selectedTopArticleIndexPath = self.selectedTopArticleIndexPath {
                    articleDetailVC.article = articlesForCategory![selectedTopArticleIndexPath.row + 1] // Skip index 0 because displayed in collection view
                }
                
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let nextFiveArticlesCell = tableView.dequeueReusableCell(withIdentifier: TOP_5_ARTICLES, for: indexPath) as? TopArticlesTableViewCell else { return UITableViewCell() }
        guard let next5Articles = dictionaryOfArticlesPerCategory[categories[tableView.tag].categoryQuery] else { return nextFiveArticlesCell }
        
        tableViewArticlesForSelectedCategory = next5Articles
        
        if next5Articles.count >= indexPath.row + 1 { // there may be less than 5 articles per category
            // skip articles at index 0 because the first article in array is displayed in the collection view.
            let articleForCell = next5Articles[indexPath.row + 1]
            
            nextFiveArticlesCell.titleLabel.text = articleForCell.title
            nextFiveArticlesCell.newsSourceLabel.text = articleForCell.author
            
            dataSource.downloadImage(from: articleForCell.urlToImage!) { (image) in
                nextFiveArticlesCell.articleImage.image = image
            }
        }
        return nextFiveArticlesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTopArticleIndexPath = indexPath
        performSegue(withIdentifier: TOP_ARTICLES_TO_SELECTED, sender: self)
    }
}

extension UIView {
    /// Adds constraints to the superview so that this view has same size and position.
    /// Note: This fails the build if the `superview` is `nil` – add it as a subview before calling this.
    func bindEdgesToSuperview() {
        guard let superview = superview else {
            preconditionFailure("`superview` was nil – call `addSubview(view: UIView)` before calling `bindEdgesToSuperview()` to fix this.")
        }
        translatesAutoresizingMaskIntoConstraints = false
        ["H:|-0-[subview]-10-|", "V:|-0-[subview]-0-|"].forEach { visualFormat in
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        }
    }
}




