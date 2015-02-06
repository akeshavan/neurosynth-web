
$(document).ready ->

  return if not $('#page-analysis').length

  createDataTable('#term-analyses-table', '/api/terms', true)
  createDataTable('#topic-set-list-table', '/api/topics', true)
  createDataTable('#analysis-studies-table', null, false, 25, columns)
  createDataTable('#analysis-similarity-table')

  if topic_set?
    createDataTable('#topic-set-table', '/api/topics/' + topic_set)

  columns = [
    { width: '40%' }
    { width: '38%' }
    { width: '15%' }
    { width: '7%' }
  ]


  # autocomplete
  $.get('/analyses/term_names', (result) ->

    $('#term-analysis-search').autocomplete( 
      minLength: 2
      delay: 0
      select: (e, ui) -> 
        window.location.href = '/analyses/terms/' + ui.item.value
      # only match words that start with string, and limit to 10
      source: (request, response) ->
        re = $.ui.autocomplete.escapeRegex(request.term)
        matcher = new RegExp('^' + re, "i" )
        filtered = $.grep(result.data, (item, index) ->
          return matcher.test(item)
        )
        response(filtered.slice(0, 10))
    )
  )
    
  $('#term-analysis-search').keyup((e) ->
    text = $('#term-analysis-search').val()
    window.location.href = ('/analyses/terms/' + text) if (e.keyCode == 13)
  )

  loadAnalysisStudies = ->
    url = '/analyses/' + analysis + '/studies?dt=1'
    $('#analysis-studies-table').DataTable().ajax.url(url).load().order([3, 'desc'])

  loadAnalysisImages = ->
    url = '/analyses/' + analysis  + '/images'
    $.get(url, (result) ->
      loadImages(result.data)
      )

  loadAnalysisSimilarity = ->
    url = '/images/' + rev_inf + '/decode'
    $('#analysis-similarity-table').DataTable().ajax.url(url).load().order([1, 'desc'])
    

  # Load state (e.g., which tab to display)
  activeTab = window.cookie.get('analysisTab')
  $("#analysis-menu li:eq(#{activeTab}) a").tab('show')

  if analysis?
    loadAnalysisStudies()
    loadAnalysisImages()
    loadAnalysisSimilarity()


  # Update cookie to reflect last tab user was on
  $('#analysis-menu a').click ((e) =>
      e.preventDefault()
      activeTab = $('#analysis-menu a').index($(e.target))
      window.cookie.set('analysisTab', activeTab)
      $(e.target).tab('show')
      if activeTab == 0
          viewer.paint()
  )

  $('#load-location').click((e) ->
      xyz = viewer.coords_xyz()
      window.location.href = '/locations?x=' + xyz[0] + '&y=' + xyz[1] + '&z=' + xyz[2]
  )
