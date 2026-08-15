import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "valueInput", "intervalLabel", "fixedTimeLabel",
    "intervalGroup", "fixedTimeGroup", "intervalHint",
    "hourSelect", "minuteSelect", "hiddenValueInput"
  ]

  connect() {
    this.restoreValue()
    this.toggle()
  }

  restoreValue() {
    const selected = this.element.querySelector(
      'input[name="task[notification_type]"]:checked'
    )?.value
    const currentValue = this.hiddenValueInputTarget.value

    if (!currentValue) return

    if (selected === "fixed_time") {
      const [hour, minute] = currentValue.split(":")
      if (hour) this.hourSelectTarget.value = hour
      if (minute) this.minuteSelectTarget.value = minute
    } else {
      this.valueInputTarget.value = currentValue
    }
  }

  toggle() {
    const selected = this.element.querySelector(
      'input[name="task[notification_type]"]:checked'
    )?.value

    if (selected === "fixed_time") {
      this.intervalLabelTarget.classList.add("hidden")
      this.fixedTimeLabelTarget.classList.remove("hidden")
      this.intervalGroupTarget.classList.add("hidden")
      this.fixedTimeGroupTarget.classList.remove("hidden")
      this.intervalHintTarget.classList.add("hidden")
      this.combineTime()
    } else {
      this.intervalLabelTarget.classList.remove("hidden")
      this.fixedTimeLabelTarget.classList.add("hidden")
      this.intervalGroupTarget.classList.remove("hidden")
      this.fixedTimeGroupTarget.classList.add("hidden")
      this.intervalHintTarget.classList.remove("hidden")
    }
  }

  combineTime() {
    const hour = this.hourSelectTarget.value
    const minute = this.minuteSelectTarget.value
    this.hiddenValueInputTarget.value = `${hour}:${minute}`
  }

  syncIntervalValue(event) {
    event.target.value = event.target.value.replace(/[^0-9]/g, "")
    this.hiddenValueInputTarget.value = event.target.value
  }
}