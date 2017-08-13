export default class Album {
  constructor() {
    this.initNewPhoto()
    console.log("album")
  }

  initCreatePhoto(){
    $('form').off('submit')
    $('form').submit((e)=>{
      e.preventDefault()
      $.ajax({
        url: `/photos`,
        type: 'POST',
        data: $(e.target).serialize(),
        success: (data)=>{
          console.log(data)
          $(e.target).remove()
        },
        error: (error)=>{
          console.error(error)
          $('input[type="submit"]', e.target).removeAttr('disabled')
        },
      })
    })
  }

  initNewPhoto(){
    $('.add-photo-button').click((e)=>{
      let $t = $(e.currentTarget)
      $t.attr('disabled', true)
      let src = $t.data('src')
      let stage = $t.data('stage')
      let $f = $('form')
      let $src = $f.data('src')
      let $stage = $f.data('stage')
      $('form').replaceWith(`<button class="btn btn-success add-photo-button" data-src="${$src}" data-stage="${$stage}">Добавить новое фото</button>`)
      //console.log(src, stage)
      $.ajax({
        url: '/photos/new',
        data: {
          src: $t.data('src'),
          stage: $t.data('stage'),
        },
        success: (r)=>{
          $t.replaceWith(r)
          $f = $('form')
          $f.data('src', src)
          $f.data('stage', stage)

          this.initNewPhoto()
          this.initCreatePhoto()
        },
        error: console.error,
      })
    })
  }
}
