// Toggle
$(document).on('pagebeforeshow', function(){
    $('.togsupinfo').click(function(){
        $('.supinfo').toggle();
    });
});


// Stripe
var subscription;

$(document).on('pageinit', '#billing', function(){
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  subscription.setupForm();
});

subscription = {
  setupForm: function() {
    $('#user_billing').submit(function() {
      $('input[type=submit]').attr('disabled', true);
      $('#checking').text("Checking card information...");
      subscription.processCard();
      return false;
    });
  },
  processCard: function() {
    var card;
    card = {
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    Stripe.createToken(card, subscription.handleStripeResponse);
  },
  handleStripeResponse: function(status, response) {
    if (status == 200) {
      $('#user_stripe_card_token').val(response.id);
      $('#stripe_error').hide();
      $('#checking').hide();
      $('#submitting').text("Submitting securely...");
      $('#user_billing')[0].submit();
    } else {
    	$('#checking').hide();
      $('#stripe_error').text(response.error.message);
      $('.ui-submit').removeClass('ui-btn-active')
      $('input[type=submit]').attr('disabled', false);
    }
  }
};

//Carousel
$(document).on('pageshow', '#car', function(){
    if (typeof (carousel) == "undefined") {
        initChoixPhotos(); }
});

initChoixPhotos = function () {
    document.addEventListener('pageshow', '#car', function (e) { e.preventDefault(); }, false);

	var	carousel,
		el,
		i,
		page,
		slides = [
			'<strong>Swipe</strong> to learn more <br> about <strong>Kick-It</strong> >',
			
			'<div><strong>We Create a Custom Plan…</strong></div><p>First, you tell us a little about yourself and what habit you’re trying to kick. We take that information and come up with a personalized plan for you.</p>',
			'<div><strong>…And then Help You <br>Keep to It.</strong></div><p>Making a plan is, of course, the easy part. The hard part is actually doing it on a daily basis. We use the latest behavioral sciences research on social and financial incentives, timely reminders, and proven coaching strategies to keep you engaged and improving.</p>', 
			'<div><strong>Free to Use…<br>So Long as You Use It</strong></div><p>The service is free so long as you check in once a day and report how you did the day before. If you don’t check in, however, we charge you for that. We call it a “Reverse Subscription,” because you only pay if you don’t use it.</p>'
		];

	carousel = new SwipeView('#wrapper', {
		numberOfPages: slides.length,
		hastyPageFlip: true
	});

	// Load initial data
	for (i=0; i<3; i++) {
		page = i==0 ? slides.length-1 : i-1;

		el = document.createElement('span');
		el.innerHTML = slides[page];
		carousel.masterPages[i].appendChild(el)
	}

	carousel.onFlip(function () {
		var el,
			upcoming,
			i;

		for (i=0; i<3; i++) {
			upcoming = carousel.masterPages[i].dataset.upcomingPageIndex;

			if (upcoming != carousel.masterPages[i].dataset.pageIndex) {
				el = carousel.masterPages[i].querySelector('span');
				el.innerHTML = slides[upcoming];
			}
		}
	});
}

// Add / Remove Fields
$(document).on('pagebeforeshow', function(){
  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('div').hide();
    return event.preventDefault();
  });
  return $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });
});

//$(document).on('pageinit', '#cal', function(){
//    alert('Pageinit');
//});
//
//$('#cal').on('pageinit', function () {
//    alert('Alert!');
//});