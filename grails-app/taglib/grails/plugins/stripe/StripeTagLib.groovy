/* Copyright 2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package grails.plugins.stripe

import com.stripe.Stripe

class StripeTagLib {
    static namespace = 'stripe'
    
    /**
     * Creates the JavaScript required to process the credit card form.
     *
     * @attr formSelecter REQUIRED the field formSelecter
     */
    def script = { attrs, body ->
        verifyAttributePresent(attrs, 'formSelecter')
        out << render(template: "/stripe/script",
                model: [ publishableKey: getPublishableKey(), formSelecter:attrs.formSelecter, enableAvs: attrs.enableAvs ],
                plugin: 'stripe')

        def initialiseForm = attrs.initForm==null || Boolean.parseBoolean(attrs.initForm)
        if(initialiseForm){
            out << render(template: "/stripe/pageSetup", plugin: 'stripe')
	}
    }
    
    /**
     * Creates the form to input credit card details.
     */
    def creditCardInputs = { attrs, body ->
        def cssClass = attrs.cssClass
        out << render(template: "/stripe/creditCardInputs",
                model: [cssClass: cssClass, enableAvs: attrs.enableAvs],
                plugin: 'stripe')
    }

    private def getPublishableKey() {
        def publishableKey = grailsApplication.config.grails.plugins.stripe.publishableKey
        if(!publishableKey){
            throw new IllegalArgumentException("publishableKey must be provided! Please set it in your grails config")
        }
        return publishableKey
    }

    private def verifyAttributePresent(attrs, name) {
        if(!attrs[name]){
            throw new IllegalArgumentException("$name must be provided! Please pass it as an attribute")
        }
    }
}

