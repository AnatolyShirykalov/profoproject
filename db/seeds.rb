admin_pw = Rails.application.secrets.admin_pw
User.destroy_all
User.create!(email: 'admin@profoproject.ru', password: admin_pw, password_confirmation: admin_pw)

Page.destroy_all
Menu.destroy_all
h = Menu.create(name: 'Главное', text_slug: 'main').id
Page.create! name: 'Админка', fullpath: '/admin', menu_ids: [h]
