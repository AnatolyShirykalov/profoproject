export default class Result {
  constructor() {
    this.initPostResults()
    this.initPostMarks()
  }

  initPostMarks(){
    $('#post-marks').off('click').click((e) => {
      console.log('post-marks')
      let $t = $(e.currentTarget)
      $t.attr('disabled', true)
      $.ajax({
        url: '/stage/post_comments',
        type: 'POST',
        data: {
          album_id: $('#album_id').val(),
          slug: $t.data('slug'),
        },
        success: (data)=>{
          console.log(data)
          alert("Всё вроде загрузилось; Но это неточно")
        }, error: (error)=>{
          console.error(error);
          alert("Всё плохо")
        },
      })
    })
  }

  askForCapcha(cpch){
    new Promise((resolve, reject) => {
      $('#capcha_img').src = cpch
      $('#capcha_form').show()
      $('#capcha_form').submit((e)=>{
        resolve($(e.currentTarget).find('#capcha').val())
      })
    })
  }

  sendMarks(done, capcha){
    $.ajax({
      url: '/stage/post_comments',
      type: 'POST',
      data: {
        slug: $t.data('slug'),
        album_id: 246573605,
        capcha, done,
      },
      success: console.log,
      error: (error) => {
        if (error.capcha) {
          this.askForCapcha(error.capcha).then((cpch)=>{
            sendMarks(error.done, cpch);
          })
        } else console.error(error);
      },
    })
  }


  initPostResults(){
    $('#post-results').off('click').click((e) => {
      console.log('click')
      let $t = $(e.currentTarget)
      $t.attr('disabled', true)
      $.ajax({
        url: '/stage/post',
        type: 'POST',
        data: {slug: $t.data('slug')},
        success: (r)=>{
          console.log(r)
        }, error: (er)=>{
          console.error(er)
          $t.removeAttr('disabled')
        },
      })
    })
  }
}
