/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RealmSwift

class FeedTableViewController: UITableViewController {

  private var dataController: DataController!
  fileprivate var messages: List<Message>!
  private var messagesToken: NotificationToken?

  override func viewDidLoad() {
    super.viewDidLoad()

    let realm = try! Realm()
    User.defaultUser(in: realm)
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    
    messages = User.defaultUser(in: realm).messages
    messagesToken = messages.observe { [weak self] changes in
      guard let tableView = self?.tableView else { return }
      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: modifications)
      case .error:
        break
      }
      
      self?.title = "Feed (\(self?.messages.count ?? 0))"
    }
    
    dataController = DataController(api: StubbedChatterAPI())
    dataController.startFetchingMessages()
  }

  @IBAction func refresh() {
    tableView.reloadData()
  }

  deinit {
    dataController.stopFetchingMessages()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let compose = segue.destination as? ComposeViewController {
      compose.dataController = dataController
    }
  }
}

//MARK: - Tableview methods
extension FeedTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier, for: indexPath) as! FeedTableViewCell
    let message = messages[indexPath.row]
    cell.configureWithMessage(message)
    return cell
  }
}
