import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.requestPermission()
    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  requestPermission() {
    if (Notification.permission === "default") {
      Notification.requestPermission()
    }
  }

  startPolling() {
    this.checkNotifications()
    this.pollingInterval = setInterval(() => {
      this.checkNotifications()
    }, 60000)
  }

  stopPolling() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval)
    }
  }

  checkNotifications() {
    fetch("/notifications/due_tasks")
      .then(response => response.json())
      .then(tasks => {
        tasks.forEach(task => {
          this.showNotification(task)
        })
    })
    .catch(error => {
      console.error("fetch error:", error) 
    })
  }

  showNotification(task) {
    if (Notification.permission !== "granted") return

    new Notification("Unstuck", {
      body: `「${task.name}」の報告時間になりました。`
    })
  }
}