// app/javascript/controllers/push_notification_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["enableButton", "statusText"]

  connect() {
    this.updateStatus()
  }

  updateStatus() {
    if (!("Notification" in window)) {
      this.statusTextTarget.textContent = "このブラウザは通知に対応していません"
      this.enableButtonTarget.disabled = true
      return
    }

    if (Notification.permission === "granted") {
      this.statusTextTarget.textContent = "通知は有効になっています"
      this.enableButtonTarget.classList.add("hidden")
    } else if (Notification.permission === "denied") {
      this.statusTextTarget.textContent = "通知がブロックされています。ブラウザの設定から変更してください"
      this.enableButtonTarget.disabled = true
    } else {
      this.statusTextTarget.textContent = "通知はまだ有効になっていません"
    }
  }

  async enable() {
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) {
      this.statusTextTarget.textContent = "このブラウザはPush通知に対応していません"
      console.log("このブラウザはPush通知に対応していません")
      return
    }

    try {
      const registration = await navigator.serviceWorker.register("/service-worker.js")
      console.log("Service Worker登録完了", registration)
      await this.subscribeToPush(registration)
      this.updateStatus()
    } catch (error) {
      console.error("Service Workerの登録に失敗しました", error)
    }
  }

  async subscribeToPush(registration) {
    const permission = await Notification.requestPermission()
    console.log("通知許可の結果:", permission)
    if (permission !== "granted") {
      console.log("通知が許可されませんでした")
      return
    }

    const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').content
    const convertedKey = this.urlBase64ToUint8Array(vapidPublicKey)

    const subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: convertedKey,
    })
    console.log("購読情報を作成しました:", subscription)

    await this.sendSubscriptionToServer(subscription)
    console.log("購読情報をサーバーに送信しました")
  }

  async sendSubscriptionToServer(subscription) {
    const key = subscription.getKey("p256dh")
    const auth = subscription.getKey("auth")

    await fetch("/push_subscriptions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        endpoint: subscription.endpoint,
        p256dh: btoa(String.fromCharCode(...new Uint8Array(key))),
        auth: btoa(String.fromCharCode(...new Uint8Array(auth))),
      }),
    })
  }

  urlBase64ToUint8Array(base64String) {
    const padding = "=".repeat((4 - (base64String.length % 4)) % 4)
    const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/")
    const rawData = window.atob(base64)
    return Uint8Array.from([...rawData].map((char) => char.charCodeAt(0)))
  }
}
