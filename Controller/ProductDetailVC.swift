//
//  ProductDetailVC.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var img_item: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_totalReview: UILabel!
    @IBOutlet weak var lbl_totalpersentage: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var txtview_des: UITextView!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var btn_heart: UIButton!
    @IBOutlet weak var view_1: UIView!
    @IBOutlet weak var view_2: UIView!
    @IBOutlet weak var view_3: UIView!
    @IBOutlet weak var view_4: UIView!
    @IBOutlet weak var btn_addtocart: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    var selectedProduct: ProductListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor = UIColor.lightGray.cgColor
        let cornerRadius: CGFloat = 10
        let borderWidth: CGFloat = 1

        [view_1, view_2, view_3].forEach { view in
            view?.layer.cornerRadius = cornerRadius
            view?.clipsToBounds = true
            view?.layer.borderColor = borderColor
            view?.layer.borderWidth = borderWidth
        }
        view_4.layer.cornerRadius = 10
        btn_addtocart.layer.cornerRadius = 20
        btn_back.layer.cornerRadius = btn_back.layer.frame.height/2
        btn_heart.layer.cornerRadius = btn_heart.layer.frame.height/2
        btn_share.layer.cornerRadius = btn_share.layer.frame.height/2

        view_main.layer.cornerRadius = 20
        view_main.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top left and top right
        view_main.clipsToBounds = true
        lbl_title.text = selectedProduct?.title
        let price = selectedProduct?.price ?? 0.0
        lbl_price.text = String(format: "$%.2f", price)
        let rating = selectedProduct?.rating?.rate ?? 0.0
        lbl_rating.text = String(format: "%.2f", rating)
        let totalRating = selectedProduct?.rating?.count ?? 0
        lbl_totalReview.text = "\(totalRating) reviews"
        txtview_des.text = selectedProduct?.description
        if let imageUrl = URL(string: selectedProduct?.image ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.img_item.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.img_item.image = UIImage(named: "placeholder")
                    }
                }
            }
            
        } else {
            self.img_item.image = UIImage(named: "placeholder")
        }
        // Do any additional setup after loading the view.
    }
 
    @IBAction func tapOnBackPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnHeart(_ sender: UIButton) {
    }
    @IBAction func tapOnAddtoCardButton(_ sender: UIButton) {
        if let product = selectedProduct {
             CartManager.shared.addToCart(product)

             // Optional success alert before navigation
             let alert = UIAlertController(title: "Added to Cart", message: "\(product.title ?? "Item") has been added to your cart.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to Cart", style: .default, handler: { _ in
                      // Navigate to Tab Bar Index 2 (Cart Tab)
                      self.tabBarController?.selectedIndex = 2
                      self.navigationController?.popToRootViewController(animated: true)
                  }))

                  alert.addAction(UIAlertAction(title: "Stay", style: .cancel))
                  self.present(alert, animated: true)
         }
    }

}
