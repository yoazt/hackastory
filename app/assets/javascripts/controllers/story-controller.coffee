angular.module 'hackastory-controllers'

.controller 'StoryController', ($scope, $http, $stateParams) ->

  storyId = $stateParams.id

  setTemplate = ->
    $scope.template = if $scope.story.unlocked
      'unlocked-story.html'
    else
      'locked-story.html'

  $http.get("/stories/#{storyId}").then (response) ->
    $scope.story = response.data.story
    setTemplate()

  $scope.unlock = (aspect) ->
    return if $scope.story.unlocked_by_me

    aspect.loading = true
    $http.post("/stories/#{storyId}/#{aspect.aspect}/unlock")
      .then (response) ->
        $scope.story.unlocked_aspects.push response.data.aspect
        $scope.story.locked_aspects = _.reject(
          $scope.story.locked_aspects,
          (aspect) -> aspect.aspect == response.data.aspect.aspect
        )
        $scope.story.unlocked_by_me = true
        $scope.story.unlocked = response.data.story.unlocked
        setTemplate()
      .finally ->
        aspect.loading = false
