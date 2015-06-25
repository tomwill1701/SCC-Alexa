$(document).on 'page:change', ->
  $('.accordion-tabs').each (index) ->
    $(this).children('li').first().children('a').addClass('is-active').next().addClass('is-open').show()
  $('.accordion-tabs').on 'click', 'li > a.tab-link', (event) ->
    accordionTabs = undefined
    nextTab = undefined
    if !$(this).hasClass('is-active')
      event.preventDefault()
      accordionTabs = $(this).closest('.accordion-tabs')
      accordionTabs.find('.is-open').removeClass('is-open').hide()
      nextTab = $(this).next()
      nextTab.toggleClass('is-open').toggle()
      accordionTabs.find('.is-active').removeClass 'is-active'
      $(this).addClass 'is-active'
      nextTab.find('.loading').show()
      nextTab.find('.loading p').text 'Loading'
      $.ajax
        url: nextTab.data('url')
        success: (data) ->
          nextTab.html data
          nextTab.find('.loading').hide()
        error: ->
          nextTab.find('.loading p').text 'Error'
    else
      event.preventDefault()
