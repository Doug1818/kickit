function email_focus(field, default_value) {
  $email = $(field);
  
  if ($email.val() == default_value) {
    $email.val('');
  }
  
/*  $email.css({'backgroundColor': '#fff'}); */
  $email.removeClass('validated invalidated');
}

function email_blur(field, default_value) {
  $email = $(field);
  
  $email.val($email.val().replace(/\s/g, ''));
  
  if ($email.val() == '') {
    $email.val(default_value);
    $email.removeClass('validated-field invalidated-field');
  }
  else if ($email.val() == default_value) {
    $email.removeClass('validated-field invalidated-field');
/*    $email.css({'backgroundColor': '#999'}); */
  }
  else if (validate_email($email.val())) {
    $email.removeClass('invalidated-field');
    $email.addClass('validated-field');
/*    $email.css({'backgroundColor': '#9f9'}); */
  }
  else {
    $email.removeClass('validated-field');
    $email.addClass('invalidated-field');
/*    $email.css({'backgroundColor': '#f99'}); */
  }
}

function field_focus(field, default_value) {
  $field = $(field);
  
  if ($field.val() == default_value) {
    $field.val('');
  }
  
  $field.css({'backgroundColor': '#999'});
}

function field_blur(field, default_value) {
  $field = $(field);
  
  if ($field.val().replace(/\s/g, '') == '') {
    $field.val(default_value);
  }
}

function validate_email(email)
{
  var at_pos = email.indexOf("@");
  var dot_pos = email.lastIndexOf(".");
  
  return (at_pos >= 1 && dot_pos >= at_pos+2 && email.length > dot_pos + 2);
}