//
//  CartVC.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import UIKit

class CartVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var view_add: UIView!
    @IBOutlet weak var tableview_cart: UITableView!
    @IBOutlet weak var btn_checkout: UIButton!
    @IBOutlet weak var view_opt: UIView!
    
    @IBOutlet weak var btn_allselect: UIButton!
    var cartItems: [ProductListModel] = []
    var itemcount : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        cartItems = CartManager.shared.getCartItems()
         print("Count:- ",cartItems.count)

        view_opt.layer.cornerRadius = view_opt.frame.size.height / 2
        view_opt.clipsToBounds = true
        view_add.layer.cornerRadius = 8
        view_add.clipsToBounds = true
        btn_checkout.layer.cornerRadius = 10
        btn_checkout.clipsToBounds = true
        tableview_cart.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartItems = CartManager.shared.getCartItems()
         print("Count:- ",cartItems.count)
        self.tableview_cart.reloadData()
    }
    
    
    @IBAction func tapOnCheckoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thank You", message: "Your order has been placed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Clear the cart
                CartManager.shared.cartItems.removeAll()
                // Optionally, pop back to previous screen or root
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
    }
    @IBAction func tapOnSelectAll(_ sender: UIButton) {
            let allSelected = cartItems.allSatisfy { $0.isSelected }
                cartItems.indices.forEach { cartItems[$0].isSelected = !allSelected }
            CartManager.shared.cartItems = cartItems
                let iconName = allSelected ? "unselect" : "select"
        btn_allselect.setImage(UIImage(named: iconName), for: .normal)

            // Reload the table
            tableview_cart.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartListTableCell", for: indexPath) as! CartListTableCell
        cell.lbl_title.text = cartItems[indexPath.row].title
        let price = cartItems[indexPath.row].price ?? 0.0
        cell.lbl_price.text = String(format: "$%.2f", price)
        if let imageUrl = URL(string: cartItems[indexPath.row].image ?? "") {
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
        cell.lbl_count.text = "\(cartItems[indexPath.row].quantity)"
        cell.btn_plus.tag = indexPath.row
                cell.btn_minus.tag = indexPath.row
                cell.btn_select.tag = indexPath.row
                cell.btn_select.isSelected = cartItems[indexPath.row].isSelected

                cell.btn_plus.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
                cell.btn_minus.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)
                cell.btn_select.addTarget(self, action: #selector(tickButtonTapped(_:)), for: .touchUpInside)

        
        cell.btn_select.setImage(
            UIImage(named: cartItems[indexPath.row].isSelected ? "select" : "unselect"),
            for: .normal
        )

        return cell
        
    }
    @objc func plusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
               cartItems[index].quantity += 1
               tableview_cart.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    @objc func minusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
             if cartItems[index].quantity > 1 {
                 cartItems[index].quantity -= 1
             } else {
                 cartItems.remove(at: index)
                 CartManager.shared.cartItems = cartItems
             }
             tableview_cart.reloadData()
    }
    @objc func tickButtonTapped(_ sender: UIButton) {
        let index = sender.tag
                cartItems[index].isSelected.toggle()
                CartManager.shared.cartItems = cartItems
                tableview_cart.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        let allSelected = cartItems.allSatisfy { $0.isSelected }
        let iconName = allSelected ? "select" : "unselect"
        btn_allselect.setImage(UIImage(named: iconName), for: .normal)
        
            }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
