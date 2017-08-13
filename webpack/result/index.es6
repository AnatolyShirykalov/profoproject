export default class Result {
  constructor() {
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
