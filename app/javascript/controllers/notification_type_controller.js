import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["valueInput", "intervalLabel", "fixedTimeLabel"]

  connect() {
    this.toggle()
  }

  toggle() {
    const selected = this.element.querySelector(
      'input[name="task[notification_type]"]:checked'
    )?.value

    if (selected === "fixed_time") {
      this.intervalLabelTarget.classList.add("hidden")
      this.fixedTimeLabelTarget.classList.remove("hidden")
      this.valueInputTarget.placeholder = "例: 12:00"
    } else {
      this.intervalLabelTarget.classList.remove("hidden")
      this.fixedTimeLabelTarget.classList.add("hidden")
      this.valueInputTarget.placeholder = "例: 30"
    }
  }
}