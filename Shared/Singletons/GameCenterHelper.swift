//
//  GameCenterHelper.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 5/7/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import GameKit

struct Achievement {
    let identifier: String
    let points: Int
}

class GameCenterHelper {
    
    static let shared = GameCenterHelper()
    private init() { }
    
    static let GCAuthenticateNotification = "GCAuthenticatedNotification"
    
    let achievements = [Achievement(identifier: Constants.SILVER_MEDAL_ACHIEVEMENT_IDENTIFIER, points: Constants.POINTS_FOR_SILVER_MEDAL), Achievement(identifier: Constants.GOLDEN_MEDAL_ACHIEVEMENT_IDENTIFIER, points: Constants.POINTS_FOR_GOLDEN_MEDAL)]
    
    func authenticateLocalPlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler =  {(viewController : UIViewController?, error : Error?) -> Void in
            if let viewController = viewController {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let rootViewController = appDelegate.window!.rootViewController
                rootViewController?.present(viewController, animated: true, completion: nil)
            } else if localPlayer.isAuthenticated {
                print("*** Game Center: Player is authenticated")
                NotificationCenter.default.post(name: Notification.Name(GameCenterHelper.GCAuthenticateNotification), object: nil)
            } else {
                print("*** Game Center: Skip Game Center")
            }
        }
    }
    
    func isAuthenticated() -> Bool {
        return GKLocalPlayer.localPlayer().isAuthenticated
    }
    
    func checkForAchievements(userScore: Int) {
        func checkCompleteAchievement(achievement: Achievement,userScore: Int) -> GKAchievement? {
            if userScore >= achievement.points {
                let achieve = GKAchievement(identifier: achievement.identifier)
                achieve.showsCompletionBanner = true
                achieve.percentComplete = 100
                return achieve
            }
            return nil
        }
        
        if isAuthenticated() {
            var gkachieves = [GKAchievement]()
            achievements.forEach {
                if let achieve = checkCompleteAchievement(achievement: $0, userScore: userScore) {
                        gkachieves.append(achieve)
                    print("*** Game Center Helper: Complete Achievement: \($0.identifier)")
                }
            }
            if gkachieves.count > 0 {
                GKAchievement.report(gkachieves, withCompletionHandler: { error in
                    if let error = error {
                        print("*** Game Center Helper: Error reporting Achivements: \(error.localizedDescription)")
                    }
                    else {
                        print("*** Game Center Helper: Achieves reported")
                    }
                })
            }
        }
    }
    
    func updateLeaderboard(identifier: String, value: Int) {
        if isAuthenticated() {
            let score = GKScore(leaderboardIdentifier: identifier)
            score.value = Int64(value)
            GKScore.report([score], withCompletionHandler: { (error: Error?) -> Void in
                if let error = error {
                    print("*** Game Center Helper: Error reporting score to Leaderboard: \(error.localizedDescription)")
                } else {
                    print("*** Game Center Helper: Score reported to leaderboard")
                }
            })
        }
    }
}
