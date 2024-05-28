import ChartsController from "./charts_controller";

export default class extends ChartsController {
  update(event) {
    this.stimulate('ApplicantsChart#update', event.target, { serializeForm: true })
  }

  get chartOptions() {
    return {
      chart: {
        height: '400px',
        tyle: 'line',
      },
      series: [{
        name: 'Applicants',
        data: this.seriesValue
      }],
      xaxis: {
        categories: this.labelsValue,
        type: 'datetime'
      },
      stroke: {
        curve: 'smooth'
      }
    }
  }
}
