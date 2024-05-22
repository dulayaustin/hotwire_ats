// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import applicationController from "./application_controller"
import StimulusReflex from "stimulus_reflex"

StimulusReflex.initialize(application, { applicationController, isolate: true })

// consider removing these options in production
StimulusReflex.debug = true
// end remove

import AlertController from "./alert_controller"
application.register("alert", AlertController)

import ApplicationController from "./application_controller"
application.register("application", ApplicationController)

import DragController from "./drag_controller"
application.register("drag", DragController)

import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)

import FormController from "./form_controller"
application.register("form", FormController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import NotificationsController from "./notifications_controller"
application.register("notifications", NotificationsController)

import SlideoverController from "./slideover_controller"
application.register("slideover", SlideoverController)
