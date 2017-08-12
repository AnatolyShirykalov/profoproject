Page.destroy_all
Menu.destroy_all
h = Menu.create(name: 'Главное', text_slug: 'main').id
Page.create! name: 'Главная', fullpath: '/', menu_ids: [h]
Page.create! name: 'О проекте', fullpath: '/about', menu_ids: [h],
  content: '''
Это интерактивная практическая школа фотографии со Смыслом.
Это уникальная площадка для поиска своего творческого почерка в игровой форме.
Это школа фотовидения на конкурсной основе.
Это первое онлайн реалити-шоу о фотографах.

📷 Множество испытаний фотографов в различных жанрах, условиях, темах и предлагаемых обстоятельствах;
🎯 проверка на широту и глубину мышления, выдержку, гибкость, профессионализм и креативность;
👏 оценка ваших сильных и слабых сторон фотомастерами и тысячами зрителей;
🔎 бесконечная череда экспериментов, выход за зону комфорта, поиск своего творческого почерка и места в Фотографии.
👬 обмен опытом и обучение от профессионалов фотомира, которые заставят участников мыслить Иначе.'''.strip.split("\n").map{|s| "<p>#{s}</p>"}.join("\n")
Page.create! name: 'Группа ВК', fullpath: 'https://vk.com/profoproject', menu_ids: [h]

Rails.application.eager_load!
puts 'Destroy ' + ApplicationRecord.subclasses.map(&:name).join(", ")
ApplicationRecord.subclasses.each(&:destroy_all)

admin_pw = Rails.application.secrets.admin_pw
User.destroy_all
User.create!(email: 'admin@profoproject.ru', password: admin_pw, password_confirmation: admin_pw, role: 'admin')




common_pw = 'qwerty123'
usrs = (1..17).map do
  User.create! email: FFaker::Internet.email, password: common_pw,
    password_confirmation: common_pw, role: 'photograph',
    name: FFaker::NameRU.name
end


t = Tournament.create! name: 'Сезон 9'
stage = t.stages.create! name: 'Внутренняя красота',
  content: '''Понятия красоты меняются практически каждое десятилетие. Но фотографы уже давно доказали, что некрасивых людей нет - есть плохо выставленный свет и неудачные ракурсы.

ТЕМА: ВНУТРЕННЯЯ КРАСОТА (ГАДКИЙ УТЁНОК)
ЖАНР: ДРАМАТИЧЕСКИЙ ПОРТРЕТ

В этом задании вам нужно будет обдуманно подойти к выбору модели. Пол, возраст и другие параметры - это на ваш вкус. Расскажите историю человека в его портрете. Покажите красоту того, кто не вписывается в стандарты красоты. За каждым человеком стоит история его жизни.

Пусть вас не смущает название задания, ведь мы все помним, что из гадких утят получаются прекрасные лебеди!

Драматический портрет — это глубокие тени, высокий контраст, ореол загадочности, возможность раскрыть образ человека в совершенно неожиданном ракурсе. Почитайте статьи о портретах, фотография может быть в любом ключе, может быть цветной или черно-белой - здесь мы не ограничиваем.
Кадрирование - не ниже пояса. Движения модели в кадре не ограничиваются, также Вы можете использовать аксессуары, но не переборщите.
Советуем вдохновиться работами Михаила Шестакова, который был нашим судьёй в седьмом сезоне: https://vk.com/mishest
''',
  sort: 2, deadline: Time.now - 1.day,
  enabled: :true

stage2 = t.stages.create! name: 'Сними чего-нибудь',
  content: 'Так по-мелочи', sort: 3, enabled: true, deadline: Time.now + 10.days


def imgs_from dir
  Dir.glob(Rails.root.join('db', 'seed', 'photo', dir, '*')).map do |path|
    File.open(path)
  end
end

imgs = imgs_from '9.2'
usrs.each_with_index do |u, i|
  t.photographs.push u
  t.save!
  stage.photos.push u.photos.create! photo: imgs[i], enabled: :true, name: FFaker::LoremRU.word, target: 'stage'
  stage.save!
end

imgs_from('puddles').each do |img|
  stage.backstage_photos.create! photo: img, enabled: :true,
    name: FFaker::LoremRU.word, user: usrs[0]
end

mts = %w[Задумка Реализация].map do |name|
  stage.mark_types.create! name: name
end

stage2.mark_types = mts
stage2.save!

3.times do
  j = t.juries.create! name: FFaker::NameRU.name, password: common_pw,
    password_confirmation: common_pw, email: FFaker::Internet.email
  stage.photos.each do |photo|
    mts.each do |mt|
      mt.marks.create! user: j, photo: photo, mark: rand(10) + 1,
        content: FFaker::LoremRU.paragraph
    end
  end
end


TournamentUser.find_each(&:enable!)
