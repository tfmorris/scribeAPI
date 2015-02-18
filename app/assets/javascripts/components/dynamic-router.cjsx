React = require("react")
{Router, Routes, Route, Link} = require 'react-router'

MainHeader         = require('../partials/main-header')
HomePageController = require("./home-page-controller")
ImageSubjectViewer_mark = require('./image-subject-viewer-mark')
ImageSubjectViewer_transcribe = require('./image-subject-viewer-transcribe')

DynamicRouter = React.createClass

  getInitialState: ->
    console.log 'GETTING STATE'
    project: null
    mark_tasks: null
    transcribe_tasks: null
    
  componentDidMount: ->
    $.getJSON '/project', (result) => 
      console.log 'result of ajax', result

      @setState project:           result.project
      @setState home_page_content: result.project.home_page_content 
      @setState pages:             result.project.pages
      
      for workflow in @state.project.workflows
        console.log 'inside the for loop'
        console.log 'workflow', workflow
        @setState mark_tasks: workflow.tasks if workflow.key is 'mark'
        @setState transcribe_tasks: workflow.tasks if workflow.key is 'transcribe'
    

  controllerForPage: (page) ->
    React.createClass
      displayName: "#{page.name}Page"
      render: ->
        <div dangerouslySetInnerHTML={{__html: page.content}} />

  

  render: ->
    # do nothing until project loads from API
    # return null # just for now
    return null if @state.project is null or @state.mark_tasks is null or @state.transcribe_tasks is null
    
    <div className="panoptes-main">
      <MainHeader pages={@state.pages} />
      <div className="main-content">
        <Routes>
          <Route path='/'             handler={HomePageController}            name="root"  content={@state.home_page_content} />
          <Route path='/mark'         handler={ImageSubjectViewer_mark}       name='mark'       tasks={@state.mark_tasks} />
          <Route path='/transcribe'   handler={ImageSubjectViewer_transcribe} name='transcribe' tasks={@state.transcribe_tasks} />

          { @state.pages.map (page, key) =>
              <Route path={'/'+page.name} handler={@controllerForPage(page)} name={page.name} key={key} />
          }
          
        </Routes>
      </div>
    </div>

module.exports = DynamicRouter
