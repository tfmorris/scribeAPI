API            = require './api'

module.exports =
  componentDidMount: ->
    if @getActiveWorkflow().name is 'transcribe' and @props.params.subject_id
      @fetchSubject @props.params.subject_id,@getActiveWorkflow().id
    else if @getActiveWorkflow().name is "mark"
        @fetchSubjectSets @getActiveWorkflow().id, @getActiveWorkflow().subject_fetch_limit
    else
      @fetchSubjects @getActiveWorkflow().id, @getActiveWorkflow().subject_fetch_limit

  orderSubjectsByY: (subjects) ->
    subjects.sort (a,b) ->
      return if a.region.y >= b.region.y then 1 else -1

  fetchSubject: (subject_id, workflow_id)->

    request = API.type("subjects").get(subject_id, workflow_id: workflow_id)

    @setState
      subject: []
      currentSubject: null

    request.then (subject)=>
      @setState
        subjects: [subject]
        currentSubject: subject,
        () =>
          if @fetchSubjectsCallback?
            @fetchSubjectsCallback()

  fetchSubjects: (workflow_id, limit) ->
    if @props.overrideFetchSubjectsUrl?
      console.log "Fetching (fake) subject sets from #{@props.overrideFetchSubjectsUrl}"
      $.getJSON @props.overrideFetchSubjectsUrl, (subjects) =>
        @setState
          subjects: subjects
          currentSubject: subjects[0]
        # Does including instance have a defined callback to call when new subjects received?
        if @fetchSubjectsCallback?
          @fetchSubjectsCallback()

    else
      request = API.type('subjects').get
        workflow_id: workflow_id
        limit: limit
        random: true
        scope: "active"

      request.then (subjects) =>
        subject = @orderSubjectsByY(subjects)
        if subjects.length is 0
          @setState noMoreSubjects: true, => console.log 'SET NO MORE SUBJECTS FLAG TO TRUE'
        else
          @setState
            subjects: subjects
            currentSubject: subjects[0], => console.log 'STATE: ', @state

        # Does including instance have a defined callback to call when new subjects received?
        if @fetchSubjectsCallback?
          @fetchSubjectsCallback()
