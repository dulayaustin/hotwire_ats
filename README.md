This app is an Applicant Tracking System sample app from a book that I was studying about Rails 7. <br/>
It consist of Hotwire stack such as Turbo, Stimulus, Stimulus Reflex and CableReady <br/>

### Features
It is a simple app for creating job postings and applicants can apply to that postings. <br/>
* Users are the owner/admin of a company.
* They can invite more users to their account through `Settings > Manage Users`
* They can open job postings.
* Applicants can be added manually by the user or they can publicly share their company job postings through `Settings > Careers page` for non logged-in users can apply to it.
* User can email an applicant. Also the applicant can reply to that email.
* Theres a notification feature as well for, when reply email was sent from applicant, and someone comments on applicant
* Card applicant on applicants page can be dragged to stages of application.
* Lastly, it has a report charts on the homepage.

### Production
I deployed the app via Render, you can check it out https://hotwire-ats-app.onrender.com/

### Specification
* Ruby version: `3.3.0`
* Rails version: `7.1.3.4`
* Node version: `22.2.0`
* Database: Postgresql
* CSS: TailwindCSS

### Book Reference
https://book.hotwiringrails.com/
