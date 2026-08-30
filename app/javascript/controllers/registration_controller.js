// app/javascript/controllers/registration_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "submitButton"]

  connect() {
    this.toggle()
  }

  toggle() {
    this.submitButtonTarget.disabled = !this.checkboxTarget.checked
  }
}