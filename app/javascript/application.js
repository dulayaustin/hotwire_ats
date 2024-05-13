// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./channels"
import CableReady from "cable_ready"
import mrujs from "mrujs";
import { CableCar } from "mrujs/plugins"

mrujs.start({
  plugins: [
    new CableCar(CableReady)
  ]
})

import "trix"
import "@rails/actiontext"
