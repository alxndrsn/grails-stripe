<asset:javascript src="stripe"/>

<asset:script type="text/javascript">
this.stripe_utils = (function() {
	var formSelecter = "${formSelecter}",
	stripeSubmitButtonSelecter = "${formSelecter} input[type=submit], ${formSelecter} .submit-button",
	failureHandler = function(response) {
		// Default error handler can be overridden
		var errorElement;
		// re-enable the submit button
		jQuery(stripeSubmitButtonSelecter).removeAttr("disabled");
		// show the errors on the form
		errorElement = jQuery("#stripe-payment-errors");
		errorElement.show();
		errorElement.html(response.error.message);
	}
	stripeResponseHandler = function(status, response) {
		var form$, token;
		if (response.error) {
			failureHandler(response);
		} else {
			form$ = jQuery(formSelecter);
			// token contains id, last4, and card type
			token = response.id;
			// insert the token into the form so it gets submitted to the server
			form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />");
			// and submit
			disable();
			form$.submit();
			enable();
		}
	},
	registerCustomFailureHandler = function(handler) {
		if(typeof handler === "function") {
			failureHandler = handler;
		}
	},
	stripeFormSubmitHandler = function(event) {
		// disable the submit button to prevent repeated clicks
		jQuery(stripeSubmitButtonSelecter).attr("disabled", "disabled");
		// createToken returns immediately - the supplied callback submits the form if there are no errors

		//check if the user wants to enable address verification or AVS
		var enableAvs = "${enableAvs == 'true'}"

		var options = {
			number: jQuery('.card-number').val(),
			cvc: jQuery('.card-cvc').val(),
			exp_month: jQuery('.card-expiry-month').val(),
			exp_year: jQuery('.card-expiry-year').val()
		}

		if (enableAvs === 'true') {
			var addressInformation = {
						address_line1: jQuery('.card-address-line1').val(),
						address_zip: jQuery('.card-address-zip').val()
			}
			jQuery.extend(options, addressInformation)
		}
		if(options.number === ''
			|| options.cvc === ''
			|| options.exp_month === ''
			|| options.exp_year === '
			|| (enableAvs === 'true' && options.address_line1 === '')
			|| (enableAvs === 'true' && options.address_zip === '')) {
			failureHandler({ error: { code: 'all.fields.required', message: 'Please fill in all form fields below' }});
			return false;
		}

		Stripe.createToken(options, stripeResponseHandler);
		return false; // submit from callback
	},
	disable = function() {
		jQuery(formSelecter).unbind("submit", stripeFormSubmitHandler);
	},
	enable = function() {
		jQuery(formSelecter).bind("submit", stripeFormSubmitHandler);
	};

	if (window.location.protocol === 'file:') {
		alert("stripe.js does not work when included in pages served over file:// URLs.");
	}
	Stripe.setPublishableKey("${publishableKey}");

	return {
		disable:disable,
		enable:enable,
		registerCustomFailureHandler:registerCustomFailureHandler
	};
}());
</asset:script>
