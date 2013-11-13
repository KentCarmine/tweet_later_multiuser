$(document).ready(function() {
  $("#tweet_form").on("submit", function(event){
    event.preventDefault();

    $(".success-msg").remove();

    $(".tweet_form_elements").prop("disabled", true);
    $(".container").append("<h4 class='wait-msg'>Tweeting, please wait...</h4>");

    var data = { "tweet_text": $("#tweet-box").val(), "tweet_delay": $("#tweet_delay_box").val() }

    $.post("/", data, function(response) {
      $(".tweet_form_elements").prop("disabled", false);
      $(".wait-msg").remove();
      $(".container").append("<h4 class='success-msg'>Tweet sent successfully!</h4>");
      $("#tweet-box").val("");
      $("#tweet_delay_box").val("0");
    });
  });
});
