<r:require module="stripe"/>

<r:script disposition='head'>
this.stripe_utils = (function() {
	var formSelecter = "${formSelecter}",
	stripeSubmitButtonSelecter = "${formSelecter} input[type=submit], ${formSelecter} .submit-button",
	stripeResponseHandler = function(status, response) {
		var form$, token;
		if (response.error) {
			// re-enable the submit button
			jQuery(stripeSubmitButtonSelecter).removeAttr("disabled");
			// show the errors on the form
			jQuery("#stripe-payment-errors").html(response.error.message);
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
	stripeFormSubmitHandler = function(event) {
		// disable the submit button to prevent repeated clicks
		jQuery(stripeSubmitButtonSelecter).attr("disabled", "disabled");
		// createToken returns immediately - the supplied callback submits the form if there are no errors
		Stripe.createToken({
			number: jQuery('.card-number').val(),
			cvc: jQuery('.card-cvc').val(),
			exp_month: jQuery('.card-expiry-month').val(),
			exp_year: jQuery('.card-expiry-year').val()
		}, stripeResponseHandler);
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
		enable:enable
	};
}());
</r:script>
