export default class Mark {
  constructor () {
    console.log('mark')
    this.initCreate()
  }

  initCreate(){
    $('form').off('submit')
    $('form').submit((e)=>{
      e.preventDefault()
      let $f = $(e.currentTarget)
      $.ajax({
        url: $f.attr('action'),
        method: 'POST',
        data: $f.serialize(),
        success: (r) => {
          $f.closest('.under_photo').replaceWith(r)
        },
        error: (er)=>{
          console.error(er)
          $('button', $f).removeAttr('disabled')
        },
      })
      console.log('submit')
    })
  }
}
