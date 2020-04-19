$(function () {
  $(document).on("click", ".upvote", function () {
    var meal_post_id = $(this).parent().data("mealpost-id");

    $.ajax({
      url: `/meal_posts/${meal_post_id}/upvote`,
      method: "PATCH",
      dataType: 'script',
    })
  })

  $(document).on("click", ".downvote", function () {
    var meal_post_id = $(this).parent().data("mealpost-id");

    $.ajax({
      url: `/meal_posts/${meal_post_id}/downvote`,
      method: "PATCH",
      dataType: 'script'
    })
  })
})
