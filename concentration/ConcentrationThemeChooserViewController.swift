//
//  ConcentrationThemeChooserViewController.swift
//  concentration
//
//  Created by Echo Wang on 8/2/19.
//  Copyright © 2019 Echo Wang Studio. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: VCLLoggingViewController, UISplitViewControllerDelegate {

    override var vclLoggingName: String{
        return "ThemeChooser"
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    */

    let themes = [
        "Sports":"⚽️🏀🏈🥎🎾🏐🏉🎱🏓⛷⛸⛳️",
        "Faces":"😀😅😇😍🥰😘🙃😉🤪😡🥶😨",
        "Animals":"🐶🐱🐭🐰🦊🐻🐼🐨🐯🦁🐮🐷"
    ]
    
    // set self as split view's delegate, in iphone it's still in split view even it doen't show as split view
    // awakeFromNib is a function that's called on every object that comes out of interface builder
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController{
            if cvc.theme == nil {
                // the return values are kind of inverse
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        // performSegue(withIdentifier: "Choose Theme", sender: sender)
        // conditional perform segue
        if let cvc = splitViewDetailConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                // reset the theme while not reset the game
                cvc.theme = theme
            }
        // for iphone without splitView
        } else if let cvc = lastSeguedToConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        // .last is detail view
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // strong pointer, keep in the heap
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Choose Theme"{
            /*
            if let button = sender as? UIButton{
                if let themeName = button.currentTitle, let theme = themes[themeName]{
            */
            // (sender as? UIButton) could return nil, need to optional? it
            // these two if lets are so related to each other, put them on the same line
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                // segue.destination is a UIViewController
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }

}
