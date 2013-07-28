/* SMOOTH AUTOSCROLLING */

$(function() {
  $('div.nav a').bind('click',function(event){
    var $anchor = $(this);
    
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top
    }, 1500,'easeInOutExpo');
    
    event.preventDefault();
  });
});




/* JQUERY-UI AUTOCOMPLETE */
$(function() {
  var availableHabits = [
    "Added Sugars",
    "Alcohol",
    "Between-Meal Snacking",
    "Binge Drinking",
    "Binge Eating",
    "Biting my Nails",
    "Browsing the Internet",
    "Caffeine",
    "Checking my Email",
    "Chew",
    "Chewing",
    "Chocolate",
    "Cigarettes",
    "Coffee",
    "Crap TV",
    "Cursing",
    "Dessert",
    "Dip",
    "Dipping",
    "Drinking Alcohol",
    "Drinking Coffee",
    "Drinking Soda",
    "Eating Dessert",
    "Eating Processed Sugars",
    "Eating Sweets",
    "Email",
    "Emailing",
    "Emotional Eating",
    "Facebook",
    "Falling Asleep With the TV On", 
    "Fatty Foods",
    "Fidgeting",
    "Fried Foods",
    "iPhone Games",
    "Meat",
    "Midnight Snacking",
    "Multi-tasking",
    "Nail-Biting",
    "Over-Drinking",
    "Over-Eating",
    "Playing Video Games",
    "Processed Sugars",
    "Red Meat",
    "Reddit",
    "Saying 'Like'",
    "Saying 'Ya Know'",
    "Sleeping In",
    "Sleeping With the TV On",
    "Smokeless Tobacco",
    "Smoking",
    "Snacking",
    "Sodium",
    "Staying Up Late",
    "Sugary Drinks",
    "Surfing the Internet",
    "Swearing",
    "Sweets",
    "Texting",
    "Tobacco",
    "TV",
    "Undersleeping",
    "Video Games",
    "Watching Crap TV",
    "Watching TV When I Go to Sleep",
    "Watching TV"
  ];
//  $( "#signup-habit" ).autocomplete({
//      source: availableHabits
//  });
  
  $("#signup-habit").autocomplete({
    source: function(request, response) {
      var results = $.ui.autocomplete.filter(availableHabits, request.term);

      response(results.slice(0, 6));
    }
  });
});