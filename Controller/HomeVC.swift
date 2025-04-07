//
//  HomeVC.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import UIKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btn_setting: UIButton!
    @IBOutlet weak var collection_categories: UICollectionView!
    @IBOutlet weak var collection_sale: UICollectionView!
    @IBOutlet weak var btn_notification: UIButton!
    @IBOutlet weak var lbl_timer: UILabel!
    
    var productList: [ProductListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_setting.layer.cornerRadius = btn_setting.frame.size.height / 2
        btn_setting.clipsToBounds = true
        btn_notification.layer.cornerRadius = btn_notification.frame.size.height / 2
        btn_setting.clipsToBounds = true
        lbl_timer.layer.cornerRadius = 5
        lbl_timer.clipsToBounds = true
        fetchProductList()
        // Do any additional setup after loading the view.
    }
    
    func fetchProductList() {
        APIManager.alamofireGetRequest(urlString: "https://fakestoreapi.com/products") { json, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                guard let jsonArray = json?.array else {
                    self.showAlert(title: "Error", message: "Invalid data format")
                    return
                }
                
                self.productList = jsonArray.compactMap { ProductListModel($0) }
                print("Product Count: \(self.productList.count)")
                self.collection_sale.reloadData()
                self.collection_categories.reloadData()
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection_categories {
            return self.productList.count
        } else {
            return self.productList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collection_categories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
            cell.view_bg.layer.cornerRadius = cell.view_bg.layer.frame.height/2
            cell.lbl_title.text = self.productList[indexPath.row].title
            if let imageUrl = URL(string: productList[indexPath.row].image ?? "") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.img_cat.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.img_cat.image = UIImage(named: "placeholder")
                        }
                    }
                }
            } else {
                cell.img_cat.image = UIImage(named: "placeholder")
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleCollectionCell", for: indexPath) as! SaleCollectionCell
            cell.btn_like.layer.cornerRadius = cell.btn_like.layer.frame.height/2
            cell.lbl_title.text = self.productList[indexPath.row].title
            let price = productList[indexPath.row].price ?? 0.0
            cell.lbl_price.text = String(format: "$%.2f", price)
            if let imageUrl = URL(string: productList[indexPath.row].image ?? "") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.img_item.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.img_item.image = UIImage(named: "placeholder")
                        }
                    }
                }
                
            } else {
                cell.img_item.image = UIImage(named: "placeholder")
            }
            cell.btn_like.tag = indexPath.row
            cell.btn_like.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
            
            
            return cell
        }
    }
    @objc func likeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
          guard index < productList.count else { return }
          
          let product = productList[index]

          if let cartIndex = CartManager.shared.cartItems.firstIndex(where: { $0.id == product.id }) {
              CartManager.shared.removeFromCart(product)
              sender.setImage(UIImage(named: "like_small"), for: .normal)
          } else {
              // Product not in cart: add it
              CartManager.shared.addToCart(product)
              sender.setImage(UIImage(named: "liked"), for: .normal)
          }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        objVC.selectedProduct = productList[indexPath.row]
        objVC.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(objVC, animated: true)
    }
    // MARK: - UICollectionViewDelegateFlowLayout method
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collection_categories {
            return CGSize(width: 70, height: 80)
        } else
        {
            let collectionViewWidth = collectionView.frame.width/2
            return CGSize(width: collectionViewWidth, height: collectionView.frame.height)
        }
    }
}
