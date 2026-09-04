// app/javascript/controllers/push_notification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.registerServiceWorker()
  }

  async registerServiceWorker() {
    if (!("serviceWorker" in navigator)) {
      console.log("このブラウザはService Workerに対応していません")
      return
    }

    try {
      const registration = await navigator.serviceWorker.register("/service-worker.js")
      console.log("Service Worker登録完了", registration)
    } catch (error) {
      console.error("Service Workerの登録に失敗しました", error)
    }
  }
}
