$ ->
  # enable chosen js
  $(document).on "page:change", ->
    $('.chosen-select').chosen
      allow_single_deselect: true
      no_results_text: 'No results matched'
      width: '200px'

    $(".add-spinner").on "click", (event) ->
      console.log("button clicked!")
      $('.add-spinner').loadingOverlay();
