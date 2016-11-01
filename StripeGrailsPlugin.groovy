class StripeGrailsPlugin {
    def version = '1.7-frontlinesms-TOOLS-1898-SNAPSHOT'
    def grailsVersion = "1.3.7 > *"

    def title = "Stripe"
    def author = "Bobby Warner"
    def authorEmail = "bobbywarner@gmail.com"
    def description = "Plugin for using Stripe to process credit card transactions."
    def documentation = "http://bobbywarner.github.com/grails-stripe"
    def license = "APACHE"
    def issueManagement = [ system: "GitHub", url: "https://github.com/bobbywarner/grails-stripe/issues" ]
    def scm = [ url: "https://github.com/alxndrsn/grails-stripe" ]
    def developers = [ [ name: "Nicholas Vaidyanathan", email: "visionary.software.solutions@gmail.com" ],
            [ name: 'Alex Anderson', email: 'alex@frontlinesms.com' ] ]

    def doWithApplicationContext = {
        com.stripe.Stripe.apiKey = application.config.grails.plugins.stripe.secretKey
    }
}
